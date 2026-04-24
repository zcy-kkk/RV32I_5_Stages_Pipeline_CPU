MODULE ?= top

# --- Directory Configuration ---
RTL_DIR = rtl
TB_DIR = tb
SIM_DIR = sim
SW_DIR = sw

# --- Software Cross-Compilation Toolchain ---
CC = riscv64-unknown-elf-gcc
OBJCOPY = riscv64-unknown-elf-objcopy
CFLAGS = -march=rv32i -mabi=ilp32 -O1 -nostdlib

# --- File Path Configuration ---
# Auto-detect: If top module, include all RTL files. Otherwise, include only the specific module.
ifeq ($(MODULE), top)
	DESIGN = $(wildcard $(RTL_DIR)/*.v)
else
	DESIGN = $(RTL_DIR)/$(MODULE).v
endif

TESTBENCH = $(TB_DIR)/$(MODULE)_tb.v
OUTPUT = $(SIM_DIR)/$(MODULE)_sim.vvp
WAVE = $(SIM_DIR)/$(MODULE)_wave.vcd
FIRMWARE_HEX = firmware.hex

# --- Default Compilation Targets ---
# If compiling top, run the software pipeline first; otherwise, skip software.
ifeq ($(MODULE), top)
all: $(SIM_DIR) software compile run wave

DRAW_DEPS = $(SIM_DIR) software 
else
all: $(SIM_DIR) compile run wave
DRAW_DEPS = $(SIM_DIR)
endif

# --- 1. Create Simulation Directory ---
$(SIM_DIR):
	mkdir -p $(SIM_DIR)

# --- 2. Software Compilation Pipeline (C -> ELF -> BIN -> HEX) ---
software: $(FIRMWARE_HEX)

# Recompile firmware only if C/Assembly/Linker source files change
$(FIRMWARE_HEX): $(SW_DIR)/main.c $(SW_DIR)/start.S $(SW_DIR)/link.ld
	@echo "🚀 [1/4] Compiling C to ELF..."
	$(CC) $(CFLAGS) -T $(SW_DIR)/link.ld $(SW_DIR)/start.S $(SW_DIR)/main.c -o $(SW_DIR)/firmware.elf
	@echo "📦 [2/4] Extracting pure binary..."
	$(OBJCOPY) -O binary $(SW_DIR)/firmware.elf $(SW_DIR)/firmware.bin
	@echo "📜 [3/4] Generating Hex machine code..."
	hexdump -v -e '1/4 "%08x\n"' $(SW_DIR)/firmware.bin > $(FIRMWARE_HEX)

# --- 3. Hardware Compilation Pipeline (Verilog -> VVP) ---
compile:
	@echo "🛠️  [4/4] Compiling Verilog RTL..."
	iverilog -o $(OUTPUT) $(DESIGN) $(TESTBENCH)

# --- 4. Run Simulation ---
run:
	@echo "⚡ Running Simulation..."
	vvp $(OUTPUT)

# --- 5. Open Waveform ---
wave:
	@echo "🌊 Opening GTKWave..."
	gtkwave $(WAVE) &

# ==========================================
# 🎨 6. RTL to SVG Drawing Pipeline
# ==========================================
.PHONY: draw draw-flat

# Default target: Keep module-level hierarchical structure
draw: $(DRAW_DEPS)
	@echo "🚀 [Yosys] Generating netlist for $(MODULE)..."
	yosys -p "prep -top $(MODULE); write_json $(SIM_DIR)/$(MODULE)_netlist.json" $(DESIGN)
	@echo "🎨 [netlistsvg] Rendering SVG schematic..."
	netlistsvg $(SIM_DIR)/$(MODULE)_netlist.json -o $(SIM_DIR)/$(MODULE)_schematic.svg
	@echo "🖌️  [Fix] Injecting white background into SVG..."
	sed -i 's/<svg /<svg style="background-color: white;" /' $(SIM_DIR)/$(MODULE)_schematic.svg
	@echo "✅ Done! Schematic saved to $(SIM_DIR)/$(MODULE)_schematic.svg"

# Flattened target: Smash all modules into a global gate-level netlist
draw-flat: $(DRAW_DEPS)
	@echo "🚀 [Yosys] Generating FLATTENED netlist for $(MODULE)..."
	yosys -p "prep -top $(MODULE) -flatten; write_json $(SIM_DIR)/$(MODULE)_flat.json" $(DESIGN)
	@echo "🎨 [netlistsvg] Rendering flattened SVG schematic..."
	netlistsvg $(SIM_DIR)/$(MODULE)_flat.json -o $(SIM_DIR)/$(MODULE)_flat.svg
	@echo "🖌️  [Fix] Injecting white background into SVG..."
	sed -i 's/<svg /<svg style="background-color: white;" /' $(SIM_DIR)/$(MODULE)_flat.svg
	@echo "✅ Done! Flattened schematic saved to $(SIM_DIR)/$(MODULE)_flat.svg"