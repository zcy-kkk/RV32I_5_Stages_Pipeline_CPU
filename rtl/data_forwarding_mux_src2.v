module data_forwarding_mux_src2(
    input  wire [1:0]  forwarding_src2,
    input  wire [31:0] ex_alu_data2,
    input  wire [31:0] mem_alu_out,
    input  wire [31:0] write_back_data,
    output reg  [31:0] alu_src2_data
);

    always @(*) begin
        case (forwarding_src2)
            2'b01:   alu_src2_data = mem_alu_out;
            2'b10:   alu_src2_data = write_back_data;
            default: alu_src2_data = ex_alu_data2;
        endcase
    end

endmodule