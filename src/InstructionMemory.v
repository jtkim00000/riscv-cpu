module instruction_memory (
    input [31:0] raddr,
    output [31:0] instr
);

    // Smaller size for simulation
    reg [31:0] instruction_memory [0:255];

    // Load program
    initial $readmemh("prog/instr_mem_test.hex", instruction_memory, 8'd0);   

    assign instr = instruction_memory[raddr[7:0]];

endmodule