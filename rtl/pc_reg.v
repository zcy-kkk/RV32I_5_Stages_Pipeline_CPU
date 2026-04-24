module pc_reg (
    input  wire        clk, 
    input  wire        arest, 
    input  wire        rw,
    input  wire [31:0] next_addr,
    output reg  [31:0] addr
);
    always @(posedge clk or posedge arest) begin
        if (arest) begin
            addr <= 32'b0;
        end
        else if (rw) begin
            addr <= next_addr;
        end
        else begin
            addr <= addr + 32'b100;
        end
    end
endmodule