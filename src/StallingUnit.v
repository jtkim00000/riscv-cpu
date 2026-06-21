module stalling_unit (
    input [31:0] InstrF,
    input [31:0] InstrD,
    output reg PCMUX,
    output reg InstrMUX
);

    always @(*) begin
        if((InstrD[6:0] == 7'b0000011) && (InstrD[11:7] != 5'd0) && ((InstrD[11:7] == InstrF[19:15]) || (InstrD[11:7] == InstrF[24:20]))) begin
            PCMUX = 1'b1;
            InstrMUX = 1'b1;
        end
        else begin
            PCMUX = 1'b0;
            InstrMUX = 1'b0;
        end
    end


endmodule