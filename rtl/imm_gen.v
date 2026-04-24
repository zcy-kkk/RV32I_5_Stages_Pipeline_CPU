module imm_gen (
    input  wire [31:0] inst,
    output reg  [31:0] imm
);
    localparam I_TYPE = 7'b00?0011;
    localparam S_TYPE = 7'b0100011;
    localparam B_TYPE = 7'b1100011;
    localparam U_TYPE = 7'b0?10111;
    localparam J_TYPE = 7'b1101111;

    wire [6:0] opcode;
    
    assign opcode = inst[6:0];

    always @(*) begin
        casez (opcode)
            I_TYPE: imm = {{20{inst[31]}}, inst[31:20]};
            S_TYPE: imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            B_TYPE: imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
            U_TYPE: imm = {inst[31:12], 12'b0};
            J_TYPE: imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
            default: imm = 32'b0;
        endcase
    end

endmodule