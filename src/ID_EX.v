module id_ex (
    input clk,
    input FLUSH_E,
    input reset,
    input [31:0] PCD,
    input [31:0] ImmD,
    input [31:0] RS1D,
    input [31:0] RS2D,
    input [31:0] PCPlus4D,
    //ControlSignalsD
    input [1:0] REG_MUX_D,
    input REG_EN_D,
    input WE_D,
    input SZ_D,
    input [1:0] NUM_BYTES_D,
    input JUMP_D,
    input JALR_D,
    input [3:0] ALU_SEL_D,
    input ALUMUX1_D,
    input ALUMUX2_D,
    input BR_EN_D,
    output reg [31:0] PCE,
    output reg [31:0] ImmE,
    output reg [31:0] RS1E,
    output reg [31:0] RS2E,
    output reg [31:0] PCPlus4E,
    //ControlSignalsE
    output reg [1:0] REG_MUX_E,
    output reg REG_EN_E,
    output reg WE_E,
    output reg SZ_E,
    output reg [1:0] NUM_BYTES_E,
    output reg JUMP_E,
    output reg JALR_E,
    output reg [3:0] ALU_SEL_E,
    output reg ALUMUX1_E,
    output reg ALUMUX2_E,
    output reg BR_EN_E
);

    always @(posedge clk) begin
        if(FLUSH_E | reset) begin
            PCE <= 32'd0;
            ImmE <= 32'd0;
            RS1E <= 32'd0;
            RS2E <= 32'd0;
            PCPlus4E <= 32'd0;

            REG_MUX_E <= 2'd0;
            REG_EN_E <= 1'd0;
            WE_E <= 1'd0;
            SZ_E <= 1'd0;
            NUM_BYTES_E <= 2'd0;
            JUMP_E <= 1'd0;
            JALR_E <= 1'd0;
            ALU_SEL_E <= 4'd0;
            ALUMUX1_E <= 1'd0;
            ALUMUX2_E <= 1'd0;
            BR_EN_E <= 1'd0;
        end
        else begin
            PCE <= PCD;
            ImmE <= ImmD;
            RS1E <= RS1D;
            RS2E <= RS2D;
            PCPlus4E <= PCPlus4D;

            REG_MUX_E <= REG_MUX_D;
            REG_EN_E <= REG_EN_D;
            WE_E <= WE_D;
            SZ_E <= SZ_D;
            NUM_BYTES_E <= NUM_BYTES_D;
            JUMP_E <= JUMP_D;
            JALR_E <= JALR_D;
            ALU_SEL_E <= ALU_SEL_D;
            ALUMUX1_E <= ALUMUX1_D;
            ALUMUX2_E <= ALUMUX2_D;
            BR_EN_E <= BR_EN_D;
        end

    end

endmodule