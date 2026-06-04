`timescale 1ns/1ps

module tb_DataMemory;

    reg clk, we, re;
    reg [31:0] addr, wdata;

    wire [31:0] rdata;

    data_memory test_data_memory(
        .clk(clk),
        .we(we),
        .re(re),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        we = 1'b0;
        re = 1'b0;

        $dumpfile("sim/data_memory.vcd");
        $dumpvars(0, tb_DataMemory);

        // simple write and then read
        we = 1'b1; addr = 32'd15; wdata = 32'd42;

        @(posedge clk);

        we = 1'b0; re = 1'b1;

        @(posedge clk);

        if(rdata != 32'd42)
            $display("FAIL DATAMEM WR: expected 42, got %d");
        else
            $display("PASS DATAMEM WR");

        re = 1'b0;

        repeat (15) @(posedge clk);

        // Retains value test
        re = 1'b1; 

        if(rdata != 32'd42)
            $display("FAIL DATAMEM RETAIN: expected 42, got %d");
        else
            $display("PASS DATAMEM RETAIN");

        re = 1'b0; 

        @(posedge clk);

        // Wrong read
        we = 1'b1; addr = 32'd42; wdata = 32'd67;

        @(posedge clk);

        we = 1'b0; re = 1'b0;

        @(posedge clk);

        if(rdata != 32'd42)
            $display("FAIL DATAMEM R1: expected 42, got %d");
        else
            $display("PASS DATAMEM R1");

        re = 1'b0;

        @(posedge clk);

        re = 1'b1;

        @(posedge clk);

        if(rdata != 32'd67)
            $display("FAIL DATAMEM R2: expected 67, got %d");
        else
            $display("PASS DATAMEM R2");

        re = 1'b0;

        @(posedge clk);

        // wrong write
        we = 1'b0; addr = 32'd15; wdata = 32'd100;

        @(posedge clk);

        we = 1'b0; re = 1'b0;

        @(posedge clk);

        if(rdata != 32'd42)
            $display("FAIL DATAMEM W: expected 42, got %d");
        else
            $display("PASS DATAMEM W");

        re = 1'b0;

        @(posedge clk);



        $finish;
    end


endmodule