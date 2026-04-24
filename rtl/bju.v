module bju (
    input  wire [6:0]  opcode,
    input  wire [31:0] rs1_data,
    input  wire [31:0] rs2_data,
    input  wire [2:0]  funct3,     
    input  wire [31:0] imm,
    input  wire [31:0] pc_addr,
    output reg         do_jump,
    output reg  [31:0] next_addr
);
    reg branch_taken;
    wire signed [31:0] rs1_signed = rs1_data;
    wire signed [31:0] rs2_signed = rs2_data;

    wire is_branch = (opcode == 7'b1100011);
    wire is_jal    = (opcode == 7'b1101111);
    wire is_jalr   = (opcode == 7'b1100111);

    always @(*) begin
        if (is_branch) begin
            case(funct3)
                3'b000: branch_taken = (rs1_data == rs2_data);     // BEQ
                3'b001: branch_taken = (rs1_data != rs2_data);     // BNE
                3'b100: branch_taken = (rs1_signed < rs2_signed);  // BLT
                3'b101: branch_taken = (rs1_signed >= rs2_signed); // BGE
                3'b110: branch_taken = (rs1_data < rs2_data);      // BLTU
                3'b111: branch_taken = (rs1_data >= rs2_data);     // BGEU
                default: branch_taken = 1'b0;
            endcase
        end 
        else begin
            branch_taken = 1'b0;
        end
    end

    always @(*) begin
        do_jump = branch_taken | is_jal | is_jalr;

        if (is_jalr) begin
            next_addr = (rs1_data + imm) & 32'hFFFF_FFFE;
        end 
        else begin
            next_addr = pc_addr + imm;              
        end
    end

endmodule