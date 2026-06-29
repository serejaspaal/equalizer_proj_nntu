`timescale 1ns / 1ps

module mult_tb ();
    parameter A_WIDTH = 4;
    parameter B_WIDTH = 4;
    logic clk;
    logic [A_WIDTH-1:0] a_s, a_u;
    logic [B_WIDTH-1:0] b_s, b_u;
    logic signed [A_WIDTH+B_WIDTH-1:0] result_s, expected_s;
    logic [A_WIDTH+B_WIDTH-1:0] result_u, expected_u;

    integer ai, bi, errors;

    mult #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH), .SIGNED_OPERANDS("yes")) dut_s (.clk, .a(a_s), .b(b_s), .result(result_s));
    
    mult #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH), .SIGNED_OPERANDS("no")) dut_u (.clk, .a(a_u), .b(b_u), .result(result_u));


    initial clk = 0;
    always #2 clk = ~clk;

    initial begin
        errors = 0;
        for (ai = 0; ai < 2**A_WIDTH; ai++) begin
            for (bi = 0; bi < 2**B_WIDTH; bi++) begin
                @(posedge clk);
                a_s <= ai;
                b_s <= bi;
                a_u <= ai;
                b_u <= bi;
                expected_s <= $signed(a_s) * $signed(b_s);
                expected_u <= a_u * b_u;
                if (result_s !== expected_s) begin
                    $display("FAIL_SIGNED: a=%d (%b) b=%d (%b) -> result=%d (%b) expected=%d (%b)", $signed(a_s), a_s,
                              $signed(b_s), b_s, $signed(result_s), result_s, $signed(expected_s), expected_s);
                    errors++;
                end
                if (result_u !== expected_u) begin
                    $display("FAIL_UNSIGNED: a=%d (%b) b=%d (%b) -> result=%d (%b) expected=%d (%b)", $unsigned(a_u), a_u,
                              $unsigned(b_u), b_u, $unsigned(result_u), result_u, $unsigned(expected_u), expected_u);
                    errors++;
                    #1;
                end
            end
        end
        @(posedge clk);
        expected_s <= $signed(a_s) * $signed(b_s);
        expected_u <= a_u * b_u;
        if (result_s !== expected_s) begin
            $display("FAIL_SIGNED: a=%d (%b) b=%d (%b) -> result=%d (%b) expected=%d (%b)", $signed(a_s), a_s,
                      $signed(b_s), b_s, $signed(result_s), result_s, $signed(expected_s), expected_s);
            errors++;
        end
        if (result_u !== expected_u) begin
            $display("FAIL_UNSIGNED: a=%d (%b) b=%d (%b) -> result=%d (%b) expected=%d (%b)", $unsigned(a_u), a_u,
                      $unsigned(b_u), b_u, $unsigned(result_u), result_u, $unsigned(expected_u), expected_u);
            errors++;
        end
        @(posedge clk);
        if (result_s !== expected_s) begin
            $display("FAIL_SIGNED: a=%d (%b) b=%d (%b) -> result=%d (%b) expected=%d (%b)", $signed(a_s), a_s,
                      $signed(b_s), b_s, $signed(result_s), result_s, $signed(expected_s), expected_s);
            errors++;
        end
        if (result_u !== expected_u) begin
            $display("FAIL_UNSIGNED: a=%d (%b) b=%d (%b) -> result=%d (%b) expected=%d (%b)", $unsigned(a_u), a_u,
                      $unsigned(b_u), b_u, $unsigned(result_u), result_u, $unsigned(expected_u), expected_u);
            errors++;
        end
        if (errors == 0) begin
            $display("TEST PASSED");
        end
        else
            $display("TEST FAILED: %d errors", errors);
        #7;
    end
endmodule

