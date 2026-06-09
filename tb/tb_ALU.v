`timescale 1ns/1ps


module tb_ALU;

    //input reg
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] sel;
    //output wire
    wire [31:0] s;
    wire zero;

    alu test_alu (
       .a(a),
       .b(b),
       .sel(sel),
       .s(s),
       .zero(zero) 
    );

    initial begin
        $dumpfile("sim/alu.vcd");
        $dumpvars(0, tb_ALU);

        //add
        a = 32'd1; b = 32'd3; sel = 4'd0;
        #10;  //wait
        if (s !== 32'd4)
            $display("FAIL ADD: expected 4, got %0d", s);
        else
            $display("PASS ADD");

        //overflow edgecase
        a = 32'hFFFFFFFF; b = 32'd1; sel = 4'd0;
        #10;
        if (s !== 32'd0)
            $display("FAIL ADD overflow: expected 0, got %0d", s);
        else
            $display("PASS ADD overflow");

        //adding zeros
        a = 32'd0; b = 32'd0; sel = 4'd0;
        #10;
        if (s !== 32'd0)
            $display("FAIL ADD zero: expected 0, got %0d", s);
        else
            $display("PASS ADD zero");

        //sub
        a = 32'd11; b = 32'd6; sel = 4'd1;
        #10;
        if (s !== 32'd5)
            $display("FAIL SUB: expected 5, got %0d", s);
        else
            $display("PASS SUB");

        //sub overflow
        a = 32'd3; b = 32'd6; sel = 4'd1;
        #10;
        if (s !== 32'hFFFFFFFD)
            $display("FAIL SUB overflow: expected -3, got %0d", s);
        else
            $display("PASS SUB overflow");

        //subtract to 0
        a = 32'd6; b = 32'd6; sel = 4'd1;
        #10;
        if (s !== 32'd0)
            $display("FAIL SUB zero: expected 0, got %0d", s);
        else
            $display("PASS SUB zero");

        //xor
        a = 32'h00000FFF; b = 32'h000000BD; sel = 4'd2;
        #10;
        if (s !== 32'h00000F42)
            $display("FAIL XOR: expected 00000F42, got %0d", s);
        else
            $display("PASS XOR");

        //or
        a = 32'h0000FEFE; b = 32'hF000AABB; sel = 4'd3;
        #10;
        if (s !== 32'hF000FEFF)
            $display("FAIL OR: expected F000FEFF, got %0d", s);
        else
            $display("PASS OR");

        //and
        a = 32'h0000FEFE; b = 32'hF000AABB; sel = 4'd4;
        #10;
        if (s !== 32'h0000AABA)
            $display("FAIL AND: expected 0000AABA, got %0d", s);
        else
            $display("PASS AND");

        //sll
        a = 32'd1; b = 32'd3; sel = 4'd5;
        #10;
        if (s !== 32'd8)
            $display("FAIL SLL: expected 8, got %0d", s);
        else
            $display("PASS SLL");

        //sll overflow
        a = 32'd2; b = 32'd31; sel = 4'd5;
        #10;
        if (s !== 32'd0)
            $display("FAIL SLL: expected 0, got %0d", s);
        else
            $display("PASS SLL");
        
        //srl
        a = 32'd4; b = 32'd2; sel = 4'd6;
        #10;
        if (s !== 32'd1)
            $display("FAIL SRL: expected 1, got %0d", s);
        else
            $display("PASS SRL");

        //srl neg & overflow
        a = 32'hF0000000; b = 32'd31; sel = 4'd6;
        #10;
        if (s !== 32'd1)
            $display("FAIL SRL edge: expected 1, got %0d", s);
        else
            $display("PASS SRL edge");

        //sra
        a = 32'hF0000000; b = 32'd31; sel = 4'd7;
        #10;
        if (s !== 32'hFFFFFFFF)
            $display("FAIL SRA neg: expected -1, got %0d", s);
        else
            $display("PASS SRA neg");

        a = 32'h70000000; b = 32'd31; sel = 4'd7;
        #10;
        if (s !== 32'd0)
            $display("FAIL SRA pos: expected 0, got %0d", s);
        else
            $display("PASS SRA pos");

        //slt
        a = 32'd8; b = 32'd10; sel = 4'd8;
        #10;
        if (s !== 32'd1)
            $display("FAIL SLT: expected 1, got %0d", s);
        else
            $display("PASS SLT");

        a = 32'd8; b = 32'd8; sel = 4'd8;
        #10;
        if (s !== 32'd0)
            $display("FAIL SLT equal: expected 0, got %0d", s);
        else
            $display("PASS SLT equal");

        a = 32'd8; b = 32'hF0000000; sel = 4'd8;
        #10;
        if (s !== 32'd0)
            $display("FAIL SLT neg: expected 0, got %0d", s);
        else
            $display("PASS SLT neg");

        //sltu
        a = 32'd8; b = 32'd10; sel = 4'd9;
        #10;
        if (s !== 32'd1)
            $display("FAIL SLTU: expected 1, got %0d", s);
        else
            $display("PASS SLTU");

        a = 32'd8; b = 32'd8; sel = 4'd9;
        #10;
        if (s !== 32'd0)
            $display("FAIL SLTU equal: expected 0, got %0d", s);
        else
            $display("PASS SLTU equal");

        a = 32'd8; b = 32'hF0000000; sel = 4'd9;
        #10;
        if (s !== 32'd1)
            $display("FAIL SLTU neg: expected 1, got %0d", s);
        else
            $display("PASS SLTU neg");

        //eq
        a = 32'd12; b = 32'd12; sel = 4'd10;
        #10;
        if (s !== 32'd1)
            $display("FAIL EQ1: expected 1, got %0d", s);
        else
            $display("PASS EQ1");

        a = 32'd8; b = 32'hF0000000; sel = 4'd10;
        #10;
        if (s !== 32'd0)
            $display("FAIL EQ0: expected 0, got %0d", s);
        else
            $display("PASS EQ0");

        //neq
        a = 32'd8; b = 32'd99; sel = 4'd11;
        #10;
        if (s !== 32'd1)
            $display("FAIL NEQ1: expected 1, got %0d", s);
        else
            $display("PASS NEQ1");

        a = 32'd42; b = 32'd42; sel = 4'd11;
        #10;
        if (s !== 32'd0)
            $display("FAIL NEQ0: expected 0, got %0d", s);
        else
            $display("PASS NEQ0");

        //bge
        a = 32'd8; b = 32'd10; sel = 4'd12;
        #10;
        if (s !== 32'd0)
            $display("FAIL BGE: expected 0, got %0d", s);
        else
            $display("PASS BGE");

        a = 32'd8; b = 32'd8; sel = 4'd12;
        #10;
        if (s !== 32'd1)
            $display("FAIL BGE equal: expected 1, got %0d", s);
        else
            $display("PASS BGE equal");

        a = 32'd8; b = 32'hF0000000; sel = 4'd12;
        #10;
        if (s !== 32'd1)
            $display("FAIL BGE neg: expected 1, got %0d", s);
        else
            $display("PASS BGE neg");

        //bge
        a = 32'd8; b = 32'd10; sel = 4'd13;
        #10;
        if (s !== 32'd0)
            $display("FAIL BGEU: expected 0, got %0d", s);
        else
            $display("PASS BGEU");

        a = 32'd8; b = 32'd8; sel = 4'd13;
        #10;
        if (s !== 32'd1)
            $display("FAIL BGEU equal: expected 1, got %0d", s);
        else
            $display("PASS BGEU equal");

        a = 32'd8; b = 32'hF0000000; sel = 4'd13;
        #10;
        if (s !== 32'd0)
            $display("FAIL BGEU neg: expected 0, got %0d", s);
        else
            $display("PASS BGEU neg");
            
        //Jumps
        sel = 4'd14;
        #10;
        if (s !== 32'd1)
            $display("FAIL JUMP: expected 1, got %0d", s);
        else
            $display("PASS JUMP neg");
        
        $finish;

    end

endmodule;