module alu_ctrl (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire       inst_30,
    input  wire       inst_5,
    output reg [3:0] alu_ctrl
);
    localparam ALU_ADD  = 4'b0000; 
    localparam ALU_SUB  = 4'b0001; 
    localparam ALU_AND  = 4'b0100; 
    localparam ALU_OR   = 4'b0101; 
    localparam ALU_XOR  = 4'b0110; 
    localparam ALU_SLL  = 4'b1000; 
    localparam ALU_SRL  = 4'b1001; 
    localparam ALU_SRA  = 4'b1010; 
    localparam ALU_SLT  = 4'b1011; 
    localparam ALU_SLTU = 4'b1100;

    wire [6:0] ctrl_signals = {alu_op, funct3, inst_30, inst_5};   

    always @(*) begin
        casez(ctrl_signals)
            7'b00_???_?_?: alu_ctrl = ALU_ADD;
            7'b01_???_?_?: alu_ctrl = ALU_SUB;
            7'b10_000_0_1: alu_ctrl = ALU_ADD;
            7'b10_000_1_1: alu_ctrl = ALU_SUB; 
            7'b10_000_?_0: alu_ctrl = ALU_ADD;
            7'b10_111_?_?: alu_ctrl = ALU_AND;
            7'b10_110_?_?: alu_ctrl = ALU_OR;
            7'b10_100_?_?: alu_ctrl = ALU_XOR;
            7'b10_001_0_?: alu_ctrl = ALU_SLL;
            7'b10_101_0_?: alu_ctrl = ALU_SRL;
            7'b10_101_1_?: alu_ctrl = ALU_SRA;
            7'b10_010_?_?: alu_ctrl = ALU_SLT;
            7'b10_011_?_?: alu_ctrl = ALU_SLTU;
            default: alu_ctrl = ALU_ADD;
        endcase
    end
endmodule