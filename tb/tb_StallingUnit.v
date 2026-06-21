`timescale 1ns/1ps

module tb_StallingUnit;

    reg [31:0] InstrF;
    reg [31:0] InstrD;
    wire PCMUX;
    wire InstrMUX;

    stalling_unit test_stalling_unit (
        .InstrF(InstrF),
        .InstrD(InstrD),
        .PCMUX(PCMUX),
        .InstrMUX(InstrMUX)
    );

    initial begin
        $dumpfile("sim/stalling_unit.vcd");
        $dumpvars(0, tb_StallingUnit);


        InstrD[6:0] = 7'd0; InstrD[11:7] = 5'd3; InstrF[19:15] = 5'd3; InstrF[24:20] = 5'd3;

        #10;

        if(PCMUX != 1'd0 || InstrMUX != 1'd0)
            $display("FAIL ST1: expected PCMUX = 0, InstrMUX = 0, got PCMUX = %0d, InstrMUX = %d0", PCMUX, InstrMUX);
        else
            $display("PASS ST1");

        InstrD[6:0] = 7'd3; InstrD[11:7] = 5'd0; InstrF[19:15] = 5'd0; InstrF[24:20] = 5'd0;

        #10;

        if(PCMUX != 1'd0 || InstrMUX != 1'd0)
            $display("FAIL ST2: expected PCMUX = 0, InstrMUX = 0, got PCMUX = %0d, InstrMUX = %d0", PCMUX, InstrMUX);
        else
            $display("PASS ST2");

        InstrD[6:0] = 7'd3; InstrD[11:7] = 5'd5; InstrF[19:15] = 5'd5; InstrF[24:20] = 5'd0;

        #10;

        if(PCMUX != 1'd1 || InstrMUX != 1'd1)
            $display("FAIL ST3: expected PCMUX = 1, InstrMUX = 1 got PCMUX = %0d, InstrMUX = %d0", PCMUX, InstrMUX);
        else
            $display("PASS ST3");

        InstrD[6:0] = 7'd3; InstrD[11:7] = 5'd7; InstrF[19:15] = 5'd5; InstrF[24:20] = 5'd7;

        #10;

        if(PCMUX != 1'd1 || InstrMUX != 1'd1)
            $display("FAIL ST4: expected PCMUX = 1, InstrMUX = 1 got PCMUX = %0d, InstrMUX = %d0", PCMUX, InstrMUX);
        else
            $display("PASS ST4");

        InstrD[6:0] = 7'd3; InstrD[11:7] = 5'd9; InstrF[19:15] = 5'd5; InstrF[24:20] = 5'd7;

        #10;

        if(PCMUX != 1'd0 || InstrMUX != 1'd0)
            $display("FAIL ST5: expected PCMUX = 0, InstrMUX = 0, got PCMUX = %0d, InstrMUX = %d0", PCMUX, InstrMUX);
        else
            $display("PASS ST5");


        $finish;
    end


endmodule