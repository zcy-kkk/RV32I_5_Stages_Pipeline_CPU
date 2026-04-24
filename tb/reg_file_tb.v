`timescale 1ns / 1ps

module reg_file_tb;

    // -----------------------------------------------------------------------
    // 1. Declare Testbench Signals
    // Inputs to the module are 'reg', outputs are 'wire'
    // -----------------------------------------------------------------------
    reg         clk;
    reg         wrt_ena;
    reg  [4:0]  rs1_addr;
    reg  [4:0]  rs2_addr;
    reg  [4:0]  rd_addr;
    reg  [31:0] rd_data;

    wire [31:0] rs1_out;
    wire [31:0] rs2_out;

    // -----------------------------------------------------------------------
    // 2. Instantiate the Register File
    // Notice the 'u_' prefix for the instance name!
    // -----------------------------------------------------------------------
    reg_file u_reg_file (
        .clk(clk),
        .wrt_ena(wrt_ena),
        .rs1_addr(rs1_addr),
        .rs1_out(rs1_out),
        .rs2_addr(rs2_addr),
        .rs2_out(rs2_out),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );

    // -----------------------------------------------------------------------
    // 3. Clock Generation (The Heartbeat)
    // Toggle the clock every 5 time units to create a 10-unit period clock
    // -----------------------------------------------------------------------
    always #5 clk = ~clk;

    // -----------------------------------------------------------------------
    // 4. Main Test Sequence
    // -----------------------------------------------------------------------
    initial begin
        // Setup GTKWave output
        $dumpfile("sim/reg_file_wave.vcd");
        $dumpvars(0, reg_file_tb);

        // Initialize all inputs to 0 to prevent 'x' (unknown) states
        clk = 0;
        wrt_ena = 0;
        rs1_addr = 5'd0;
        rs2_addr = 5'd0;
        rd_addr  = 5'd0;
        rd_data  = 32'd0;

        // Wait for 1 full clock cycle (10ns) before starting tests
        #10;

        // --- Test Case 1: The x0 Trap ---
        // Try to write 0xDEADBEEF into register 0. It should be ignored.
        wrt_ena = 1'b1;
        rd_addr = 5'd0;
        rd_data = 32'hDEADBEEF;
        #10; 

        // Read x0 to verify it is still 0
        wrt_ena = 1'b0; // Turn off write enable
        rs1_addr = 5'd0;
        #10;

        // --- Test Case 2: Normal Write and Read ---
        // Write 0x12345678 into register 5 (x5)
        wrt_ena = 1'b1;
        rd_addr = 5'd5;
        rd_data = 32'h12345678;
        #10;

        // --- Test Case 3: Dual-Port Read and Write Enable Check ---
        // Try to write 0x87654321 into register 10, but keep 'wrt_ena' OFF
        wrt_ena = 1'b0;
        rd_addr = 5'd10;
        rd_data = 32'h87654321;
        
        // Simultaneously read x5 and x10
        rs1_addr = 5'd5;  // Should output 0x12345678
        rs2_addr = 5'd10; // Should output 0x00000000 (because write failed)
        #10;

        // End the simulation
        $finish;
    end

endmodule