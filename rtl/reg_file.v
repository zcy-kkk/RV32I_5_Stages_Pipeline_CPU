module reg_file (
    input  wire wrt_ena, clk,
    
    input  wire [4:0]  rs1_addr,
    output wire [31:0] rs1_out,
    
    input  wire [4:0]  rs2_addr,
    output wire [31:0] rs2_out,
    
    input  wire [4:0]  rd_addr,
    input  wire [31:0] rd_data
);

reg [31:0] rs [31:0]; // initiate 2d array

assign rs1_out = (rs1_addr == 5'b0) ? 32'd0 : rs[rs1_addr];
assign rs2_out = (rs2_addr == 5'b0) ? 32'd0 : rs[rs2_addr];

always @(posedge clk) begin
    rs[0] <= 32'b0;
    if (wrt_ena && (rd_addr != 5'b0)) begin
        rs[rd_addr] <= rd_data;
    end
end

endmodule