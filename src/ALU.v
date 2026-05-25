module alu (
    input [31:0] a,
    input [31:0] b,
    input [3:0] sel,
    output reg [31:0] s,
    output zero
    );

    assign zero = (s == 32'd0);

    always @(*) begin
        case(sel)
            4'd0: s = a + b; //add
            4'd1: s = a - b; //sub
            4'd2: s = a ^ b; //xor
            4'd3: s = a | b; //or
            4'd4: s = a & b; //and
            4'd5: s = a << b[4:0]; //sll
            4'd6: s = a >> b[4:0]; //srl
            4'd7: s = $signed(a) >>> b[4:0]; //sra
            4'd8: s = ($signed(a) < $signed(b)) ? 1 : 0; //slt
            4'd9: s = ($unsigned(a) < $unsigned(b)) ? 1 : 0; //sltu
            default: s = 32'd0;
        endcase
    end
endmodule