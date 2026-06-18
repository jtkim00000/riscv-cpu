module p_cpu (input clk, input reset);

    // ==================== WIRES ====================

    // INSTRUCION FETCH
    wire [31:0] PCMUX_OUT, PCF, WIRED4_F, InstrF, PCPlus4F;

    // INSTRUCTION DECODE
    wire [31:0] PCD, InstrD, PCPlus4D, ImmD, RS1D, RS2D;
    wire [1:0] REG_MUX_D;
    wire REG_EN_D;
    wire WE_D;
    wire SZ_D;
    wire [1:0] NUM_BYTES_D;
    wire JUMP_D;
    wire JALR_D;
    wire [3:0] ALU_SEL_D;
    wire ALUMUX1_D;
    wire ALUMUX2_D;
    wire BR_EN_D;

    // EXECUTE
    wire [31:0] PCE, ImmE, RS1E, RS2E, PCPlus4E, PCPlusImmE, ALUE, ALUMUX1_OUT, ALUMUX2_OUT, JALRMUX_OUT, CTAddrE, InstrE;
    wire FLUSH_E;
    wire [1:0] REG_MUX_E;
    wire REG_EN_E;
    wire WE_E;
    wire SZ_E;
    wire [1:0] NUM_BYTES_E;
    wire JUMP_E;
    wire JALR_E;
    wire [3:0] ALU_SEL_E;
    wire ALUMUX1_E;
    wire ALUMUX2_E;
    wire BR_EN_E;

    // MEMORY
    wire [31:0] ImmM, ALUM, RS2M, PCPlus4M, MEMM, InstrM;
    wire [1:0] REG_MUX_M;
    wire REG_EN_M;
    wire WE_M;
    wire SZ_M;
    wire [1:0] NUM_BYTES_M;

    // WRITEBACK
    wire [31:0] ImmW, ALUW, MEMW, PCPlus4W, WBDataW, InstrW;
    wire [1:0] REG_MUX_W; 
    wire REG_EN_W;

    // ==================== MODULES ====================

    // iNSTRUCTION FETCH

    assign WIRED4_F = 32'd4;

    program_counter program_counter (
        .clk(clk),
        .reset(reset),
        .wdata(PCMUX_OUT),
        .rdata(PCF)
    );

    instruction_memory instruction_memory (
        .raddr(PCF),
        .instr(InstrF)
    );

    alu pc_plus_4 (
        .a(PCF),
        .b(WIRED4_F),
        .sel(4'd0),
        .s(PCPlus4F)
    );

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(2), .SELECT_BITS(1)) pcmux (
        .data_in({CTAddrE, PCPlus4F}),
        .sel(FLUSH_E),
        .out(PCMUX_OUT)
    );

    // IF/ID REGISTER

    if_id if_id (
        .clk(clk),
        .FLUSH_E(FLUSH_E),
        .reset(reset),
        .PCF(PCF),
        .InstrF(InstrF),
        .PCPlus4F(PCPlus4F),
        .PCD(PCD),
        .InstrD(InstrD),
        .PCPlus4D(PCPlus4D)
    );

    // INSTRUCTION DECODE

    immediate_generator immediate_generator (
        .data_in(InstrD),
        .data_out(ImmD)
    );

    register_file register_file(
        .clk(clk),
        .we(REG_EN_W),
        .raddr1(InstrD[19:15]),
        .raddr2(InstrD[24:20]),
        .waddr(InstrW[11:7]),
        .wdata(WBDataW),
        .rdata1(RS1D),
        .rdata2(RS2D)
    );

    control_unit control_unit (
        .instr(InstrD),
        .reg_en(REG_EN_D),
        .regmux(REG_MUX_D),
        .alumux1(ALUMUX1_D),
        .alumux2(ALUMUX2_D),
        .alu_sel(ALU_SEL_D),
        .jump(JUMP_D),
        .br_en(BR_EN_D),
        .jalr(JALR_D),
        .we(WE_D),
        .sz(SZ_D),
        .num_bytes(NUM_BYTES_D)
    );

    // ID/EX REGISTER

    id_ex id_ex (
        .clk(clk),
        .FLUSH_E(FLUSH_E),
        .reset(reset),
        .PCD(PCD),
        .ImmD(ImmD),
        .RS1D(RS1D),
        .RS2D(RS2D),
        .PCPlus4D(PCPlus4D),
        .InstrD(InstrD),
        .REG_MUX_D(REG_MUX_D),
        .REG_EN_D(REG_EN_D),
        .WE_D(WE_D),
        .SZ_D(SZ_D),
        .NUM_BYTES_D(NUM_BYTES_D),
        .JUMP_D(JUMP_D),
        .JALR_D(JALR_D),
        .ALU_SEL_D(ALU_SEL_D),
        .ALUMUX1_D(ALUMUX1_D),
        .ALUMUX2_D(ALUMUX2_D),
        .BR_EN_D(BR_EN_D),
        .PCE(PCE),
        .ImmE(ImmE),
        .RS1E(RS1E),
        .RS2E(RS2E),
        .PCPlus4E(PCPlus4E),
        .InstrE(InstrE),
        .REG_MUX_E(REG_MUX_E),
        .REG_EN_E(REG_EN_E),
        .WE_E(WE_E),
        .SZ_E(SZ_E),
        .NUM_BYTES_E(NUM_BYTES_E),
        .JUMP_E(JUMP_E),
        .JALR_E(JALR_E),
        .ALU_SEL_E(ALU_SEL_E),
        .ALUMUX1_E(ALUMUX1_E),
        .ALUMUX2_E(ALUMUX2_E),
        .BR_EN_E(BR_EN_E)
    );

    // EXECUTE

    assign FLUSH_E = JUMP_E | (BR_EN_E & ALUE[0]);

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(2), .SELECT_BITS(1)) alumux1 (
        .data_in({RS1E, PCE}),
        .sel(ALUMUX1_E),
        .out(ALUMUX1_OUT)
    );

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(2), .SELECT_BITS(1)) alumux2 (
        .data_in({ImmE, RS2E}),
        .sel(ALUMUX2_E),
        .out(ALUMUX2_OUT)
    );

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(2), .SELECT_BITS(1)) jalrmux (
        .data_in({{ALUE[31:1], 1'b0}, ALUE}),
        .sel(JALR_E),
        .out(JALRMUX_OUT)
    );


    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(2), .SELECT_BITS(1)) jumpmux (
        .data_in({JALRMUX_OUT, PCPlusImmE}),
        .sel(JUMP_E),
        .out(CTAddrE)
    );

    alu alu (
        .a(ALUMUX1_OUT),
        .b(ALUMUX2_OUT),
        .sel(ALU_SEL_E),
        .s(ALUE)
    );

    alu pc_plus_imm (
        .a(PCE),
        .b(ImmE),
        .sel(4'd0),
        .s(PCPlusImmE)
    );

    // EX/MEM REGISTER

    ex_mem ex_mem (
        .clk(clk),
        .reset(reset),
        .ImmE(ImmE),
        .ALUE(ALUE),
        .RS2E(RS2E),
        .PCPlus4E(PCPlus4E),
        .InstrE(InstrE),
        .REG_MUX_E(REG_MUX_E),
        .REG_EN_E(REG_EN_E),
        .WE_E(WE_E),
        .SZ_E(SZ_E),
        .NUM_BYTES_E(NUM_BYTES_E),
        .ImmM(ImmM),
        .ALUM(ALUM),
        .RS2M(RS2M),
        .PCPlus4M(PCPlus4M),
        .InstrM(InstrM),
        .REG_MUX_M(REG_MUX_M),
        .REG_EN_M(REG_EN_M),
        .WE_M(WE_M),
        .SZ_M(SZ_M),
        .NUM_BYTES_M(NUM_BYTES_M)
    );

    // MEMORY

    data_memory data_memory (
        .clk(clk),
        .we(WE_M),
        .sz(SZ_M),
        .num_bytes(NUM_BYTES_M),
        .addr(ALUM),
        .wdata(RS2M),
        .rdata(MEMM)
    );

    // MEM/WB REGISTER

    mem_wb mem_wb (
        .clk(clk),
        .reset(reset),
        .ImmM(ImmM),
        .ALUM(ALUM),
        .MEMM(MEMM),
        .PCPlus4M(PCPlus4M),
        .InstrM(InstrM),
        .REG_MUX_M(REG_MUX_M),
        .REG_EN_M(REG_EN_M),
        .ImmW(ImmW),
        .ALUW(ALUW),
        .MEMW(MEMW),
        .PCPlus4W(PCPlus4W),
        .InstrW(InstrW),
        .REG_MUX_W(REG_MUX_W), 
        .REG_EN_W(REG_EN_W)
    );

    // WRITEBACK

    mux #(.DATA_WIDTH(32), .INPUT_WIDTH(4), .SELECT_BITS(2)) writebackmux (
        .data_in({ImmW, ALUW, MEMW, PCPlus4W}),
        .sel(REG_MUX_W),
        .out(WBDataW)
    );


endmodule