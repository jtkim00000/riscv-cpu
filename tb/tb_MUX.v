`timescale 1ns/1ps

module tb_MUX;

    reg [15:0] in1, in2, in3, in4;
    reg [2:0] in33, in32, in31;
    reg [1:0] sel, sel3;

    wire [15:0] out2, out4;
    wire [2:0] out3;

    mux #(.DATA_WIDTH(16), .INPUT_WIDTH(2), .SELECT_BITS(1)) test_mux_2 (
        .data_in({in2, in1}),
        .sel(sel[0]),
        .out(out2)
    );
    mux #(.DATA_WIDTH(16), .INPUT_WIDTH(4), .SELECT_BITS(2)) test_mux_4 (
        .data_in({in4, in3, in2, in1}),
        .sel(sel),
        .out(out4)
    );

    mux #(.DATA_WIDTH(3), .INPUT_WIDTH(3), .SELECT_BITS(2)) test_mux_3 (
        .data_in({in33, in32, in31}),
        .sel(sel),
        .out(out3)
    );


    initial begin
        $dumpfile("sim/mux.vcd");
        $dumpvars(0, tb_MUX);

        //initialization
        in1 = 16'd42; in2 = 16'd0; in3 = 16'd1; in4 = 16'd7;
        in33 = 3'd0; in32 = 3'd7; in31 = 3'd2;

        // 2 16-bit input (1 select bit)
        sel[0] = 1'b0;
        #10;
        if (out2 != 16'd42)
            $display("FAIL MUX2 1: expected 42, got %0d", out2);
        else   
            $display("PASS MUX2 1");

        sel[0] = 1'b1;
        #10;
        if (out2 != 16'd0)
            $display("FAIL MUX2 2: expected 0, got %0d", out2);
        else   
            $display("PASS MUX2 2");

        // 4 16-bit input (2 select bits)
        sel = 2'b00;
        #10;
        if (out4 != 16'd42)
            $display("FAIL MUX4 1: expected 42, got %0d", out4);
        else   
            $display("PASS MUX4 1");

        sel = 2'b01;
        #10;
        if (out4 != 16'd0)
            $display("FAIL MUX4 2: expected 0, got %0d", out4);
        else   
            $display("PASS MUX4 2");

        sel = 2'b10;
        #10;
        if (out4 != 16'd1)
            $display("FAIL MUX4 3: expected 1, got %0d", out4);
        else   
            $display("PASS MUX4 3");

        sel = 2'b11;
        #10;
        if (out4 != 16'd7)
            $display("FAIL MUX4 4: expected 7, got %0d", out4);
        else   
            $display("PASS MUX4 4");

        // 3 3-bit input (2 select bits)
        sel3 = 2'b00;
        #10;
        if (out3 != 3'd2)
            $display("FAIL MUX3 1: expected 2, got %0d", out4);
        else   
            $display("PASS MUX3 1");

        sel3 = 2'b01;
        #10;
        if (out3 != 3'd7)
            $display("FAIL MUX3 2: expected 7, got %0d", out4);
        else   
            $display("PASS MUX3 2");

        sel3 = 2'b10;
        #10;
        if (out3 != 3'd0)
            $display("FAIL MUX3 3: expected 0, got %0d", out4);
        else   
            $display("PASS MUX3 3");

        $finish;
    end

endmodule