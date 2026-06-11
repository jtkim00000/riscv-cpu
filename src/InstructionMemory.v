module instruction_memory (
    input  [31:0] raddr,
    output [31:0] instr
);

    // Smaller size for simulation
    reg [7:0] instruction_memory [0:255];

    // Load program
    initial begin
        $readmemh("prog/cpu_test_lui.hex", instruction_memory, 8'd0);
    end

    //using 32-bit word size, but using the higher bits of pc
    assign instr = {instruction_memory[raddr[7:0]], instruction_memory[raddr[7:0]+1], instruction_memory[raddr[7:0]+2], instruction_memory[raddr[7:0]+3]};

endmodule