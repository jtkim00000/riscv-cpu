module if_id (
    input clk,
    input FLUSH_E,
    input reset,
    input [31:0] PCF,
    input [31:0] InstrF,
    input [31:0] PCPlus4F,
    output reg [31:0] PCD,
    output reg [31:0] InstrD,
    output reg [31:0] PCPlus4D
);

    always @(posedge clk) begin
        if(reset | FLUSH_E) begin
            PCD <= 32'd0;
            InstrD <= 32'd0;
            PCPlus4D <= 32'd0;
        end
        else begin
            PCD <= PCF;
            InstrD <= InstrF;
            PCPlus4D <= PCPlus4F;
        end

    end

endmodule