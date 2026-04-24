module imem_tb;
    reg  [31:0] pc_addr;
    wire [31:0] inst;

    imem u_imem(
        .pc_addr(pc_addr),
        .inst(inst)
    );

    initial begin
        $dumpfile("sim/imem_wave.vcd");
        $dumpvars(0, imem_tb);
        // --- Time 0: Initialization ---
        // At this exact moment, $readmemh inside imem will load "firmware.hex"
        pc_addr = 32'd0;
        
        // Wait 10ns to observe the first instruction
        // Expected inst: 32'h00500093 (addi x1, x0, 5)
        #10; 

        // --- Fetch Second Instruction ---
        pc_addr = 32'd4;
        // Expected inst: 32'h00a00113 (addi x2, x0, 10)
        #10;

        // --- Fetch Third Instruction ---
        pc_addr = 32'd8;
        // Expected inst: 32'h002081b3 (add x3, x1, x2)
        #10;

        // --- Fetch Out of Bounds (Empty Memory) ---
        pc_addr = 32'd12;
        // Expected inst: 32'hxxxxxxxx (Unknown/Uninitialized state in Verilog)
        #10;

        $finish;
    end

endmodule