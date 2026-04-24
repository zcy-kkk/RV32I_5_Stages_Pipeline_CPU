module top(
    input wire clk,
    input wire arest,
    //debug
    output wire [31:0] debug_pc,
    output wire [31:0] debug_alu_out,
    output wire [31:0] debug_mem_data
);
    //imem
    wire [31:0] if_inst; 
    
    //pc
    wire [31:0] if_pc_addr;

    //if_id_reg
    wire [31:0] id_inst;
    wire [31:0] id_pc_addr;
 
    //bju
    wire        do_jump;
    wire [31:0] next_addr;

    //reg_file
    wire [31:0] id_rs1_data;
    wire [31:0] id_rs2_data;
    wire [31:0] write_back_data;

    //imm_gen
    wire [31:0] id_imm;

    //id_ex_reg
    wire [31:0] ex_inst;
    wire [31:0] ex_rs1_data;
    wire [31:0] ex_rs2_data;
    wire [31:0] ex_imm;
    wire        ex_alu_src;
    wire [1:0]  ex_alu_op;
    wire        ex_mem_read;
    wire        ex_mem_write;
    wire        ex_mem_to_reg;
    wire        ex_reg_write;     

    //forwarding_unit
    wire [1:0] forwarding_src1;
    wire [1:0] forwarding_src2;
    
    //forwarding mux2
    wire [31:0] forwarding_data2;

    //alu
    wire [3:0]  alu_ctrl_signal;
    wire [31:0] ex_alu_out;
    wire [31:0] dmem_to_reg;
    wire [31:0] alu_data2;
    wire [31:0] alu_src1_data;
    wire [31:0] alu_src2_data;

    //main controller signals
    wire       id_alu_src;
    wire       id_reg_write;       
    wire       id_mem_read;
    wire       id_mem_write;
    wire       id_mem_to_reg;
    wire [1:0] id_alu_op;

    //ex_mem_reg
    wire [31:0] mem_inst;
    wire [31:0] mem_alu_out;
    wire [31:0] mem_rs2_data;
    wire        mem_mem_read;
    wire        mem_mem_write;
    wire        mem_mem_to_reg;
    wire        mem_reg_write;

    //dmem
    wire [31:0] mem_read_data;

    //mem_wb_reg
    wire [31:0] wb_read_data;
    wire [31:0] wb_alu_out;
    wire [31:0] wb_inst;
    wire        wb_reg_write;
    wire        wb_mem_to_reg;
    
    //MUXs
    assign write_back_data = wb_mem_to_reg ? wb_read_data : wb_alu_out;
    assign alu_data2 = ex_alu_src? ex_imm : forwarding_data2;

    //debug
    assign debug_pc = id_pc_addr;               
    assign debug_alu_out = ex_alu_out;     
    assign debug_mem_data = mem_alu_out;   

    pc_reg u_pc_reg(
        //in
        .clk(clk),
        .arest(arest),
        .rw(do_jump),
        .next_addr(next_addr),
        //out
        .addr(if_pc_addr)
    );

    imem u_imem(
        //in
        .pc_addr(if_pc_addr),
        //out
        .inst(if_inst)
    );
    
    if_id_reg u_if_id_reg(
        //in
        .clk(clk),
        .if_inst(if_inst),
        .if_pc_addr(if_pc_addr),
        //out
        .id_inst(id_inst),
        .id_pc_addr(id_pc_addr)
    );

    main_ctrl u_main_ctrl(
        //in
        .opcode(id_inst[6:0]),
        //out
        .mem_read(id_mem_read),
        .mem_write(id_mem_write),
        .mem_to_reg(id_mem_to_reg),
        .alu_op(id_alu_op),
        .alu_src(id_alu_src),
        .reg_write(id_reg_write)
    );
    
    bju u_bju(
        //in
        .opcode(id_inst[6:0]),
        .rs1_data(id_rs1_data),
        .rs2_data(id_rs2_data),
        .funct3(id_inst[14:12]),
        .imm(id_imm),
        .pc_addr(id_pc_addr),
        //out
        .do_jump(do_jump),
        .next_addr(next_addr)
    );

    reg_file u_reg_file(
        //in
        .clk(clk),
        .wrt_ena(wb_reg_write),
        .rs1_addr(id_inst[19:15]),
        .rs2_addr(id_inst[24:20]),
        .rd_addr(wb_inst[11:7]),
        .rd_data(write_back_data),
        //out
        .rs1_out(id_rs1_data),
        .rs2_out(id_rs2_data)
    );

    imm_gen u_imm_gen(
        //in
        .inst(id_inst),
        //out
        .imm(id_imm)
    );

    id_ex_reg u_id_ex_reg(
        //in
        .clk(clk),
        .id_inst(id_inst),
        .id_rs1_data(id_rs1_data),
        .id_rs2_data(id_rs2_data),
        .id_imm(id_imm),
        .id_alu_op(id_alu_op),
        .id_alu_src(id_alu_src),
        .id_mem_read(id_mem_read),
        .id_mem_write(id_mem_write),
        .id_mem_to_reg(id_mem_to_reg),
        .id_reg_write(id_reg_write),
        //out
        .ex_inst(ex_inst),
        .ex_rs1_data(ex_rs1_data),
        .ex_rs2_data(ex_rs2_data),
        .ex_imm(ex_imm),
        .ex_alu_op(ex_alu_op),
        .ex_alu_src(ex_alu_src),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_reg_write(ex_reg_write)
    );

    forwarding_unit u_forwarding_unit(
        //in
        .mem_reg_write(mem_reg_write),
        .wb_reg_write(wb_reg_write),
        .ex_inst(ex_inst),
        .mem_inst(mem_inst),
        .wb_inst(wb_inst),
        //out
        .forwarding_src1(forwarding_src1),
        .forwarding_src2(forwarding_src2)
    );
    
    data_forwarding_mux_src1 u_data_forwarding_mux_src1(
        //in
        .forwarding_src1(forwarding_src1),
        .ex_rs1_data(ex_rs1_data),
        .mem_alu_out(mem_alu_out),
        .write_back_data(write_back_data),
        //out
        .alu_src1_data(alu_src1_data)
    );

    data_forwarding_mux_src2 u_data_forwarding_mux_src2(
        //in
        .forwarding_src2(forwarding_src2),
        .ex_alu_data2(ex_rs2_data),
        .mem_alu_out(mem_alu_out),
        .write_back_data(write_back_data),
        //out
        .alu_src2_data(forwarding_data2)
    );

    alu u_alu(
        //in
        .alu_ctrl(alu_ctrl_signal),
        .alu_in1(alu_src1_data),
        .alu_in2(alu_data2),
        //out
        .alu_out(ex_alu_out)
    );

    alu_ctrl u_alu_ctrl(
        //in
        .alu_op(ex_alu_op),
        .funct3(ex_inst[14:12]),
        .inst_30(ex_inst[30]),
        .inst_5(ex_inst[5]),
        //out
        .alu_ctrl(alu_ctrl_signal)
    );

    ex_mem_reg u_ex_mem_reg(
        //in
        .clk(clk),
        .ex_inst(ex_inst),
        .ex_alu_out(ex_alu_out),
        .ex_rs2_data(forwarding_data2),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_reg_write(ex_reg_write),
        //out
        .mem_inst(mem_inst),
        .mem_alu_out(mem_alu_out),
        .mem_rs2_data(mem_rs2_data),
        .mem_mem_read(mem_mem_read),
        .mem_mem_write(mem_mem_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_reg_write(mem_reg_write)
    );

    dmem u_dmem(
        //in
        .clk(clk),
        .we(mem_mem_write),
        .mem_read(mem_mem_read),
        .addr(mem_alu_out),
        .write_data(mem_rs2_data),
        //out
        .read_data(mem_read_data)
    );

    mem_wb_reg u_mem_wb_reg(
        //in
        .clk(clk),
        .mem_inst(mem_inst),
        .mem_read_data(mem_read_data),
        .mem_alu_out(mem_alu_out),
        .mem_reg_write(mem_reg_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        //out
        .wb_inst(wb_inst),
        .wb_read_data(wb_read_data),
        .wb_alu_out(wb_alu_out),
        .wb_reg_write(wb_reg_write),
        .wb_mem_to_reg(wb_mem_to_reg)
    );

endmodule