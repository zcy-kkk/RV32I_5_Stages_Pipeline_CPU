module dmem(
    input  wire        clk,
    input  wire        we,
    input  wire        mem_read,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
 );

    reg[31:0] ram[0:1023];

    always @(posedge clk) begin
        if(we)
            ram[addr[11:2]] <= write_data;
    end

    assign read_data = mem_read? ram[addr[11:2]] : 32'b0;
 
endmodule