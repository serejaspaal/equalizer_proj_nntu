`timescale 1ns / 1ps
module cmult_matrix_on_real_tb;
    parameter int DET_WIDTH = 16;
    parameter int M_WIDTH = 16;
    parameter int W_WIDTH = 29;
    parameter int W_CLIP  = 3;
    parameter int USE_DSP_VALUE = 1;

    typedef struct {
        longint det_inv;
        longint m11_re, m11_im;
        longint m12_re, m12_im;
        longint m21_re, m21_im;
        longint m22_re, m22_im;
    } cmult_in;

    typedef struct {
        longint w11_re, w11_im;
        longint w12_re, w12_im;
        longint w21_re, w21_im;
        longint w22_re, w22_im;
        int sat_w11_re, sat_w11_im;
        int sat_w12_re, sat_w12_im;
        int sat_w21_re, sat_w21_im;
        int sat_w22_re, sat_w22_im;
    } cmult_out;

    import "DPI-C" function void cmult_matrix_on_real(
        input int  DET_WIDTH,
        input int  M_WIDTH,
        input int  W_WIDTH,
        input int  W_CLIP,
        input  cmult_in  in_data,
        output cmult_out out_data
    );

    logic clk;
    logic [DET_WIDTH-1:0] det_inv;

    logic signed [M_WIDTH-1:0] i_m11_re, i_m11_im;
    logic signed [M_WIDTH-1:0] i_m12_re, i_m12_im;
    logic signed [M_WIDTH-1:0] i_m21_re, i_m21_im;
    logic signed [M_WIDTH-1:0] i_m22_re, i_m22_im;

    logic signed [W_WIDTH-1:0] o_w11_re, o_w11_im;
    logic signed [W_WIDTH-1:0] o_w12_re, o_w12_im;
    logic signed [W_WIDTH-1:0] o_w21_re, o_w21_im;
    logic signed [W_WIDTH-1:0] o_w22_re, o_w22_im;

    logic o_sat_w11_re, o_sat_w11_im;
    logic o_sat_w12_re, o_sat_w12_im;
    logic o_sat_w21_re, o_sat_w21_im;
    logic o_sat_w22_re, o_sat_w22_im;

    int errors = 0;
    int done_num = 0;

    cmult_matrix_on_real #(
        .DET_WIDTH(DET_WIDTH),
        .M_WIDTH(M_WIDTH),
        .W_WIDTH(W_WIDTH),
        .W_CLIP(W_CLIP),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) dut (.*);


    initial clk = 0;
    always #5 clk = ~clk;

    task automatic test(
        input int test_num
    );
        cmult_in in;
        cmult_out out;
        in.det_inv = det_inv;
        in.m11_re  = i_m11_re;  in.m11_im  = i_m11_im;
        in.m12_re  = i_m12_re;  in.m12_im  = i_m12_im;
        in.m21_re  = i_m21_re;  in.m21_im  = i_m21_im;
        in.m22_re  = i_m22_re;  in.m22_im  = i_m22_im;

        cmult_matrix_on_real(DET_WIDTH, M_WIDTH, W_WIDTH, W_CLIP, in, out);

        repeat (1) @(posedge clk);
        #1;

        if (o_sat_w11_re !== out.sat_w11_re[0] || o_sat_w11_im !== out.sat_w11_im[0] ||
            o_sat_w12_re !== out.sat_w12_re[0] || o_sat_w12_im !== out.sat_w12_im[0] ||
            o_sat_w21_re !== out.sat_w21_re[0] || o_sat_w21_im !== out.sat_w21_im[0] ||
            o_sat_w22_re !== out.sat_w22_re[0] || o_sat_w22_im !== out.sat_w22_im[0]) begin
            $error("S%0d_ON FAIL: sat mismatch, got \n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)\nexpected\n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)", test_num,
                   o_sat_w11_re,o_sat_w11_im, o_sat_w12_re,o_sat_w12_im, o_sat_w21_re,o_sat_w21_im, o_sat_w22_re,o_sat_w22_im,
                   out.sat_w11_re, out.sat_w11_im, out.sat_w12_re, out.sat_w12_im,
                   out.sat_w21_re, out.sat_w21_im, out.sat_w22_re, out.sat_w22_im);
            errors++;
        end else if (o_w11_re !== out.w11_re[W_WIDTH-1:0]|| o_w11_im !== out.w11_im[W_WIDTH-1:0] ||
                     o_w12_re !== out.w12_re[W_WIDTH-1:0]|| o_w12_im !== out.w12_im[W_WIDTH-1:0] ||
                     o_w21_re !== out.w21_re[W_WIDTH-1:0]|| o_w21_im !== out.w21_im[W_WIDTH-1:0] ||
                     o_w22_re !== out.w22_re[W_WIDTH-1:0]|| o_w22_im !== out.w22_im[W_WIDTH-1:0]) begin
            $error("S%0d_ON FAIL: got \n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)\nexpected\n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)", test_num,
                   o_w11_re,o_w11_im, o_w12_re,o_w12_im, o_w21_re,o_w21_im, o_w22_re,o_w22_im,
                   out.w11_re[W_WIDTH-1:0], out.w11_im[W_WIDTH-1:0], out.w12_re[W_WIDTH-1:0],out.w12_im[W_WIDTH-1:0],
                   out.w21_re[W_WIDTH-1:0],out.w21_im[W_WIDTH-1:0], out.w22_re[W_WIDTH-1:0],out.w22_im[W_WIDTH-1:0]);
            errors++;
        end else
            $display("S%0d_ON PASS: got \n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)\nexpected\n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)\n(%0d,%0d)", test_num,
                               o_w11_re,o_w11_im, o_w12_re,o_w12_im, o_w21_re,o_w21_im, o_w22_re,o_w22_im,
                               out.w11_re[W_WIDTH-1:0],out.w11_im[W_WIDTH-1:0], out.w12_re[W_WIDTH-1:0],out.w12_im[W_WIDTH-1:0],
                               out.w21_re[W_WIDTH-1:0],out.w21_im[W_WIDTH-1:0], out.w22_re[W_WIDTH-1:0],out.w22_im[W_WIDTH-1:0]);

    endtask
    initial begin
    @(posedge clk);
    det_inv = 0;
    i_m11_re = 0; i_m11_im = 0;
    i_m12_re = 0; i_m12_im = 0;
    i_m21_re = 0; i_m21_im = 0;
    i_m22_re = 0; i_m22_im = 0;
    @(posedge clk);
    test(0);

    det_inv = 1;
    i_m11_re = 1; i_m11_im = 1;
    i_m12_re = 1; i_m12_im = 1;
    i_m21_re = 1; i_m21_im = 1;
    i_m22_re = 1; i_m22_im = 1;
    @(posedge clk);
    test(1);

    det_inv = 1;
    i_m11_re = -1; i_m11_im = -1;
    i_m12_re = -1; i_m12_im = -1;
    i_m21_re = -1; i_m21_im = -1;
    i_m22_re = -1; i_m22_im = -1;
    @(posedge clk);
    test(2);

    det_inv = 256;
    i_m11_re = 32767; i_m11_im = 32767;
    i_m12_re = 32767; i_m12_im = 32767;
    i_m21_re = 32767; i_m21_im = 32767;
    i_m22_re = 32767; i_m22_im = 32767;
    @(posedge clk);
    test(3);

    det_inv = 32768;
    i_m11_re = 256; i_m11_im = 256;
    i_m12_re = 256; i_m12_im = 256;
    i_m21_re = 256; i_m21_im = 256;
    i_m22_re = 256; i_m22_im = 256;
    @(posedge clk);
    test(4);

    det_inv = 65535;
    i_m11_re = 32767; i_m11_im = 32767;
    i_m12_re = 32767; i_m12_im = 32767;
    i_m21_re = 32767; i_m21_im = 32767;
    i_m22_re = 32767; i_m22_im = 32767;
    @(posedge clk);
    test(5);

    det_inv = 65535;
    i_m11_re = -32768; i_m11_im = -32768;
    i_m12_re = -32768; i_m12_im = -32768;
    i_m21_re = -32768; i_m21_im = -32768;
    i_m22_re = -32768; i_m22_im = -32768;
    @(posedge clk);
    test(6);

    det_inv = 128;
    i_m11_re = 1; i_m11_im = -1;
    i_m12_re = 1; i_m12_im = -1;
    i_m21_re = 1; i_m21_im = -1;
    i_m22_re = 1; i_m22_im = -1;
    @(posedge clk);
    test(7);

    det_inv = 32768;
    i_m11_re = 1; i_m11_im = -1;
    i_m12_re = 1; i_m12_im = -1;
    i_m21_re = 1; i_m21_im = -1;
    i_m22_re = 1; i_m22_im = -1;
    @(posedge clk);
    test(8);

    det_inv = 65535;
    i_m11_re = 32767; i_m11_im = -32767;
    i_m12_re = 1; i_m12_im = -1;
    i_m21_re = 0; i_m21_im = 0;
    i_m22_re = 0; i_m22_im = 0;
    @(posedge clk);
    test(9);

    repeat (4) @(posedge clk);
    if (errors == 0) $display("ALL TESTS PASSED");
    else             $display("%0d TESTS FAILED", errors);
end

endmodule
