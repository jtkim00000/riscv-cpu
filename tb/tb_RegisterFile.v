`timescale 1ns/1ps

module tb_RegisterFile;

    reg clk;
    reg we;
    
    reg [4:0] raddr1;
    reg [4:0] raddr2;
    reg [4:0] waddr;

    reg [31:0] wdata;

    wire [31:0] rdata1;
    wire [31:0] rdata2;

    register_file test_register_file (
        .clk(clk),
        .we(we),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );    

    always #20 clk = ~clk;

    initial begin
        clk = 1'b0;

        $dumpfile("sim/register_file.vcd");
        $dumpvars(0, tb_RegisterFile);
        
        //simple write then read test (WR = Write then Read)
        we = 1'b1; waddr = 5'd5; wdata = 32'd42; 

        @(posedge clk) 
        #2;
        we = 1'b0; raddr1 = 5'd5; raddr2 = 5'd5;
        #10
        if (rdata1 != 32'd42)
            $display("FAIL WR DATA1: expected 42, got %0d", rdata1);
        else if(rdata2 != 32'd42)
            $display("FAIL WR DATA2: expected 42, got %0d", rdata2);
        else
            $display("PASS WR");

        //write to register[0]
        we = 1'b1; waddr = 5'd0; wdata = 32'd42; 

        @(posedge clk)
        #2;
        we = 1'b0; raddr1 = 5'd0; raddr2 = 5'd0;
        #10
        if (rdata1 != 32'd0)
            $display("FAIL W to 0: expected 0, got %0d", rdata1);
        else if(rdata2 != 32'd0)
            $display("FAIL W to 0: expected 0, got %0d", rdata2);
        else
            $display("PASS W to 0");

        //write but incorrect we
        we = 1'b0; waddr = 5'd10; wdata = 32'd35; 

        @(posedge clk)
        #2;
        we = 1'b0; raddr1 = 5'd10; raddr2 = 5'd10;
        #10
        if (rdata1 != 32'd0)
            $display("FAIL W we0: expected 0, got %0d", rdata1);
        else if(rdata2 != 32'd0)
            $display("FAIL W we0: expected 0, got %0d", rdata2);
        else
            $display("PASS W we0");

        //Reading from two different places at once
        we = 1'b1; waddr = 5'd10; wdata = 32'd35; 

        @(posedge clk) 
        #2;
        we = 1'b0; raddr1 = 5'd5; raddr2 = 5'd10;
        #10
        if (rdata1 != 32'd42)
            $display("FAIL double R: expected 42, got %0d", rdata1);
        else if(rdata2 != 32'd35)
            $display("FAIL double R: expected 35, got %0d", rdata2);
        else
            $display("PASS double R");

        
        $finish;
    end

endmodule