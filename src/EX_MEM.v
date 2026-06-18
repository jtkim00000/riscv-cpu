module ex_mem (
    input clk,
    input reset,
    input [31:0] ImmE,
    input [31:0] ALUE,
    input [31:0] RS2E,
    input [31:0] PCPlus4E,
    input [31:0] InstrE,
    //ControlSignalsE
    input [1:0] REG_MUX_E,
    input REG_EN_E,
    input WE_E,
    input SZ_E,
    input [1:0] NUM_BYTES_E,
    output reg [31:0] ImmM,
    output reg [31:0] ALUM,
    output reg [31:0] RS2M,
    output reg [31:0] PCPlus4M,
    output reg [31:0] InstrM,
    //ControlSignalsM
    output reg [1:0] REG_MUX_M,
    output reg REG_EN_M,
    output reg WE_M,
    output reg SZ_M,
    output reg [1:0] NUM_BYTES_M
);

    always @(posedge clk) begin
        if(reset) begin
            ImmM <= 32'd0;
            ALUM <= 32'd0;
            RS2M <= 32'd0;
            PCPlus4M <= 32'd0;
            InstrM <= 32'd0;

            REG_MUX_M <= 2'd0;
            REG_EN_M <= 1'd0;
            WE_M <= 1'd0;
            SZ_M <= 1'd0;
            NUM_BYTES_M <= 2'd0;
        end
        else begin
            ImmM <= ImmE;
            ALUM <= ALUE;
            RS2M <= RS2E;
            PCPlus4M <= PCPlus4E;
            InstrM <= InstrE;

            REG_MUX_M <= REG_MUX_E;
            REG_EN_M <= REG_EN_E;
            WE_M <= WE_E;
            SZ_M <= SZ_E;
            NUM_BYTES_M <= NUM_BYTES_E;
        end
    end

endmodule