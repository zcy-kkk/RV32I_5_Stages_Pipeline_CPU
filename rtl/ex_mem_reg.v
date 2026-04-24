module ex_mem_reg (
    input   wire        clk,
    input   wire        ena,
    input   wire        reset,
    input   wire        ex_mem_read,
    input   wire        ex_mem_write,
    input   wire        ex_mem_to_reg,
    input   wire        ex_reg_write,
    input   wire [31:0] ex_inst,
    input   wire [31:0] ex_alu_out,
    input   wire [31:0] ex_rs2_data,
    output  reg  [31:0] mem_inst,
    output  reg  [31:0] mem_alu_out,
    output  reg  [31:0] mem_rs2_data,
    output  reg         mem_mem_read,
    output  reg         mem_mem_write,
    output  reg         mem_mem_to_reg,
    output  reg         mem_reg_write
);

    always @(posedge clk) begin
        if (reset) begin
            mem_inst <= 32'b0;
            mem_rs2_data <= 32'b0;
            mem_alu_out <= 32'b0;
            mem_mem_read <= 1'b0;
            mem_mem_write <= 1'b0;
            mem_mem_to_reg <= 1'b0;
            mem_reg_write <= 1'b0;
        end
        else if (ena) begin
            mem_inst <= ex_inst;
            mem_rs2_data <= ex_rs2_data;
            mem_alu_out <= ex_alu_out;
            mem_mem_read <= ex_mem_read;
            mem_mem_write <= ex_mem_write;
            mem_mem_to_reg <= ex_mem_to_reg;
            mem_reg_write <= ex_reg_write;
        end
    end

    assign ena = 1'b1;

endmodule