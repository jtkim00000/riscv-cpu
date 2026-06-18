module mem_wb (
    input clk,
    input reset,
    input [31:0] ImmM,
    input [31:0] ALUM,
    input [31:0] MEMM,
    input [31:0] PCPlus4M,
    input [31:0] InstrM,
    //ControlSignalsM
    input [1:0] REG_MUX_M,
    input REG_EN_M,
    output reg [31:0] ImmW,
    output reg [31:0] ALUW,
    output reg [31:0] MEMW,
    output reg [31:0] PCPlus4W,
    output reg [31:0] InstrW,
    //ControlSignalsW
    output reg [1:0] REG_MUX_W, 
    output reg REG_EN_W
);
    always @(posedge clk) begin
        if(reset) begin
            ImmW <= 32'd0;
            ALUW <= 32'd0;
            MEMW <= 32'd0;
            PCPlus4W <= 32'd0;
            InstrW <= 32'd0;

            REG_MUX_W <= 2'd0;
            REG_EN_W <= 1'd0;
        end
        else begin
            ImmW <= ImmM;
            ALUW <= ALUM;
            MEMW <= MEMM;
            PCPlus4W <= PCPlus4M;
            InstrW <= InstrM;

            REG_MUX_W <= REG_MUX_M;
            REG_EN_W <= REG_EN_M;
        end
    end
    
endmodule