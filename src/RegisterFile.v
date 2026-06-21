module register_file(
    input clk, 
    input we,
    input [4:0] raddr1, //address to read from
    input [4:0] raddr2, //32 registers so 5 bits
    input [4:0] waddr, //address to write to
    input [31:0] wdata, //data to write
    output reg [31:0] rdata1, //data read
    output reg [31:0] rdata2
);

    //32 registers
    //not really gonna use the first one, but complicates to remove it
    reg [31:0] register [31:0];

    initial register[0] = 32'd0;

    //read
    //async for single cycle reasons
    //turnary operator is used since we don't know the initial state of register[0]
    always @(*) begin
        if(raddr1 == waddr && we && waddr != 5'd0) begin
            rdata1 = wdata;
        end
        else
            rdata1 = (raddr1 == 5'd0) ? 32'd0 : register[raddr1];
        if(raddr2 == waddr && we && waddr != 5'd0)
            rdata2 = wdata;
        else
            rdata2 = (raddr2 == 5'd0) ? 32'd0 : register[raddr2];
    end

    //write
    always @(posedge clk) begin
        if(we && (waddr != 5'd0))
            register[waddr] <= wdata;
    end

endmodule