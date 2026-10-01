`timescale 1ns / 1ps

module cmult_a_real_tb;

    parameter int A_WIDTH = 8;
    parameter int B_WIDTH = 8;

    import "DPI-C" function void cmult_a_real(
        input int A_WIDTH,
        input int B_WIDTH,
        input int A_SIGNED,
        input int a,
        input int x1,
        input int y1,
        output int out_re,
        output int out_im
    );

    logic clk;
    logic signed [A_WIDTH-1:0] a_s;
    logic [A_WIDTH-1:0] a_u;
    logic signed [B_WIDTH-1:0] x1, y1;
    logic signed [A_WIDTH+B_WIDTH-1:0] out_re_s, out_im_s;
    logic signed [A_WIDTH+B_WIDTH-1:0] out_re_u, out_im_u;

    int errors = 0;
    logic signed [A_WIDTH+B_WIDTH-1:0] exp_re_s, exp_im_s;
    logic signed [A_WIDTH+B_WIDTH-1:0] exp_re_u, exp_im_u;
    int test_number = 0;

    cmult_a_real #(
        .A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH),
        .A_SIGNED(1), .USE_DSP_VALUE(1)
    ) dut_signed (
        .clk(clk), .a(a_s), .x1(x1), .y1(y1),
        .out_re(out_re_s), .out_im(out_im_s)
    );

    cmult_a_real #(
        .A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH),
        .A_SIGNED(0), .USE_DSP_VALUE(1)
    ) dut_unsigned (
        .clk(clk), .a(a_u), .x1(x1), .y1(y1),
        .out_re(out_re_u), .out_im(out_im_u)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task automatic test(
        input int test_num,
        input int a_signed,
        input int a_unsigned,
        input int in_re,
        input int in_im
    );
        int exp_re = 0;
        int exp_im = 0;
        @(posedge clk);
        a_s = a_signed;
        a_u = a_unsigned;
        x1 = in_re;
        y1 = in_im;
        test_number = test_num;

        cmult_a_real(
            A_WIDTH,
            B_WIDTH,
            1,
            a_signed,
            in_re,
            in_im,
            exp_re,
            exp_im
        );
        exp_re_s = exp_re;
        exp_im_s = exp_im;

        cmult_a_real(
            A_WIDTH,
            B_WIDTH,
            0,
            a_unsigned,
            in_re,
            in_im,
            exp_re,
            exp_im
        );
        exp_re_u = exp_re;
        exp_im_u = exp_im;

        @(posedge clk);
        #1;

        if (out_re_s !== exp_re_s || out_im_s !== exp_im_s) begin
            $error("S%0d FAIL: got (%0d,%0d), expected (%0d,%0d)", test_num, out_re_s, out_im_s, exp_re_s, exp_im_s);
            errors++;
        end else $display("S%0d PASS", test_num);

        if (out_re_u !== exp_re_u || out_im_u !== exp_im_u) begin
            $error("U%0d FAIL: got (%0d,%0d), expected (%0d,%0d)", test_num, out_re_u, out_im_u, exp_re_u, exp_im_u);
            errors++;
        end else $display("U%0d PASS", test_num);

    endtask

    initial begin
        @(posedge clk);
        test(0, -128, 0, -128, -128);
        test(1, -128, 0, -128, 127);
        test(2, -128, 0, 127, -128);
        test(3, -128, 0, 127, 127);
        test(4, 127, 0, -128, -128);
        test(5, 127, 0, -128, 127);
        test(6, 127, 0, 127, -128);
        test(7, 127, 0, 127, 127);
        test(8, 0, 0, -128, -128);
        test(9, 0, 0, -128, 127);
        test(10, 0, 0, 127, -128);
        test(11, 0, 0, 127, 127);
        test(12, 0, 255, -128, -128);
        test(13, 0, 255, -128, 127);
        test(14, 0, 255, 127, -128);
        test(15, 0, 255, 127, 127);

        @(posedge clk);

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);
    end

endmodule
