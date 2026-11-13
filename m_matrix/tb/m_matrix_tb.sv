`timescale 1ns / 1ps

module m_matrix_tb;
    parameter int A_WIDTH       = 16;
    parameter int H_WIDTH       = 16;
    parameter int M_WIDTH       = 24;
    parameter int M_CLIP        = 9;
    parameter int USE_DSP_VALUE = 1;

    typedef struct {
        longint h11_re, h11_im;
        longint h12_re, h12_im;
        longint h21_re, h21_im;
        longint h22_re, h22_im;
        longint a11, a22;
        longint a12_re, a12_im;
    } m_matrix_in_t;

    typedef struct {
        longint m11_re, m11_im;
        longint m12_re, m12_im;
        longint m21_re, m21_im;
        longint m22_re, m22_im;
        int     sat_m11_re, sat_m11_im;
        int     sat_m12_re, sat_m12_im;
        int     sat_m21_re, sat_m21_im;
        int     sat_m22_re, sat_m22_im;
    } m_matrix_out_t;

    import "DPI-C" function void m_matrix(
        input  m_matrix_in_t  in,
        input  int            a_width,
        input  int            h_width,
        input  int            m_width,
        input  int            m_clip,
        output m_matrix_out_t out
    );

    logic clk = 0;
    logic rst = 0;

    logic signed [H_WIDTH-1:0] i_h11_re, i_h11_im;
    logic signed [H_WIDTH-1:0] i_h12_re, i_h12_im;
    logic signed [H_WIDTH-1:0] i_h21_re, i_h21_im;
    logic signed [H_WIDTH-1:0] i_h22_re, i_h22_im;
    logic        [A_WIDTH-1:0] i_a11, i_a22;
    logic signed [A_WIDTH-1:0] i_a12_re, i_a12_im;

    logic signed [M_WIDTH-1:0] o_m11_re, o_m11_im;
    logic signed [M_WIDTH-1:0] o_m12_re, o_m12_im;
    logic signed [M_WIDTH-1:0] o_m21_re, o_m21_im;
    logic signed [M_WIDTH-1:0] o_m22_re, o_m22_im;

    logic o_sat_m11_re, o_sat_m11_im;
    logic o_sat_m12_re, o_sat_m12_im;
    logic o_sat_m21_re, o_sat_m21_im;
    logic o_sat_m22_re, o_sat_m22_im;

    // Ожидаемые значения от эталонной модели на Си
    logic signed [M_WIDTH-1:0] exp_m11_re, exp_m11_im;
    logic signed [M_WIDTH-1:0] exp_m12_re, exp_m12_im;
    logic signed [M_WIDTH-1:0] exp_m21_re, exp_m21_im;
    logic signed [M_WIDTH-1:0] exp_m22_re, exp_m22_im;

    logic exp_sat_m11_re, exp_sat_m11_im;
    logic exp_sat_m12_re, exp_sat_m12_im;
    logic exp_sat_m21_re, exp_sat_m21_im;
    logic exp_sat_m22_re, exp_sat_m22_im;

    real i_a11_fxp, i_a22_fxp;
    real i_a12_re_fxp, i_a12_im_fxp;
    real h11_re_fxp, h11_im_fxp;
    real h12_re_fxp, h12_im_fxp;
    real h21_re_fxp, h21_im_fxp;
    real h22_re_fxp, h22_im_fxp;
    real m11_re_fxp, m11_im_fxp;
    real m12_re_fxp, m12_im_fxp;
    real m21_re_fxp, m21_im_fxp;
    real m22_re_fxp, m22_im_fxp;

    localparam int FRAC_WIDTH = 8;

    m_matrix #(
        .A_WIDTH       ( A_WIDTH ),
        .H_WIDTH       ( H_WIDTH ),
        .M_WIDTH       ( M_WIDTH ),
        .M_CLIP        ( M_CLIP ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) dut (
        .*
    );

    always #5 clk = ~clk;

    always @* begin
        i_a11_fxp    = $unsigned(i_a11) * (2.0 ** (-FRAC_WIDTH));
        i_a22_fxp    = $unsigned(i_a22) * (2.0 ** (-FRAC_WIDTH));

        i_a12_re_fxp = $signed(i_a12_re) * (2.0 ** (-FRAC_WIDTH));
        i_a12_im_fxp = $signed(i_a12_im) * (2.0 ** (-FRAC_WIDTH));

        h11_re_fxp = $signed(i_h11_re) * (2.0 ** (-FRAC_WIDTH));
        h11_im_fxp = $signed(i_h11_im) * (2.0 ** (-FRAC_WIDTH));
        h12_re_fxp = $signed(i_h12_re) * (2.0 ** (-FRAC_WIDTH));
        h12_im_fxp = $signed(i_h12_im) * (2.0 ** (-FRAC_WIDTH));
        h21_re_fxp = $signed(i_h21_re) * (2.0 ** (-FRAC_WIDTH));
        h21_im_fxp = $signed(i_h21_im) * (2.0 ** (-FRAC_WIDTH));
        h22_re_fxp = $signed(i_h22_re) * (2.0 ** (-FRAC_WIDTH));
        h22_im_fxp = $signed(i_h22_im) * (2.0 ** (-FRAC_WIDTH));

        m11_re_fxp = $signed(o_m11_re) * (2.0 ** (-16));
        m11_im_fxp = $signed(o_m11_im) * (2.0 ** (-16));
        m12_re_fxp = $signed(o_m12_re) * (2.0 ** (-16));
        m12_im_fxp = $signed(o_m12_im) * (2.0 ** (-16));
        m21_re_fxp = $signed(o_m21_re) * (2.0 ** (-16));
        m21_im_fxp = $signed(o_m21_im) * (2.0 ** (-16));
        m22_re_fxp = $signed(o_m22_re) * (2.0 ** (-16));
        m22_im_fxp = $signed(o_m22_im) * (2.0 ** (-16));
    end

    localparam int NUM_TESTS = 4;
    m_matrix_in_t tests[NUM_TESTS];

    initial begin
        tests[0].h11_re = 16'sd256;   tests[0].h11_im = 16'sd0;
        tests[0].h12_re = 16'sd0;     tests[0].h12_im = 16'sd0;
        tests[0].h21_re = 16'sd0;     tests[0].h21_im = 16'sd0;
        tests[0].h22_re = 16'sd256;   tests[0].h22_im = 16'sd0;
        tests[0].a11    = 16'd32512;  tests[0].a22    = 16'd32512;
        tests[0].a12_re = 16'sd1280;  tests[0].a12_im = 16'sd3072;

        tests[1].h11_re = 16'sd32767; tests[1].h11_im = 16'sd32767;
        tests[1].h12_re = 16'sd32767; tests[1].h12_im = 16'sd32767;
        tests[1].h21_re = 16'sd32767; tests[1].h21_im = 16'sd32767;
        tests[1].h22_re = 16'sd32767; tests[1].h22_im = 16'sd32767;
        tests[1].a11    = 16'd65535;  tests[1].a22    = 16'd65535;
        tests[1].a12_re = 16'sd32767; tests[1].a12_im = 16'sd32767;

        tests[2].h11_re = 16'sd1;     tests[2].h11_im = 16'sd1;
        tests[2].h12_re = 16'sd1;     tests[2].h12_im = 16'sd1;
        tests[2].h21_re = 16'sd1;     tests[2].h21_im = 16'sd1;
        tests[2].h22_re = 16'sd1;     tests[2].h22_im = 16'sd1;
        tests[2].a11    = 16'd1;      tests[2].a22    = 16'd1;
        tests[2].a12_re = 16'sd1;     tests[2].a12_im = 16'sd1;

        tests[3].h11_re = 16'sd0;     tests[3].h11_im = 16'sd0;
        tests[3].h12_re = 16'sd0;     tests[3].h12_im = 16'sd0;
        tests[3].h21_re = 16'sd0;     tests[3].h21_im = 16'sd0;
        tests[3].h22_re = 16'sd0;     tests[3].h22_im = 16'sd0;
        tests[3].a11    = 16'd0;      tests[3].a22    = 16'd0;
        tests[3].a12_re = 16'sd0;     tests[3].a12_im = 16'sd0;
    end

    int test_idx;
    bit test_failed = 0;
    int errors = 0;

    initial begin
        i_h11_re = 0; i_h11_im = 0;
        i_h12_re = 0; i_h12_im = 0;
        i_h21_re = 0; i_h21_im = 0;
        i_h22_re = 0; i_h22_im = 0;
        i_a11    = 0; i_a22    = 0;
        i_a12_re = 0; i_a12_im = 0;

        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;

        repeat (2) @(posedge clk);

        for (test_idx = 0; test_idx < NUM_TESTS; test_idx++) begin
            m_matrix_out_t c_out;

            @(posedge clk);
            i_h11_re = tests[test_idx].h11_re[H_WIDTH-1:0];
            i_h11_im = tests[test_idx].h11_im[H_WIDTH-1:0];
            i_h12_re = tests[test_idx].h12_re[H_WIDTH-1:0];
            i_h12_im = tests[test_idx].h12_im[H_WIDTH-1:0];
            i_h21_re = tests[test_idx].h21_re[H_WIDTH-1:0];
            i_h21_im = tests[test_idx].h21_im[H_WIDTH-1:0];
            i_h22_re = tests[test_idx].h22_re[H_WIDTH-1:0];
            i_h22_im = tests[test_idx].h22_im[H_WIDTH-1:0];
            i_a11    = tests[test_idx].a11[A_WIDTH-1:0];
            i_a22    = tests[test_idx].a22[A_WIDTH-1:0];
            i_a12_re = tests[test_idx].a12_re[A_WIDTH-1:0];
            i_a12_im = tests[test_idx].a12_im[A_WIDTH-1:0];

            m_matrix(
                tests[test_idx],
                A_WIDTH,
                H_WIDTH,
                M_WIDTH,
                M_CLIP,
                c_out
            );

            exp_m11_re = c_out.m11_re[M_WIDTH-1:0];
            exp_m11_im = c_out.m11_im[M_WIDTH-1:0];
            exp_m12_re = c_out.m12_re[M_WIDTH-1:0];
            exp_m12_im = c_out.m12_im[M_WIDTH-1:0];
            exp_m21_re = c_out.m21_re[M_WIDTH-1:0];
            exp_m21_im = c_out.m21_im[M_WIDTH-1:0];
            exp_m22_re = c_out.m22_re[M_WIDTH-1:0];
            exp_m22_im = c_out.m22_im[M_WIDTH-1:0];

            exp_sat_m11_re = c_out.sat_m11_re[0];
            exp_sat_m11_im = c_out.sat_m11_im[0];
            exp_sat_m12_re = c_out.sat_m12_re[0];
            exp_sat_m12_im = c_out.sat_m12_im[0];
            exp_sat_m21_re = c_out.sat_m21_re[0];
            exp_sat_m21_im = c_out.sat_m21_im[0];
            exp_sat_m22_re = c_out.sat_m22_re[0];
            exp_sat_m22_im = c_out.sat_m22_im[0];

            $display("Running Test %0d...", test_idx);

            repeat (15) @(posedge clk);

            check_outputs();
        end

        $display("\n==========================================");
        if (errors == 0) begin
            $display("TEST PASSED: All %0d tests passed successfully!", NUM_TESTS);
        end else begin
            $display("TEST FAILED: %0d errors detected in %0d tests!", errors, NUM_TESTS);
        end
        $display("==========================================\n");
    end

    task automatic check_outputs();
        int local_errors = 0;

        if (o_m11_re !== exp_m11_re) begin
            $display("  ERROR: Test %0d, m11_re = %0d, expected %0d", test_idx, o_m11_re, exp_m11_re);
            local_errors++;
        end
        if (o_m11_im !== exp_m11_im) begin
            $display("  ERROR: Test %0d, m11_im = %0d, expected %0d", test_idx, o_m11_im, exp_m11_im);
            local_errors++;
        end
        if (o_m12_re !== exp_m12_re) begin
            $display("  ERROR: Test %0d, m12_re = %0d, expected %0d", test_idx, o_m12_re, exp_m12_re);
            local_errors++;
        end
        if (o_m12_im !== exp_m12_im) begin
            $display("  ERROR: Test %0d, m12_im = %0d, expected %0d", test_idx, o_m12_im, exp_m12_im);
            local_errors++;
        end
        if (o_m21_re !== exp_m21_re) begin
            $display("  ERROR: Test %0d, m21_re = %0d, expected %0d", test_idx, o_m21_re, exp_m21_re);
            local_errors++;
        end
        if (o_m21_im !== exp_m21_im) begin
            $display("  ERROR: Test %0d, m21_im = %0d, expected %0d", test_idx, o_m21_im, exp_m21_im);
            local_errors++;
        end
        if (o_m22_re !== exp_m22_re) begin
            $display("  ERROR: Test %0d, m22_re = %0d, expected %0d", test_idx, o_m22_re, exp_m22_re);
            local_errors++;
        end
        if (o_m22_im !== exp_m22_im) begin
            $display("  ERROR: Test %0d, m22_im = %0d, expected %0d", test_idx, o_m22_im, exp_m22_im);
            local_errors++;
        end

        if (o_sat_m11_re !== exp_sat_m11_re || o_sat_m11_im !== exp_sat_m11_im ||
            o_sat_m12_re !== exp_sat_m12_re || o_sat_m12_im !== exp_sat_m12_im ||
            o_sat_m21_re !== exp_sat_m21_re || o_sat_m21_im !== exp_sat_m21_im ||
            o_sat_m22_re !== exp_sat_m22_re || o_sat_m22_im !== exp_sat_m22_im) begin
            $display("  ERROR: Test %0d, saturation flags mismatch!", test_idx);
            local_errors++;
        end

        if (local_errors == 0) begin
            $display("  Test %0d PASSED", test_idx);
        end else begin
            errors += local_errors;
            test_failed = 1;
        end
    endtask

endmodule