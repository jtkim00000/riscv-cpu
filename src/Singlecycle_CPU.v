module cpu (input clk, input reset);

    //Wires inbetween components
    wire [31:0] data_mem_out, alu_out, rs1_out, rs2_out, instr_out, imm_out, pc_out;
    wire [31:0] alumux1_out, alumux2_out, regmux_out, jumpmux_out, brmux_out, brextmux_out, jalrmux_out;
    wire [31:0] wired_four, adder1_out, adder2_out;

    //Control signals
    wire reg_en, alumux1_sel, alumux2_sel, we, sz, br_en, jump, jalr;
    wire [1:0] regmux_sel, num_bytes;
    wire [3:0] alu_sel;

    assign wired_four = 32'd4;

    alu alu (
        .a(alumux1_out),
        .b(alumux2_out),
        .sel(alu_sel),
        .s(alu_out)
    );

    data_memory data_memory (
        .clk(clk),
        .we(we),
        .sz(sz),
        .num_bytes(num_bytes),
        .addr(alu_out),
        .wdata(rs2_out),
        .rdata(data_mem_out)
    );

    register_file register_file (
        .clk(clk),
        .we(reg_en),
        .raddr1(instr_out[19:15]),
        .raddr2(instr_out[24:20]),
        .waddr(instr_out[11:7]),
        .wdata(regmux_out),
        .rdata1(rs1_out),
        .rdata2(rs2_out)
    );

    instruction_memory instruction_memory (
        .raddr(pc_out),
        .instr(instr_out)
    );

    program_counter pc (
        .clk(clk),
        .reset(reset),
        .wdata(jumpmux_out),
        .rdata(pc_out)
    );

    immediate_generator immediate_generator (
        .data_in(instr_out),
        .data_out(imm_out)
    );

    alu adder1 (
        .a(pc_out),
        .b(brmux_out),
        .sel(4'b0000),
        .s(adder1_out)
    );

    alu adder2 (
        .a(pc_out),
        .b(wired_four),
        .sel(4'b0000),
        .s(adder2_out)
    );

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(2), .SELECT_BITS(1)) jumpmux (
        .data_in({jalrmux_out, adder1_out}),
        .sel(jump),
        .out(jumpmux_out)
    );

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(2), .SELECT_BITS(1)) brmux (
        .data_in({brextmux_out, wired_four}),
        .sel(br_en),
        .out(brmux_out)
    );

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(2), .SELECT_BITS(1)) brextmux (
        .data_in({imm_out, wired_four}),
        .sel(alu_out[0]),
        .out(brextmux_out)
    );

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(2), .SELECT_BITS(1)) jalrmux (
        .data_in({{alu_out[31:1], 1'b0}, alu_out}),
        .sel(jalr),
        .out(jalrmux_out)
    );

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(2), .SELECT_BITS(1)) alumux1 (
        .data_in({rs1_out, pc_out}),
        .sel(alumux1_sel),
        .out(alumux1_out)
    );

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(2), .SELECT_BITS(1)) alumux2 (
        .data_in({imm_out, rs2_out}),
        .sel(alumux2_sel),
        .out(alumux2_out)
    );

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(4), .SELECT_BITS(2)) regmux (
        .data_in({imm_out, data_mem_out, alu_out, adder2_out}),
        .sel(regmux_sel),
        .out(regmux_out)
    );

    control_unit control_unit (
        .instr(instr_out),
        .reg_en(reg_en),
        .regmux(regmux_sel),
        .alumux1(alumux1_sel),
        .alumux2(alumux2_sel),
        .alu_sel(alu_sel),
        .jump(jump),
        .br_en(br_en),
        .jalr(jalr),
        .we(we),
        .sz(sz),
        .num_bytes(num_bytes)
    );

endmodule