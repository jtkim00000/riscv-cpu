module data_memory (
    input clk,
    input we, //write enable
    input re, //read enable
    input num_bytes,
    input [31:0] addr,
    input [31:0] wdata,
    output reg [31:0] rdata
);
    // Smaller size for simulation
    reg [7:0] data_memory [0:255];

    always @(*) begin
        if(re) begin
            for(integer i = 0; i < num_bytes; i++) begin
                rdata[i*8 +: 8] = data_memory[addr[7:0] + i];
            end
        end
    end

    always @(posedge clk) begin
        if(we) begin
            for(integer i = 0; i < num_bytes; i++) begin
                data_memory[addr[7:0] + i] = wdata[i*8 +: 8];
            end
        end
    end

endmodule