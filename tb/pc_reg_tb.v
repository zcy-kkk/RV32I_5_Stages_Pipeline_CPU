`timescale 1ns / 1ps

module pc_reg_tb;
    reg         clk;
    reg         arest;
    reg         rw;
    reg  [31:0] next_addr;
    wire [31:0] addr;

    pc_reg u_pc_reg (
        .clk(clk),
        .arest(arest),
        .rw(rw),
        .next_addr(next_addr),
        .addr(addr)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/pc_reg_wave.vcd");
        $dumpvars(0, pc_reg_tb);

        clk = 0;
        arest = 0;
        rw = 0;
        next_addr = 32'hA000_B000;

        // --- Test 1: Asynchronous Reset ---
        #3;           // Trigger reset at a random time (not aligned with clock)
        arest = 1;
        #10;
        arest = 0;    // Release reset
        #5;

        // --- Test 2: Normal Incrementation (PC + 4) ---
        // We let the clock run for several cycles. 
        // Expected behavior: PC should go 0 -> 4 -> 8 -> 12...
        rw = 0;
        #40; 

        // --- Test 3: Jump / Write Enable (PC = next_addr) ---
        // Expected: On the next posedge clk, PC should load next_addr
        rw = 1;
        #10;
        rw = 0;       // Stop jumping, return to normal +4 increment
        #20;

        // --- Test 4: Mid-cycle Asynchronous Reset ---
        // Triggering reset halfway through a clock cycle to prove it's ASYNC
        #2; 
        arest = 1;
        #5;
        arest = 0;

        #20;
        $finish;
    end

endmodule    
    

