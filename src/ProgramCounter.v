module program_counter (
    input clk,
    input reset,
    input [31:0] wdata,
    output [31:0] rdata
);
    reg [31:0] program_counter;

    assign rdata = program_counter;

    always @(posedge clk) begin
        if(reset)
            program_counter = 32'd0;
        else
            program_counter <= wdata;
    end

endmodule