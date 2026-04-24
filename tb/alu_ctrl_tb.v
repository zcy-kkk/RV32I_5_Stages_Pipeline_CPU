`timescale 1ns / 1ps

module alu_control_tb;

    // Inputs must be declared as 'reg' because we drive their values in the initial block
    reg [1:0] alu_op;
    reg [2:0] funct3;
    reg       inst_30;

    // Outputs from the instantiated module must be declared as 'wire'
    wire [3:0] alu_ctrl;

    // Instantiate the Unit Under Test (UUT)
    alu_control uut (
        .alu_op(alu_op),
        .funct3(funct3),
        .inst_30(inst_30),
        .alu_ctrl(alu_ctrl)
    );

    initial begin
        // Setup waveform generation for GTKWave
        $dumpfile("sim/alu_ctrl_wave.vcd");
        $dumpvars(0, alu_control_tb);

        // -----------------------------------------------------------
        // Test Cases for ALU Control
        // -----------------------------------------------------------
        
        // 1. Test Load/Store (ALUOp = 00) -> Expected: ALU_ADD (0000)
        alu_op = 2'b00; funct3 = 3'b010; inst_30 = 1'b0; 
        #10;
        
        // 2. Test Branch (ALUOp = 01) -> Expected: ALU_SUB (0001)
        alu_op = 2'b01; funct3 = 3'b000; inst_30 = 1'b0; 
        #10;

        // 3. Test R-type ADD (ALUOp = 10, funct3 = 000, inst_30 = 0) -> Expected: ALU_ADD (0000)
        alu_op = 2'b10; funct3 = 3'b000; inst_30 = 1'b0; 
        #10;

        // 4. Test R-type SUB (ALUOp = 10, funct3 = 000, inst_30 = 1) -> Expected: ALU_SUB (0001)
        alu_op = 2'b10; funct3 = 3'b000; inst_30 = 1'b1; 
        #10;

        // 5. Test R-type AND (ALUOp = 10, funct3 = 111, inst_30 = don't care) -> Expected: ALU_AND (0100)
        alu_op = 2'b10; funct3 = 3'b111; inst_30 = 1'b0; 
        #10;

        // 6. Test R-type SRA (ALUOp = 10, funct3 = 101, inst_30 = 1) -> Expected: ALU_SRA (1010)
        alu_op = 2'b10; funct3 = 3'b101; inst_30 = 1'b1; 
        #10;

        // 7. Test R-type SLT (ALUOp = 10, funct3 = 010, inst_30 = don't care) -> Expected: ALU_SLT (1011)
        alu_op = 2'b10; funct3 = 3'b010; inst_30 = 1'b1;
    // End simulation
        $finish;
    end

endmodule