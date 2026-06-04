`timescale 1ns/1ps

module tb_InstructionMemory;

    reg [31:0] program_counter;
    
    wire [31:0] instruction;

    instruction_memory test_instruction_memory (
        .raddr(program_counter),
        .instr(instruction)
    );

    initial begin
        $dumpfile("sim/instruction_memory.vcd");
        $dumpvars(0, tb_InstructionMemory);

        program_counter = 32'd0;

        #10;

        if(instruction != 32'h00000000)
            $display("FAIL PC0: expected 00000000, got %h", instruction);
        else
            $display("PASS PC0");

        program_counter = 32'd1;

        #10;

        if(instruction != 32'h12345678)
            $display("FAIL PC1: expected 12345678, got %h", instruction);
        else
            $display("PASS PC1");

        program_counter = 32'd2;

        #10;

        if(instruction != 32'h42424242)
            $display("FAIL PC2: expected 42424242, got %h", instruction);
        else
            $display("PASS PC2");

        program_counter = 32'd3;

        #10;

        if(instruction != 32'h01010101)
            $display("FAIL PC3: expected 01010101, got %h", instruction);
        else
            $display("PASS PC3");

        program_counter = 32'hFFFFFF04;

        #10;

        if(instruction != 32'h55555555)
            $display("FAIL PC4: expected 55555555, got %h", instruction);
        else
            $display("PASS PC4");

        $finish;
    end


endmodule