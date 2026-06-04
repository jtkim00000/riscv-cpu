module program_counter (
    input clk,
    input [31:0] wdata,
    output [31:0] rdata
);
    reg [31:0] program_counter;

    assign rdata = program_counter;

    always @(posedge clk) begin
        program_counter <= wdata;
    end

endmodule