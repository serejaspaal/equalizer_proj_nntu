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
        .USE_DSP_VALUE(1)
    ) dut (.*);

    initial clk = 0;
    always #5 clk = ~clk;

    int errors;
    logic signed [A_WIDTH-1:0] x0_d, y0_d;
    logic signed [B_WIDTH-1:0] x1_d, y1_d;
    logic signed [A_WIDTH+B_WIDTH:0] exp_common, exp_multr, exp_multi;
    logic signed [A_WIDTH+B_WIDTH:0] exp_re, exp_im;
    logic signed [A_WIDTH+B_WIDTH:0] exp_out_re_d;
    logic signed [A_WIDTH+B_WIDTH:0] exp_sum_mi;
    
    always_ff @(posedge clk) begin
        x0_d <= x0;
        y0_d <= y0;
        x1_d <= x1;
        y1_d <= y1;
    end
    
    always_ff @(posedge clk) begin
        exp_common <= (x0_d - y0_d) * y1_d;
        exp_multr  <= (x1_d - y1_d) * x0_d;
        exp_multi  <= (x1_d + y1_d) * y0_d;
    end
    
    always_ff @(posedge clk) begin
        exp_sum_mi <= exp_multi + exp_common;
        exp_out_re_d <= exp_multr + exp_common;
    end    
    always_ff @(posedge clk) begin
        exp_re <= exp_out_re_d;
        exp_im <= ~exp_sum_mi + 1'b1;
    end
    initial begin
        errors = 0;
        @(posedge clk);
        x0 = -128; y0 = -128; x1 = -128; y1 = -128; @(posedge clk);
        x0 = -128; y0 = -128; x1 = -128; y1 = 127;  @(posedge clk);
        x0 = -128; y0 = -128; x1 = 127;  y1 = -128; @(posedge clk);

        x0 = -128; y0 = -128; x1 = 127; y1 = 127; @(posedge clk);
        x0 = -128; y0 = 127; x1 = -128; y1 = -128; @(posedge clk);
        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T1 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T1 PASS: conj(-128-128i)*conj(-128-128i) = (%0d,%0d)", out_re, out_im);

        x0 = -128; y0 = 127; x1 = -128; y1 = 127; @(posedge clk);

        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T2 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T2 PASS: conj(-128-128i)*conj(-128+127i) = (%0d,%0d)", out_re, out_im);
        x0 = -128; y0 = 127; x1 = 127; y1 = -128; @(posedge clk);

        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T3 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T3 PASS: conj(-128-128i)*conj(127-128i) = (%0d,%0d)", out_re, out_im);
        x0 = -128; y0 = 127; x1 = 127; y1 = 127; @(posedge clk);

        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T4 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T4 PASS: conj(-128-128i)*conj(127+127i) = (%0d,%0d)", out_re, out_im);
        x0 = 127; y0 = -128; x1 = -128; y1 = -128; @(posedge clk);

        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T5 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T5 PASS: conj(-128+127i)*conj(-128-128i) = (%0d,%0d)", out_re, out_im);
        x0 = 127; y0 = -128; x1 = -128; y1 = 127; @(posedge clk);

        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T6 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T6 PASS: conj(-128+127i)*conj(-128+127i) = (%0d,%0d)", out_re, out_im);
        x0 = 127; y0 = -128; x1 = 127; y1 = -128; @(posedge clk);

        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T7 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T7 PASS: conj(-128+127i)*conj(127-128i) = (%0d,%0d)", out_re, out_im);
        x0 = 127; y0 = -128; x1 = 127; y1 = 127; @(posedge clk);

        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T8 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T8 PASS: conj(-128+127i)*conj(127+127i) = (%0d,%0d)", out_re, out_im);
        x0 = 127; y0 = 127; x1 = -128; y1 = -128; @(posedge clk);

        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T9 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T9 PASS: conj(127-128i)*conj(-128-128i) = (%0d,%0d)", out_re, out_im);
        x0 = 127; y0 = 127; x1 = -128; y1 = 127; @(posedge clk);

        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T10 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T10 PASS: conj(127-128i)*conj(-128+127i) = (%0d,%0d)", out_re, out_im);
        x0 = 127; y0 = 127; x1 = 127; y1 = -128; @(posedge clk);

        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T11 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T11 PASS: conj(127-128i)*conj(127-128i) = (%0d,%0d)", out_re, out_im);
        x0 = 127; y0 = 127; x1 = 127; y1 = 127; @(posedge clk);

        if (out_re !== exp_re || out_im !== exp_im) begin
            $error("T12 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re, out_im, exp_re, exp_im);
            errors++;
        end else $display("T12 PASS: conj(127-128i)*conj(127+127i) = (%0d,%0d)", out_re, out_im);
        @(posedge clk);

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
