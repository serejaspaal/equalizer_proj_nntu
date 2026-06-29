`timescale 1ns / 1ps

module cmult_both_coupl_tb;

    parameter int A_WIDTH = 8;
    parameter int B_WIDTH = 8;

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
    logic signed [A_WIDTH:0] exp_sum_a;
    logic signed [B_WIDTH:0] exp_dif_b;
    logic signed [A_WIDTH+B_WIDTH-1:0] exp_p1, exp_p2;
    logic signed [A_WIDTH+B_WIDTH-1:0] exp_p1_reg, exp_p2_reg;
    logic signed [A_WIDTH+B_WIDTH+1:0] exp_p3;
    logic signed [A_WIDTH+B_WIDTH:0] exp_re, exp_im;

    always_ff @(posedge clk) begin
        exp_sum_a <= x0 + y0;
        exp_dif_b <= x1 + y1;
        exp_p1 <= x0 * x1;
        exp_p2 <= y0 * y1;
    end
    always_ff @(posedge clk) begin
        exp_p1_reg <= exp_p1;
        exp_p2_reg <= exp_p2;
        exp_p3 <= exp_sum_a * exp_dif_b;
    end
    always_ff @(posedge clk) begin
        exp_re <= exp_p1_reg - exp_p2_reg;
        exp_im <= exp_p1_reg + exp_p2_reg - exp_p3;
    end
    initial begin
        errors = 0;
        
        x0 = -128; y0 = -128; x1 = -128; y1 = -128; @(posedge clk);
        x0 = -128; y0 = -128; x1 = -128; y1 = 127;  @(posedge clk);
        x0 = -128; y0 = -128; x1 = 127;  y1 = -128; @(posedge clk);

        x0 = -128; y0 = -128; x1 = 127; y1 = 127; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T1 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T1 PASS: conj(-128-128i)*conj(-128-128i) = (%0d,%0d)", out_re, out_im);

        x0 = -128; y0 = 127; x1 = -128; y1 = -128; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T2 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T2 PASS: conj(-128-128i)*conj(-128+127i) = (%0d,%0d)", out_re, out_im);

        x0 = -128; y0 = 127; x1 = -128; y1 = 127; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T3 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T3 PASS: conj(-128-128i)*conj(127-128i) = (%0d,%0d)", out_re, out_im);

        x0 = -128; y0 = 127; x1 = 127; y1 = -128; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T4 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T4 PASS: conj(-128-128i)*conj(127+127i) = (%0d,%0d)", out_re, out_im);

        x0 = -128; y0 = 127; x1 = 127; y1 = 127; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T5 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T5 PASS: conj(-128+127i)*conj(-128-128i) = (%0d,%0d)", out_re, out_im);

        x0 = 127; y0 = -128; x1 = -128; y1 = -128; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T6 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T6 PASS: conj(-128+127i)*conj(-128+127i) = (%0d,%0d)", out_re, out_im);

        x0 = 127; y0 = -128; x1 = -128; y1 = 127; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T7 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T7 PASS: conj(-128+127i)*conj(127-128i) = (%0d,%0d)", out_re, out_im);

        x0 = 127; y0 = -128; x1 = 127; y1 = -128; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T8 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T8 PASS: conj(-128+127i)*conj(127+127i) = (%0d,%0d)", out_re, out_im);

        x0 = 127; y0 = -128; x1 = 127; y1 = 127; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T9 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T9 PASS: conj(127-128i)*conj(-128-128i) = (%0d,%0d)", out_re, out_im);

        x0 = 127; y0 = 127; x1 = -128; y1 = -128; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T10 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T10 PASS: conj(127-128i)*conj(-128+127i) = (%0d,%0d)", out_re, out_im);

        x0 = 127; y0 = 127; x1 = -128; y1 = 127; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T11 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T11 PASS: conj(127-128i)*conj(127-128i) = (%0d,%0d)", out_re, out_im);

        x0 = 127; y0 = 127; x1 = 127; y1 = -128; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T12 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T12 PASS: conj(127-128i)*conj(127+127i) = (%0d,%0d)", out_re, out_im);

        x0 = 127; y0 = 127; x1 = 127; y1 = 127; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T13 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T13 PASS: conj(127+127i)*conj(-128-128i) = (%0d,%0d)", out_re, out_im);

        @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T14 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T14 PASS: conj(127+127i)*conj(-128+127i) = (%0d,%0d)", out_re, out_im);

        @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T15 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T15 PASS: conj(127+127i)*conj(127-128i) = (%0d,%0d)", out_re, out_im);

        @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T16 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T16 PASS: conj(127+127i)*conj(127+127i) = (%0d,%0d)", out_re, out_im);

        #20;
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);
        $finish;
    end

endmodule
