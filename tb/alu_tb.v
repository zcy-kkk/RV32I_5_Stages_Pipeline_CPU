`timescale 1ns / 1ps

module alu_tb;

    // Inputs
    reg [3:0] alu_ctrl;
    reg [31:0] alu_in1;
    reg [31:0] alu_in2;

    // Outputs
    wire [31:0] alu_out;
    wire zero;

    alu uut (
        .alu_ctrl(alu_ctrl),
        .alu_in1(alu_in1),
        .alu_in2(alu_in2),
        .alu_out(alu_out),
        .zero(zero)
    );

    initial begin

        $dumpfile("sim/alu_wave.vcd");
        $dumpvars(0, alu_tb);

        alu_in1 = 0; alu_in2 = 0; alu_ctrl = 0;
        #10;

        // Test 1: ADD (15 + 10 = 25) -> ALU_ADD = 4'b0000
        alu_in1 = 32'd15; alu_in2 = 32'd10; alu_ctrl = 4'b0000;
        #10;

        // Test 2: SUB (15 - 10 = 5) -> ALU_SUB = 4'b0001
        alu_in1 = 32'd15; alu_in2 = 32'd10; alu_ctrl = 4'b0001;
        #10;

        // Test 3: AND (15 & 10) -> ALU_AND = 4'b0100
        alu_in1 = 32'd15; alu_in2 = 32'd10; alu_ctrl = 4'b0100;
        #10;

        // Test 4: Check Zero Flag (15 - 15 = 0)
        alu_in1 = 32'd15; alu_in2 = 32'd15; alu_ctrl = 4'b0001;
        #10;

        // Test 5: SLT (Set Less Than, 10 < 15 is true) -> ALU_SLT = 4'b1011
        alu_in1 = 32'd10; alu_in2 = 32'd15; alu_ctrl = 4'b1011;
        #10;

        $finish;
    end

endmodule