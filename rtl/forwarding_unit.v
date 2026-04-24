module forwarding_unit(
    input  wire        mem_reg_write,
    input  wire        wb_reg_write,
    input  wire [31:0] ex_inst,
    input  wire [31:0] mem_inst,
    input  wire [31:0] wb_inst,
    output reg  [1:0]  forwarding_src1, //case 00, don't forwarding; case 01, forwarding from ex_mem_reg;case 10, forwarding from mem_wb_reg. 
    output reg  [1:0]  forwarding_src2
);

    wire [4:0] alu_rs1;
    wire [4:0] alu_rs2;
    wire [4:0] ex_mem_reg_rd;
    wire [4:0] mem_wb_reg_rd;

    assign alu_rs1 = ex_inst[19:15];
    assign alu_rs2 = ex_inst[24:20];
    assign ex_mem_reg_rd = mem_inst[11:7];
    assign mem_wb_reg_rd = wb_inst[11:7];

    always @(*) begin
        if (mem_reg_write && (ex_mem_reg_rd == alu_rs1) && (ex_mem_reg_rd != 5'b0)) begin
            forwarding_src1 = 2'b01;
        end
        else if (wb_reg_write && (mem_wb_reg_rd == alu_rs1) && (mem_wb_reg_rd != 5'b0)) begin
            forwarding_src1 = 2'b10;
        end
        else begin
            forwarding_src1 = 2'b00;
        end 
    end

    always @(*) begin
        if (mem_reg_write && (ex_mem_reg_rd == alu_rs2) && (ex_mem_reg_rd != 5'b0)) begin
            forwarding_src2 = 2'b01;
        end
        else if (wb_reg_write && (mem_wb_reg_rd == alu_rs2) && (mem_wb_reg_rd != 5'b0)) begin
            forwarding_src2 = 2'b10;
        end
        else begin
            forwarding_src2 = 2'b00;
        end 
    end

endmodule