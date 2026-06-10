`timescale 1ns/1ps

module tb_DataMemory;

    reg clk, we, sz;
    reg [1:0] num_bytes;
    reg [31:0] addr, wdata;

    wire [31:0] rdata;

    data_memory test_data_memory(
        .clk(clk),
        .we(we),
        .sz(sz),
        .num_bytes(num_bytes),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        we = 1'b0;
        num_bytes = 2'b11;

        $dumpfile("sim/data_memory.vcd");
        $dumpvars(0, tb_DataMemory);

        // simple write and then read
        we = 1'b1; addr = 32'd15; wdata = 32'd42;

        @(posedge clk);

        we = 1'b0;

        @(posedge clk);

        if(rdata != 32'd42)
            $display("FAIL DATAMEM WR: expected 42, got %d");
        else
            $display("PASS DATAMEM WR");


        repeat (15) @(posedge clk);

        // Retains value test

        if(rdata != 32'd42)
            $display("FAIL DATAMEM RETAIN: expected 42, got %d");
        else
            $display("PASS DATAMEM RETAIN");


        @(posedge clk);

        // wrong write
        we = 1'b0; addr = 32'd15; wdata = 32'd100;

        @(posedge clk);

        we = 1'b0;

        @(posedge clk);

        if(rdata != 32'd42)
            $display("FAIL DATAMEM W: expected 42, got %d");
        else
            $display("PASS DATAMEM W");

        @(posedge clk);

        //testing SEXT and ZEXT
        we = 1'b1; addr = 32'd2; wdata = 8'hFF; num_bytes = 2'b00; sz = 1'b1; //1 byte

        @(posedge clk);

        we = 1'b0;

        @(posedge clk);

        if(rdata != -32'd1)
            $display("FAIL DATAMEM SEXT: expected -1, got %d");
        else
            $display("PASS DATAMEM SEXT");

        sz = 1'b0;

        @(posedge clk);


        @(posedge clk);

        if(rdata != 32'd255)
            $display("FAIL DATAMEM ZEXT: expected 255, got %d");
        else
            $display("PASS DATAMEM ZEXT");



        $finish;
    end


endmodule