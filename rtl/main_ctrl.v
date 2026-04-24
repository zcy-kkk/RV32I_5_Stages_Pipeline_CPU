module main_ctrl (
    input  wire [6:0] opcode, // connect to inst[6:0]
    output wire       mem_read,
    output wire       mem_write,
    output wire       mem_to_reg,
    output wire [1:0] alu_op,
    output wire       alu_src,
    output wire       reg_write
);

    localparam OP_R_TYPE = 7'b0110011; // add, sub, and, or, slt...
    localparam OP_I_TYPE = 7'b0010011; // addi, ori, slti...
    localparam OP_LOAD   = 7'b0000011; // lw
    localparam OP_STORE  = 7'b0100011; // sw
    localparam OP_BRANCH = 7'b1100011; // beq

    reg [6:0] controls;

    assign {mem_read, mem_write, mem_to_reg, alu_op, alu_src, reg_write} = controls;

    always @(*) begin
        case(opcode)
            OP_R_TYPE: controls = 7'b0_0_0_10_0_1;
            OP_I_TYPE: controls = 7'b0_0_0_10_1_1;
            OP_LOAD:   controls = 7'b1_0_1_00_1_1;
            OP_STORE:  controls = 7'b0_1_0_00_1_0;
            OP_BRANCH: controls = 7'b0_0_0_01_0_0; 
            default:   controls = 7'b0;
        endcase 
    end

endmodule