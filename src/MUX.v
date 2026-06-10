module mux #(
    parameter DATA_WIDTH = 32,
    parameter INPUT_WIDTH = 2,
    parameter SELECT_BITS = 1
) (
    input [(INPUT_WIDTH*DATA_WIDTH)-1:0] data_in,
    input [SELECT_BITS-1:0] sel,
    output [DATA_WIDTH-1:0] out
);

    assign out = data_in[sel*(DATA_WIDTH) +: DATA_WIDTH];

endmodule