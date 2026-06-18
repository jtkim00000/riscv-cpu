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

    assign WIRED4_F = 32'd4;

    //pUT THIS INTO EXECUTE
    assign FLUSH_E = JUMP_E | (BR_EN_E & ALUE[0]);

    // ==================== MODULES ====================

    // iNSTRUCTION FETCH
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
        .raddr2(RS2D)
    );




endmodule