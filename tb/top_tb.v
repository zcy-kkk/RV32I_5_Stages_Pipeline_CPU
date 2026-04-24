`timescale 1ns / 1ps

module top_tb();

    // 1. Declare stimulus signals (Power and clock to drive the motherboard)
    reg clk;
    reg arest;

    // 2. Instantiate your motherboard (top.v) and connect it to the testbench
    top u_top (
        .clk(clk),
        .arest(arest)
    );

    // 3. Generate system heartbeat (50MHz clock, 20ns period)
    always #10 clk = ~clk;

    // 4. Main test procedure (Power-on sequence)
    
    integer i;

    initial begin
        // Turn on the waveform recorder to generate a VCD file
        $dumpfile("sim/top_wave.vcd");
        $dumpvars(0, top_tb);
        
        for (i = 0; i < 32; i = i + 1) begin
            $dumpvars(0, u_top.u_reg_file.rs[i]); 
        end

        // Step A: Initial state, press the reset button (Active-high reset)
        clk = 0;
        arest = 1; 

        // Step B: Hold the reset state for a short time to clear all components
        #25;
        arest = 0; // Release reset, the CPU starts executing instructions!

        // Step C: Let the machine run (Enough time to finish the 3 instructions)
        #5000;

        // Step D: Pull the plug, end the simulation
        $display("Simulation Finished! Check your CPU wave!");
        $finish;
    end
    
endmodule