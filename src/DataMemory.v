module data_memory (
    input clk,
    input we, //write enable
    input sz, //SEXT vs ~ZEXT
    input [1:0] num_bytes, // 00 = 1 byte, 01 = 2 bytes, 3 bytes not used, 11 = 4 bytes(word)
    input [31:0] addr,
    input [31:0] wdata,
    output reg [31:0] rdata
);
    // Smaller size for simulation
    reg [7:0] data_memory [0:2048];
    reg sign_bit;

    always @(*) begin
        for(integer i = 0; i < 4; i++) begin
            if(i < ($unsigned(num_bytes + 1))) begin
                rdata[i*8 +: 8] = data_memory[addr[9:0] + i];
                sign_bit = data_memory[addr[9:0] + i][7];
            end
            else if (sz)
                rdata[i*8 +: 8] = {8{sign_bit}};
            else
                rdata[i*8 +: 8] = 8'h00;
        end
    end

    always @(posedge clk) begin
        if(we) begin
            for(integer i = 0; i < ($unsigned(num_bytes+1)); i++) begin
                data_memory[addr[9:0] + i] = wdata[i*8 +: 8];
            end
        end
    end

endmodule