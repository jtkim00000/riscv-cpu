`timescale 1ns/1ps

module tb_ImmediateGenerator;

    reg [31:0] data_in;

    reg [6:0] opcode;

    reg [11:0] immi, imms;
    reg [12:0] immb;
    reg [19:0] immu;
    reg [20:0] immj;

    wire [31:0] data_out;

    immediate_generator test_immediate_generator_t (
        .data_in(data_in),
        .data_out(data_out)
    );


    initial begin
        $dumpfile("sim/tb_immediate_generator.vcd");
        $dumpvars(0, tb_ImmediateGenerator);

        // I-type
        opcode = 7'b0010011;
        immi = 12'd15;
        data_in = {immi, {13{1'b0}}, opcode};

        #10;
        if(data_out != 32'd15)
            $display("FAIL ITYPE POS 1: expected 15, got %0d", data_out);
        else
            $display("PASS ITYPE POS 1");

        immi = -12'd10;
        data_in = {immi, {13{1'b0}}, opcode};

        #10;
        if(data_out != -32'd10)
            $display("FAIL ITYPE NEG 1: expected -10, got %0d", data_out);
        else
            $display("PASS ITYPE NEG 1");

        opcode = 7'b0000011;
        immi = 12'd14;
        data_in = {immi, {13{1'b0}}, opcode};

        #10;
        if(data_out != 32'd14)
            $display("FAIL ITYPE POS 2: expected 14, got %0d", data_out);
        else
            $display("PASS ITYPE POS 2");
            
        immi = -12'd9;
        data_in = {immi, {13{1'b0}}, opcode};

        #10;
        if(data_out != -32'd9)
            $display("FAIL ITYPE NEG 2: expected -9, got %0d", data_out);
        else
            $display("PASS ITYPE NEG 2");

        opcode = 7'b1100111;
        immi = 12'd13;
        data_in = {immi, {13{1'b0}}, opcode};

        #10;
        if(data_out != 32'd13)
            $display("FAIL ITYPE POS 3: expected 13, got %0d", data_out);
        else
            $display("PASS ITYPE POS 3");
            
        immi = -12'd8;
        data_in = {immi, {13{1'b0}}, opcode};

        #10;
        if(data_out != -32'd8)
            $display("FAIL ITYPE NEG 3: expected -8, got %0d", data_out);
        else
            $display("PASS ITYPE NEG 3");
        
        // S-type
        opcode = 7'b0100011;
        imms = 12'd21;
        data_in = {imms[11:5], {13{1'b0}}, imms[4:0], opcode};

        #10;
        if(data_out != 32'd21)
            $display("FAIL STYPE POS: expected 21, got %0d", data_out);
        else
            $display("PASS STYPE POS");

        imms = -12'd3;
        data_in = {imms[11:5], {13{1'b0}}, imms[4:0], opcode};

        #10;
        if(data_out != -32'd3)
            $display("FAIL STYPE NEG: expected -3, got %0d", data_out);
        else
            $display("PASS STYPE NEG");

        // B-type
        opcode = 7'b1100011;
        immb = 13'd100;
        data_in = {immb[12], immb[10:5], {13{1'b0}}, immb[4:1], immb[11], opcode};

        #10;
        if(data_out != 32'd100)
            $display("FAIL BTYPE POS: expected 100, got %0d", data_out);
        else
            $display("PASS BTYPE POS");

        immb = -13'd15;
        data_in = {immb[12], immb[10:5], {13{1'b0}}, immb[4:1], immb[11], opcode};

        #10;
        if(data_out != -32'd16)
            $display("FAIL BTYPE NEG: expected -16, got %0d", data_out);
        else
            $display("PASS BTYPE NEG");

        // U-type
        opcode = 7'b0110111;
        immu = 20'd53;
        data_in = {immu, {5{1'b0}}, opcode};

        #10;
        if(data_out != {20'd53, 12'd0})
            $display("FAIL UTYPE POS1: expected %0d, got %0d", {20'd53, 12'd0}, data_out);
        else
            $display("PASS UTYPE POS1");

        immu = -20'd43;
        data_in = {immu, {5{1'b0}}, opcode};

        #10;
        if(data_out != {-20'd43, 12'd0})
            $display("FAIL UTYPE NEG1: expected %0d, got %0d", {-20'd43, 12'd0}, data_out);
        else
            $display("PASS UTYPE NEG1");

        opcode = 7'b0010111;
        immu = 20'd52;
        data_in = {immu, {5{1'b0}}, opcode};

        #10;
        if(data_out != {20'd52, 12'd0})
            $display("FAIL UTYPE POS2: expected %0d, got %0d", {20'd52, 12'd0}, data_out);
        else
            $display("PASS UTYPE POS2");

        immu = -20'd42;
        data_in = {immu, {5{1'b0}}, opcode};

        #10;
        if(data_out != {-20'd42, 12'd0})
            $display("FAIL UTYPE NEG2: expected %0d, got %0d", {-20'd42, 12'd0}, data_out);
        else
            $display("PASS UTYPE NEG2");

        // J-type
        opcode = 7'b1101111;
        immj = 21'd33;
        data_in = {immj[20], immj[10:1], immj[11], immj[19:12], {5{1'b0}}, opcode};

        #10;
        if(data_out != 32'd32)
            $display("FAIL JTYPE POS: expected 32, got %0d", data_out);
        else
            $display("PASS JTYPE POS");

        immj = -21'd34;
        data_in = {immj[20], immj[10:1], immj[11], immj[19:12], {5{1'b0}}, opcode};

        #10;
        if(data_out != -32'd34)
            $display("FAIL JTYPE NEG: expected -34, got %0d", data_out);
        else
            $display("PASS JTYPE NEG");

        // Default
        opcode = 7'b0000000;
        data_in = {25'b1111111111111111111111111, opcode};

        #10;
        if(data_out != 32'd0)
            $display("FAIL DEFAULT: expected 0, got %0d", data_out);
        else
            $display("PASS DEFAULT");

        $finish;
    end

endmodule