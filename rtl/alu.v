module alu #(parameter width = 32) (
    input  wire [3:0]       alu_ctrl,
    input  wire [width-1:0] alu_in1, alu_in2,
    output reg  [width-1:0] alu_out
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

    always @(*) begin
        case(alu_ctrl)
            ALU_ADD: alu_out = alu_in1 + alu_in2;
            ALU_SUB: alu_out = alu_in1 - alu_in2;
            ALU_AND: alu_out = alu_in1 & alu_in2;
            ALU_OR:  alu_out = alu_in1 | alu_in2;
            ALU_XOR: alu_out = alu_in1 ^ alu_in2;
            ALU_SLL: alu_out = alu_in1 << alu_in2[4:0];
            ALU_SRL: alu_out = alu_in1 >> alu_in2[4:0];
            ALU_SRA: alu_out = $signed(alu_in1) >>> alu_in2[4:0];
            ALU_SLT: alu_out = ($signed(alu_in1) < $signed(alu_in2))? 32'b1:32'b0; // Set Less Than (Signed)
            ALU_SLTU:alu_out = (alu_in1 < alu_in2)? 32'b1:32'b0;
            default: alu_out = {width{1'b0}};
        endcase
    end

endmodule