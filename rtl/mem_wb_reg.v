module mem_wb_reg (
    input   wire        clk,
    input   wire        ena,
    input   wire        reset,
    input   wire [31:0] mem_inst,
    input   wire [31:0] mem_read_data,
    input   wire        mem_reg_write,
    input   wire        mem_mem_to_reg,
    input   wire [31:0] mem_alu_out,
    output  reg  [31:0] wb_inst,
    output  reg  [31:0] wb_read_data,
    output  reg  [31:0] wb_alu_out,
    output  reg         wb_reg_write,
    output  reg         wb_mem_to_reg
);

    always @(posedge clk) begin
        if (reset) begin
            wb_inst <= 32'b0;
            wb_read_data <= 32'b0;
            wb_alu_out <= 32'b0;
            wb_mem_to_reg <= 1'b0;
            wb_reg_write <= 1'b0;
        end
        else if (ena) begin
            wb_inst <= mem_inst;
            wb_read_data <= mem_read_data;
            wb_alu_out <= mem_alu_out;
            wb_mem_to_reg <= mem_mem_to_reg;
            wb_reg_write <= mem_reg_write;
        end
    end

    assign ena = 1'b1;

endmodule