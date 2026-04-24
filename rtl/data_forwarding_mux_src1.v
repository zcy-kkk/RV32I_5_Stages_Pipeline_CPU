module data_forwarding_mux_src1(
    input  wire [1:0]  forwarding_src1,
    input  wire [31:0] ex_rs1_data,
    input  wire [31:0] mem_alu_out,
    input  wire [31:0] write_back_data,
    output reg  [31:0] alu_src1_data
);

    always @(*) begin
        case (forwarding_src1)
            2'b01:   alu_src1_data = mem_alu_out;
            2'b10:   alu_src1_data = write_back_data;
            default: alu_src1_data = ex_rs1_data;
        endcase
    end

endmodule