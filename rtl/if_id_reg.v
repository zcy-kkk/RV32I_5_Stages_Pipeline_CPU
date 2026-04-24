module if_id_reg (
    input  wire        clk,
    input  wire        ena,
    input  wire        reset,
    input  wire [31:0] if_inst,
    input  wire [31:0] if_pc_addr,
    output reg  [31:0] id_inst,
    output reg  [31:0] id_pc_addr
);

    always @(posedge clk) begin
        if (reset) begin
            id_inst <= 32'b0;
            id_pc_addr <= 32'b0;
        end
        else if (ena) begin
            id_inst <= if_inst;
            id_pc_addr <= if_pc_addr;
        end
    end

    assign ena = 1'b1;

endmodule