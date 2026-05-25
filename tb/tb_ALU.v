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
        
    end

endmodule;