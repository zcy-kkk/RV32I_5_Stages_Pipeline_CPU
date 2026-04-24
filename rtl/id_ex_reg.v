module id_ex_reg (
    input   wire        clk,
    input   wire        ena,
    input   wire        reset,
    input   wire        id_alu_src,
    input   wire [1:0]  id_alu_op,
    input   wire        id_mem_read,
    input   wire        id_mem_write,
    input   wire        id_mem_to_reg,
    input   wire        id_reg_write,
    input   wire [31:0] id_inst,
    input   wire [31:0] id_rs1_data,
    input   wire [31:0] id_rs2_data,
    input   wire [31:0] id_imm,
    output  reg         ex_alu_src,
    output  reg  [1:0]  ex_alu_op,
    output  reg  [31:0] ex_inst,
    output  reg  [31:0] ex_rs1_data,
    output  reg  [31:0] ex_rs2_data,
    output  reg  [31:0] ex_imm,
    output  reg         ex_mem_read,
    output  reg         ex_mem_write,
    output  reg         ex_mem_to_reg,
    output  reg         ex_reg_write
);

    always @(posedge clk) begin
        if (reset) begin
            ex_inst <= 32'b0;
            ex_rs1_data <= 32'b0;
            ex_rs2_data <= 32'b0;
            ex_imm <= 32'b0;
            ex_alu_src <= 1'b0;
            ex_alu_op <= 2'b0;
            ex_mem_read <= 1'b0;
            ex_mem_write <= 1'b0;
            ex_mem_to_reg <= 1'b0;
            ex_reg_write <= 1'b0;
        end
        else if (ena) begin
            ex_inst <= id_inst;
            ex_rs1_data <= id_rs1_data;
            ex_rs2_data <= id_rs2_data;
            ex_imm <= id_imm;
            ex_alu_src <= id_alu_src;
            ex_alu_op <= id_alu_op;
            ex_mem_read <= id_mem_read;
            ex_mem_write <= id_mem_write;
            ex_mem_to_reg <= id_mem_to_reg;
            ex_reg_write <= id_reg_write;
        end
    end

    assign ena = 1'b1;

endmodule