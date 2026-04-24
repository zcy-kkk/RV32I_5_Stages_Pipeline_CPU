module imem (
    input  wire [31:0] pc_addr,
    output wire [31:0] inst
);
    reg [31:0] rom [0:1023];
    
    initial begin
        $readmemh("firmware.hex", rom);
    end

    assign inst = rom[pc_addr[11:2]];

endmodule