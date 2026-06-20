module forwarding_unit (
    input [31:0] InstrE,
    input [31:0] InstrM,
    input [31:0] InstrW,
    input REG_EN_M,
    input REG_EN_W,
    output reg [1:0] RS1_MUX,
    output reg [1:0] RS2_MUX
);

    always @(*) begin
        //rs1
        if((InstrE[19:15] == InstrM[11:7]) && (InstrM[11:7] != 5'd0) && REG_EN_M) 
            RS1_MUX = 2'd1;
        else if((InstrE[19:15] == InstrW[11:7]) && (InstrW[11:7] != 5'd0) && REG_EN_W) 
            RS1_MUX = 2'd2;
        else 
            RS1_MUX = 2'd0;
        

        //rs2
        if((InstrE[24:20] == InstrM[11:7]) && (InstrM[11:7] != 5'd0) && REG_EN_M) 
            RS2_MUX = 2'd1;
        else if((InstrE[24:20] == InstrW[11:7]) && (InstrW[11:7] != 5'd0) && REG_EN_W) 
            RS2_MUX = 2'd2;
        else 
            RS2_MUX = 2'd0;

    end

endmodule