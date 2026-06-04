`timescale 1ns/1ps

module tb_ProgramCounter;

    reg [31:0] wdata;

    reg clk;
    wire [31:0] rdata;

    program_counter test_program_counter (
        .clk(clk),
        .wdata(wdata),
        .rdata(rdata)
    );

    initial begin

        clk = 1'b0;

        $dumpfile("sim/program_counter.vcd");
        $dumpvars(0, tb_ProgramCounter);

        // simple read and writes
        wdata = 32'd15;

        #10;
        clk = 1'b1;
        #10;
        clk = 1'b0;

        if(rdata != 32'd15)
            $display("FAIL WPC1: expected 15, got %d", rdata);
        else
            $display("PASS WPC1");

        wdata = 32'd42;

        #10;
        clk = 1'b1;
        #10;
        clk = 1'b0;

        if(rdata != 32'd42)
            $display("FAIL WPC2: expected 42, got %d", rdata);
        else
            $display("PASS WPC2");

        //retain value
        #1000;

        if(rdata != 32'd42)
            $display("FAIL PC Retain: expected 42, got %d", rdata);
        else
            $display("PASS PC Retain");

        wdata = 32'd1;

        #10;
        clk = 1'b1;
        #10;
        clk = 1'b0;

        if(rdata != 32'd1)
            $display("FAIL WPC3: expected 1, got %d", rdata);
        else
            $display("PASS WPC3");

        //Incorrect Clock Cycle

        wdata = 32'd1;

        #10;
        clk = 1'b0; //wrong clock
        #10;
        clk = 1'b0;

        if(rdata != 32'd1)
            $display("FAIL PC CLK: expected 1, got %d", rdata);
        else
            $display("PASS PC CLK");

        $finish;
    end

endmodule