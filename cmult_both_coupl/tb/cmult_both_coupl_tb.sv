`timescale 1ns / 1ps

module cmult_both_coupl_tb;

    parameter int A_WIDTH = 4;
    parameter int B_WIDTH = 6;

    logic clk;
    logic signed [A_WIDTH-1:0] x0, y0;
    logic signed [B_WIDTH-1:0] x1, y1;
    logic signed [A_WIDTH+B_WIDTH:0] out_re, out_im;

    cmult_both_coupl #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .USE_DSP_VALUE("yes")
    ) dut (.*);

    initial clk = 0;
    always #5 clk = ~clk;

    int errors;

    initial begin
        errors = 0;
        
        @(posedge clk);
        x0 = 2; y0 = 3; x1 = 4; y1 = 5;       
	@(posedge clk);
        x0 = 7; y0 = 7; x1 = 31; y1 = 31;     
	@(posedge clk);
        x0 = -8; y0 = -8; x1 = -32; y1 = -32; 

	repeat(2) @(posedge clk);
        if (out_re !== -7 || out_im !== -22) begin
            $error("Test1 FAIL: got (%0d,%0d), expected (-7,-22)", out_re, out_im);
            errors++;
        end else $display("Test1 PASS: (2+3i)*(4+5i) = (%0d,%0d)", out_re, out_im);

        x0 = 7; y0 = -8; x1 = 31; y1 = -32;   

	@(posedge clk);
        if (out_re !== 0 || out_im !== -434) begin
            $error("Test2 FAIL: got (%0d,%0d), expected (0,-434)", out_re, out_im);
            errors++;
        end else $display("Test2 PASS: (7+7i)*(31+31i) = (%0d,%0d)", out_re, out_im);

	@(posedge clk);
        if (out_re !== 0 || out_im !== -512) begin
            $error("Test3 FAIL: got (%0d,%0d), expected (0,-512)", out_re, out_im);
            errors++;
        end else $display("Test3 PASS: (-8-8i)*(-32-32i) = (%0d,%0d)", out_re, out_im);

        repeat(2) @(posedge clk);
        if (out_re !== -39 || out_im !== 472) begin
            $error("Test4 FAIL: got (%0d,%0d), expected (-39,472)", out_re, out_im);
            errors++;
        end else $display("Test4 PASS: (7-8i)*(31-32i) = (%0d,%0d)", out_re, out_im);

        #20;
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);
        $finish;
    end

endmodule
