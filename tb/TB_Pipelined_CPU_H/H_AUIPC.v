`timescale 1ns/1ps

module H_AUIPC;

    reg clk;
    reg reset;

    reg [31:0] expected [0:31];
    integer i;
    integer errors;

    initial begin
        expected[0] = 32'h00000000;
        expected[1] = 32'h00001018;
    end

    p_cpu test_cpu (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;

        $dumpfile("sim/h_auipc.vcd");
        $dumpvars(1, H_AUIPC, H_AUIPC.test_cpu);

        reset = 1'b1;

        @(posedge clk); #1;

        reset = 1'b0;

        repeat(100) @(posedge clk);

        errors = 0;

        for (i = 0; i < 2; i = i + 1) begin
            if (test_cpu.register_file.register[i] !== expected[i]) begin
                errors = errors + 1;
                $display("FAIL AT R%0d: expected %08h, got %08h",
                        i,
                        expected[i],
                        test_cpu.register_file.register[i]);
            end
        end

        if (errors == 0)
            $display("PASS: Pipelined AUIPC test");
        else
            $display("FAIL: %0d register mismatches", errors);

        $finish;

    end

endmodule