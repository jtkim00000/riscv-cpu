`timescale 1ns/1ps

module tb_ForwardingUnit;

    reg [31:0] InstrE, InstrM, InstrW;

    reg REG_EN_M, REG_EN_W;

    wire [1:0] RS1_MUX, RS2_MUX;

    forwarding_unit test_forwarding_unit (
        .InstrE(InstrE),
        .InstrM(InstrM),
        .InstrW(InstrW),
        .REG_EN_M(REG_EN_M),
        .REG_EN_W(REG_EN_W),
        .RS1_MUX(RS1_MUX),
        .RS2_MUX(RS2_MUX)
    );

    initial begin
        $dumpfile("sim/tb_forwarding_unit.vcd");
        $dumpvars(0, tb_ForwardingUnit);

        InstrE[19:15] = 5'd5; InstrM[11:7] = 5'd5; InstrW[11:7] = 5'd3; 
        REG_EN_M = 1'd1; REG_EN_W = 1'd1;

        #10;

        if(RS1_MUX != 2'd1)
            $display("FAIL F1 RS1: expected 1, got %0d", RS1_MUX);
        else if (RS2_MUX != 2'd0)
            $display("FAIL F1 RS1: expected 0, got %0d", RS2_MUX);
        else
            $display("PASS F1");

        InstrE[24:20] = 5'd3;

        #10;

        if(RS1_MUX != 2'd1)
            $display("FAIL F2 RS1: expected 1, got %0d", RS1_MUX);
        else if (RS2_MUX != 2'd2)
            $display("FAIL F2 RS2: expected 2, got %0d", RS2_MUX);
        else
            $display("PASS F2");

        REG_EN_M = 1'd0; REG_EN_W = 1'd0;

        #10;

        if(RS1_MUX != 2'd0)
            $display("FAIL F2 RS1: expected 0, got %0d", RS1_MUX);
        else if (RS2_MUX != 2'd0)
            $display("FAIL F2 RS2: expected 0, got %0d", RS2_MUX);
        else
            $display("PASS F2");

        InstrE[19:15] = 5'd2; InstrM[11:7] = 5'd2; InstrW[11:7] = 5'd2; 
        REG_EN_M = 1'd1; REG_EN_W = 1'd1;

        #10;

        if(RS1_MUX != 2'd1)
            $display("FAIL F2 RS1: expected 1, got %0d", RS1_MUX);
        else if (RS2_MUX != 2'd0)
            $display("FAIL F2 RS2: expected 0, got %0d", RS2_MUX);
        else
            $display("PASS F2");

        $finish;
    end

endmodule