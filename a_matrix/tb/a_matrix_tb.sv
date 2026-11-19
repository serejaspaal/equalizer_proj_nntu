`timescale 1ns / 1ps

typedef struct {
    longint signed h11_re;
    longint signed h11_im;
    longint signed h12_re;
    longint signed h12_im;
    longint signed h21_re;
    longint signed h21_im;
    longint signed h22_re;
    longint signed h22_im;
    longint signed c11;
    longint signed c22;
} a_matrix_t;

import "DPI-C" function real set_disp(input int idx);

import "DPI-C" function void next_sample(
    output real h11_re, h11_im,
    output real h12_re, h12_im,
    output real h21_re, h21_im,
    output real h22_re, h22_im,
    output real c11, c22
);

import "DPI-C" function void a_matrix(
    input a_matrix_t mat,
    input int h_width,
    input int c_width,
    input int a_width,
    input int point_pos,
    output longint o_a11,
    output longint o_a22,
    output longint o_a12_re,
    output longint o_a12_im,
    output int sat_a11,
    output int sat_a22,
    output int sat_a12_re,
    output int sat_a12_im
);

module a_matrix_tb;

    parameter int H_WIDTH = 16;
    parameter int C_WIDTH = 16;
    parameter int A_WIDTH = H_WIDTH + C_WIDTH + 2;
    parameter int POINT_POS = 8;
    parameter int USE_DSP_VALUE = 1;

    parameter int TEST_COUNT = 20;

    logic clk;
    logic rst;
    logic i_stb;
    logic o_stb;

    logic signed [H_WIDTH-1:0] i_h11_re, i_h11_im;
    logic signed [H_WIDTH-1:0] i_h12_re, i_h12_im;
    logic signed [H_WIDTH-1:0] i_h21_re, i_h21_im;
    logic signed [H_WIDTH-1:0] i_h22_re, i_h22_im;

    logic [C_WIDTH-1:0] i_c11, i_c22;

    logic [A_WIDTH-1:0] o_a11, o_a22;
    logic signed [A_WIDTH-1:0] o_a12_re, o_a12_im;

    logic o_sat_a11;
    logic o_sat_a22;
    logic o_sat_a12_re;
    logic o_sat_a12_im;

    localparam real H_SCALE = 2.0 ** POINT_POS;
    localparam real C_SCALE = 2.0 ** POINT_POS;

    longint expected_a11 [0:TEST_COUNT-1];
    longint expected_a22 [0:TEST_COUNT-1];
    longint expected_a12_re [0:TEST_COUNT-1];
    longint expected_a12_im [0:TEST_COUNT-1];

    int expected_sat_a11 [0:TEST_COUNT-1];
    int expected_sat_a22 [0:TEST_COUNT-1];
    int expected_sat_a12_re [0:TEST_COUNT-1];
    int expected_sat_a12_im [0:TEST_COUNT-1];

    int errors = 0;
    int checked = 0;
    int sent = 0;

    real rh11r, rh11i;
    real rh12r, rh12i;
    real rh21r, rh21i;
    real rh22r, rh22i;
    real rc11, rc22;

    a_matrix_t mat;

    longint ref_a11;
    longint ref_a22;
    longint ref_a12_re;
    longint ref_a12_im;

    int ref_sat_a11;
    int ref_sat_a22;
    int ref_sat_a12_re;
    int ref_sat_a12_im;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    a_matrix #(
        .H_WIDTH(H_WIDTH),
        .C_WIDTH(C_WIDTH),
        .A_WIDTH(A_WIDTH),
        .POINT_POS(POINT_POS),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .i_stb(i_stb),

        .i_h11_re(i_h11_re),
        .i_h11_im(i_h11_im),
        .i_h12_re(i_h12_re),
        .i_h12_im(i_h12_im),
        .i_h21_re(i_h21_re),
        .i_h21_im(i_h21_im),
        .i_h22_re(i_h22_re),
        .i_h22_im(i_h22_im),

        .i_c11(i_c11),
        .i_c22(i_c22),

        .o_stb(o_stb),

        .o_a11(o_a11),
        .o_a22(o_a22),
        .o_a12_re(o_a12_re),
        .o_a12_im(o_a12_im),

        .o_sat_a11(o_sat_a11),
        .o_sat_a22(o_sat_a22),
        .o_sat_a12_re(o_sat_a12_re),
        .o_sat_a12_im(o_sat_a12_im)
    );

    initial begin
        rst = 1'b1;
        i_stb = 1'b0;

        i_h11_re = '0;
        i_h11_im = '0;
        i_h12_re = '0;
        i_h12_im = '0;
        i_h21_re = '0;
        i_h21_im = '0;
        i_h22_re = '0;
        i_h22_im = '0;

        i_c11 = '0;
        i_c22 = '0;

        repeat (10) @(posedge clk);
        @(negedge clk);
        rst = 1'b0;

        set_disp(4);

        repeat (2) @(negedge clk);

        for (int n = 0; n < TEST_COUNT; n++) begin
            next_sample(
                rh11r, rh11i,
                rh12r, rh12i,
                rh21r, rh21i,
                rh22r, rh22i,
                rc11, rc22
            );

            i_h11_re = H_WIDTH'($rtoi(rh11r * H_SCALE));
            i_h11_im = H_WIDTH'($rtoi(rh11i * H_SCALE));
            i_h12_re = H_WIDTH'($rtoi(rh12r * H_SCALE));
            i_h12_im = H_WIDTH'($rtoi(rh12i * H_SCALE));
            i_h21_re = H_WIDTH'($rtoi(rh21r * H_SCALE));
            i_h21_im = H_WIDTH'($rtoi(rh21i * H_SCALE));
            i_h22_re = H_WIDTH'($rtoi(rh22r * H_SCALE));
            i_h22_im = H_WIDTH'($rtoi(rh22i * H_SCALE));

            i_c11 = C_WIDTH'($rtoi(rc11 * C_SCALE));
            i_c22 = C_WIDTH'($rtoi(rc22 * C_SCALE));

            mat.h11_re = $signed(i_h11_re);
            mat.h11_im = $signed(i_h11_im);
            mat.h12_re = $signed(i_h12_re);
            mat.h12_im = $signed(i_h12_im);
            mat.h21_re = $signed(i_h21_re);
            mat.h21_im = $signed(i_h21_im);
            mat.h22_re = $signed(i_h22_re);
            mat.h22_im = $signed(i_h22_im);

            mat.c11 = i_c11;
            mat.c22 = i_c22;

            a_matrix(
                mat,
                H_WIDTH,
                C_WIDTH,
                A_WIDTH,
                POINT_POS,
                ref_a11,
                ref_a22,
                ref_a12_re,
                ref_a12_im,
                ref_sat_a11,
                ref_sat_a22,
                ref_sat_a12_re,
                ref_sat_a12_im
            );

            expected_a11[sent] = ref_a11;
            expected_a22[sent] = ref_a22;
            expected_a12_re[sent] = ref_a12_re;
            expected_a12_im[sent] = ref_a12_im;

            expected_sat_a11[sent] = ref_sat_a11;
            expected_sat_a22[sent] = ref_sat_a22;
            expected_sat_a12_re[sent] = ref_sat_a12_re;
            expected_sat_a12_im[sent] = ref_sat_a12_im;

            i_stb = 1'b1;
            sent++;

            @(negedge clk);
        end

        i_stb = 1'b0;

        repeat (20) @(negedge clk);
        #2;

        if (checked != sent) begin
            errors++;
            $error(
                "Test count mismatch: sent=%0d checked=%0d",
                sent,
                checked
            );
        end

        if (errors == 0) begin
            $display(
                "ALL TESTS PASSED: sent=%0d checked=%0d errors=%0d",
                sent, checked, errors
            );
        end else begin
            $display(
                "TEST FAILED: sent=%0d checked=%0d errors=%0d",
                sent, checked, errors
            );
            $fatal(1, "a_matrix RTL does not match DPI-C model");
        end

        $finish;
    end

    always @(negedge clk) begin
        if (!rst && o_stb) begin
            checked++;

            if (o_a11 !== A_WIDTH'(expected_a11[checked-1]) ||
                o_sat_a11 !== expected_sat_a11[checked-1][0]) begin
                errors++;
                $error(
                    "a11 mismatch: RTL=%h/%b C=%h/%b",
                    o_a11, o_sat_a11,
                    expected_a11[checked-1][A_WIDTH-1:0],
                    expected_sat_a11[checked-1][0]
                );
            end

            if (o_a22 !== A_WIDTH'(expected_a22[checked-1]) ||
                o_sat_a22 !== expected_sat_a22[checked-1][0]) begin
                errors++;
                $error(
                    "a22 mismatch: RTL=%h/%b C=%h/%b",
                    o_a22, o_sat_a22,
                    expected_a22[checked-1][A_WIDTH-1:0],
                    expected_sat_a22[checked-1][0]
                );
            end

            if ($signed(o_a12_re) !== expected_a12_re[checked-1] ||
                o_sat_a12_re !== expected_sat_a12_re[checked-1][0]) begin
                errors++;
                $error(
                    "a12_re mismatch: RTL=%h/%b C=%h/%b",
                    o_a12_re, o_sat_a12_re,
                    expected_a12_re[checked-1][A_WIDTH-1:0],
                    expected_sat_a12_re[checked-1][0]
                );
            end

            if ($signed(o_a12_im) !== expected_a12_im[checked-1] ||
                o_sat_a12_im !== expected_sat_a12_im[checked-1][0]) begin
                errors++;
                $error(
                    "a12_im mismatch: RTL=%h/%b C=%h/%b",
                    o_a12_im, o_sat_a12_im,
                    expected_a12_im[checked-1][A_WIDTH-1:0],
                    expected_sat_a12_im[checked-1][0]
                );
            end

            if (o_a11 === A_WIDTH'(expected_a11[checked-1]) &&
                o_sat_a11 === expected_sat_a11[checked-1][0] &&
                o_a22 === A_WIDTH'(expected_a22[checked-1]) &&
                o_sat_a22 === expected_sat_a22[checked-1][0] &&
                $signed(o_a12_re) === expected_a12_re[checked-1] &&
                o_sat_a12_re === expected_sat_a12_re[checked-1][0] &&
                $signed(o_a12_im) === expected_a12_im[checked-1] &&
                o_sat_a12_im === expected_sat_a12_im[checked-1][0]) begin
                $display(
                    "PASS #%0d: a11=%h sat=%b; a22=%h sat=%b; a12_re=%h sat=%b; a12_im=%h sat=%b",
                    checked,
                    o_a11, o_sat_a11,
                    o_a22, o_sat_a22,
                    o_a12_re, o_sat_a12_re,
                    o_a12_im, o_sat_a12_im
                );
            end
        end
    end

endmodule
