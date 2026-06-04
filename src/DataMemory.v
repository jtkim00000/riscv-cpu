module data_memory (
    input clk,
    input we, //write enable
    input re, //read enable
    input [31:0] addr,
    input [31:0] wdata,
    output reg [31:0] rdata
);
    // Smaller size for simulation
    reg [31:0] data_memory [0:255];

    always @(*) begin
        if(re)
            rdata = data_memory[addr[7:0]];
    end

    always @(posedge clk) begin
        if(we)
            data_memory[addr[7:0]] <= wdata;
    end

endmodule