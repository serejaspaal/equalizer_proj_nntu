`timescale 1ns / 1ps

module mult_tb ();
    parameter A_WIDTH = 4;
    parameter B_WIDTH = 4;
    logic clk;
    logic [A_WIDTH-1:0] a;
    logic [B_WIDTH-1:0] b;
    logic [A_WIDTH+B_WIDTH-1:0] result, expected;
    integer ai, bi, errors;

    mult #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) dut (.*);

    initial clk = 0;
    always #2 clk = ~clk;

    initial begin
        errors = 0;
        for (ai = 0; ai < 2**A_WIDTH; ai++) begin
            for (bi = 0; bi < 2**B_WIDTH; bi++) begin
                @(posedge clk);
                a <= ai;
                b <= bi;
                expected <= $signed(a) * $signed(b);
                if (result !== expected) begin
                    $display("FAIL: a=%d (%b) b=%d (%b) -> result=%d (%b) expected=%d (%b)", $signed(a), a,
                              $signed(b), b, $signed(result), result, $signed(expected), expected);
                    errors++;
                #1;
                end
            end
        end
        @(posedge clk);
        expected <= $signed(a) * $signed(b);
        if (result !== expected) begin
            $display("FAIL: a=%d (%b) b=%d (%b) -> result=%d (%b) expected=%d (%b)", $signed(a), a,
            $signed(b), b, $signed(result), result, $signed(expected), expected);
            errors++;
            #1;
        end
        if (errors == 0)
            $display("TEST PASSED");
        else
            $display("TEST FAILED: %d errors", errors);
        #7;
    end
endmodule

