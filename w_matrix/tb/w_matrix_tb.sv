`timescale 1ns / 1ps

module w_matrix_tb;
    parameter int A_WIDTH       = 16;
    parameter int H_WIDTH       = 16;
    parameter int M_WIDTH       = A_WIDTH + H_WIDTH + 2;
    parameter int DET_WIDTH     = 2*A_WIDTH;
    parameter int FRAC_WIDTH    = 8;
    parameter int USE_DSP_VALUE = 1;
    parameter int USE_INTRP     = 1;
    parameter int INTRP_WIDTH   = 7;
    parameter int DET_INV_WIDTH = DET_WIDTH + USE_INTRP * INTRP_WIDTH + 1;
    parameter int W_WIDTH       = DET_INV_WIDTH + M_WIDTH;

    logic clk = 0;
    logic rst = 0;
    logic i_stb = 0;
    logic o_stb = 0;

    logic signed [H_WIDTH-1:0] i_h11_re, i_h11_im;
    logic signed [H_WIDTH-1:0] i_h12_re, i_h12_im;
    logic signed [H_WIDTH-1:0] i_h21_re, i_h21_im;
    logic signed [H_WIDTH-1:0] i_h22_re, i_h22_im;
    logic [A_WIDTH-1:0] i_a11, i_a22;
    logic signed [A_WIDTH-1:0] i_a12_re, i_a12_im;

    logic signed [W_WIDTH-1:0] o_w11_re, o_w11_im;
    logic signed [W_WIDTH-1:0] o_w12_re, o_w12_im;
    logic signed [W_WIDTH-1:0] o_w21_re, o_w21_im;
    logic signed [W_WIDTH-1:0] o_w22_re, o_w22_im;

    logic o_sat_w11_re, o_sat_w11_im;
    logic o_sat_w12_re, o_sat_w12_im;
    logic o_sat_w21_re, o_sat_w21_im;
    logic o_sat_w22_re, o_sat_w22_im;

    /////////////////////////////////////////////////////
    logic [DET_WIDTH-1:0] o_det_a;
    logic o_det_sat;
    logic o_det_udf;

    logic signed [M_WIDTH-1:0] o_m11_re, o_m11_im;
    logic signed [M_WIDTH-1:0] o_m12_re, o_m12_im;
    logic signed [M_WIDTH-1:0] o_m21_re, o_m21_im;
    logic signed [M_WIDTH-1:0] o_m22_re, o_m22_im;
    logic o_sat_m11_re, o_sat_m11_im;
    logic o_sat_m12_re, o_sat_m12_im;
    logic o_sat_m21_re, o_sat_m21_im;
    logic o_sat_m22_re, o_sat_m22_im;

    logic [DET_INV_WIDTH-1:0] o_det_inv;
    logic o_det_inv_inf;


    logic signed [A_WIDTH+W_WIDTH+1:0] o_e11_re, o_e11_im;
    logic signed [A_WIDTH+W_WIDTH+1:0] o_e12_re, o_e12_im;
    logic signed [A_WIDTH+W_WIDTH+1:0] o_e21_re, o_e21_im;
    logic signed [A_WIDTH+W_WIDTH+1:0] o_e22_re, o_e22_im;
    logic o_sat_e11_re, o_sat_e11_im;
    logic o_sat_e12_re, o_sat_e12_im;
    logic o_sat_e21_re, o_sat_e21_im;
    logic o_sat_e22_re, o_sat_e22_im;

    real i_a11_fxp, i_a22_fxp;
    real i_a12_re_fxp, i_a12_im_fxp;
    real det_a_fxp, det_inv_fxp;

    real h11_re_fxp, h11_im_fxp;
    real h12_re_fxp, h12_im_fxp;
    real h21_re_fxp, h21_im_fxp;
    real h22_re_fxp, h22_im_fxp;
    real m11_re_fxp, m11_im_fxp;
    real m12_re_fxp, m12_im_fxp;
    real m21_re_fxp, m21_im_fxp;
    real m22_re_fxp, m22_im_fxp;

    real w11_re_fxp, w11_im_fxp;
    real w12_re_fxp, w12_im_fxp;
    real w21_re_fxp, w21_im_fxp;
    real w22_re_fxp, w22_im_fxp;


    real e11_re_fxp, e11_im_fxp;
    real e12_re_fxp, e12_im_fxp;
    real e21_re_fxp, e21_im_fxp;
    real e22_re_fxp, e22_im_fxp;

    logic [A_WIDTH-1:0] i_a11_sync;
    logic [A_WIDTH-1:0] i_a22_sync;
    logic [A_WIDTH-1:0] i_a12_re_sync;
    logic [A_WIDTH-1:0] i_a12_im_sync;
    logic [W_WIDTH-1:0] i_w11_re_sync;
    logic [W_WIDTH-1:0] i_w11_im_sync;
    logic [W_WIDTH-1:0] i_w12_re_sync;
    logic [W_WIDTH-1:0] i_w12_im_sync;
    logic [W_WIDTH-1:0] i_w21_re_sync;
    logic [W_WIDTH-1:0] i_w21_im_sync;
    logic [W_WIDTH-1:0] i_w22_re_sync;
    logic [W_WIDTH-1:0] i_w22_im_sync;

    /////////////////////////////////////////////////////

    w_matrix #(
        .A_WIDTH       ( A_WIDTH ),
        .H_WIDTH       ( H_WIDTH ),
        .M_WIDTH       ( M_WIDTH ),
        .DET_WIDTH     ( DET_WIDTH ),
        .DET_INV_WIDTH ( DET_INV_WIDTH ),
        .FRAC_WIDTH    ( FRAC_WIDTH ),
        .W_WIDTH       ( W_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE ),
        .USE_INTRP     ( USE_INTRP ),
        .INTRP_WIDTH   ( INTRP_WIDTH )
    ) dut (
        .*
    );


    matrix_mult #(
        .A_WIDTH       ( A_WIDTH ),
        .W_WIDTH       ( W_WIDTH ),
        .E_WIDTH       ( A_WIDTH+2+W_WIDTH ),
        .FRAC_WIDTH    ( FRAC_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) awx (
        .clk(clk),
        .rst(rst),
        .i_w11_re(i_w11_re_sync),
        .i_w11_im(i_w11_im_sync),
        .i_w12_re(i_w12_re_sync),
        .i_w12_im(i_w12_im_sync),
        .i_w21_re(i_w21_re_sync),
        .i_w21_im(i_w21_im_sync),
        .i_w22_re(i_w22_re_sync),
        .i_w22_im(i_w22_im_sync),
        .i_a11(i_a11_sync),
        .i_a22(i_a22_sync),
        .i_a12_re(i_a12_re_sync),
        .i_a12_im(i_a12_im_sync),
        .o_e11_re(o_e11_re),
        .o_e11_im(o_e11_im),
        .o_e12_re(o_e12_re),
        .o_e12_im(o_e12_im),
        .o_e21_re(o_e21_re),
        .o_e21_im(o_e21_im),
        .o_e22_re(o_e22_re),
        .o_e22_im(o_e22_im)
    );

    always #5 clk = ~clk;

    always @* begin
        i_a11_fxp    = $unsigned(i_a11) * (2.0 ** (-FRAC_WIDTH));
        i_a22_fxp    = $unsigned(i_a22) * (2.0 ** (-FRAC_WIDTH));

        i_a12_re_fxp = $signed(i_a12_re) * (2.0 ** (-FRAC_WIDTH));
        i_a12_im_fxp = $signed(i_a12_im) * (2.0 ** (-FRAC_WIDTH));

        det_a_fxp    = $unsigned(o_det_a) * (2.0 ** (-2*FRAC_WIDTH));
        det_inv_fxp  = $unsigned(o_det_inv) * (2.0 ** (-2*FRAC_WIDTH-INTRP_WIDTH));

        h11_re_fxp = $signed(i_h11_re) * (2.0 ** (-FRAC_WIDTH));
        h11_im_fxp = $signed(i_h11_im) * (2.0 ** (-FRAC_WIDTH));
        h12_re_fxp = $signed(i_h12_re) * (2.0 ** (-FRAC_WIDTH));
        h12_im_fxp = $signed(i_h12_im) * (2.0 ** (-FRAC_WIDTH));
        h21_re_fxp = $signed(i_h21_re) * (2.0 ** (-FRAC_WIDTH));
        h21_im_fxp = $signed(i_h21_im) * (2.0 ** (-FRAC_WIDTH));
        h22_re_fxp = $signed(i_h22_re) * (2.0 ** (-FRAC_WIDTH));
        h22_im_fxp = $signed(i_h22_im) * (2.0 ** (-FRAC_WIDTH));

        m11_re_fxp = $signed(o_m11_re) * (2.0 ** (-2*FRAC_WIDTH));
        m11_im_fxp = $signed(o_m11_im) * (2.0 ** (-2*FRAC_WIDTH));
        m12_re_fxp = $signed(o_m12_re) * (2.0 ** (-2*FRAC_WIDTH));
        m12_im_fxp = $signed(o_m12_im) * (2.0 ** (-2*FRAC_WIDTH));
        m21_re_fxp = $signed(o_m21_re) * (2.0 ** (-2*FRAC_WIDTH));
        m21_im_fxp = $signed(o_m21_im) * (2.0 ** (-2*FRAC_WIDTH));
        m22_re_fxp = $signed(o_m22_re) * (2.0 ** (-2*FRAC_WIDTH));
        m22_im_fxp = $signed(o_m22_im) * (2.0 ** (-2*FRAC_WIDTH));

        w11_re_fxp = $signed(o_w11_re) * (2.0 ** (-4*FRAC_WIDTH-INTRP_WIDTH));
        w11_im_fxp = $signed(o_w11_im) * (2.0 ** (-4*FRAC_WIDTH-INTRP_WIDTH));
        w12_re_fxp = $signed(o_w12_re) * (2.0 ** (-4*FRAC_WIDTH-INTRP_WIDTH));
        w12_im_fxp = $signed(o_w12_im) * (2.0 ** (-4*FRAC_WIDTH-INTRP_WIDTH));
        w21_re_fxp = $signed(o_w21_re) * (2.0 ** (-4*FRAC_WIDTH-INTRP_WIDTH));
        w21_im_fxp = $signed(o_w21_im) * (2.0 ** (-4*FRAC_WIDTH-INTRP_WIDTH));
        w22_re_fxp = $signed(o_w22_re) * (2.0 ** (-4*FRAC_WIDTH-INTRP_WIDTH));
        w22_im_fxp = $signed(o_w22_im) * (2.0 ** (-4*FRAC_WIDTH-INTRP_WIDTH));

        e11_re_fxp = $signed(o_e11_re) * (2.0 ** (-5*FRAC_WIDTH-INTRP_WIDTH));
        e11_im_fxp = $signed(o_e11_im) * (2.0 ** (-5*FRAC_WIDTH-INTRP_WIDTH));
        e12_re_fxp = $signed(o_e12_re) * (2.0 ** (-5*FRAC_WIDTH-INTRP_WIDTH));
        e12_im_fxp = $signed(o_e12_im) * (2.0 ** (-5*FRAC_WIDTH-INTRP_WIDTH));
        e21_re_fxp = $signed(o_e21_re) * (2.0 ** (-5*FRAC_WIDTH-INTRP_WIDTH));
        e21_im_fxp = $signed(o_e21_im) * (2.0 ** (-5*FRAC_WIDTH-INTRP_WIDTH));
        e22_re_fxp = $signed(o_e22_re) * (2.0 ** (-5*FRAC_WIDTH-INTRP_WIDTH));
        e22_im_fxp = $signed(o_e22_im) * (2.0 ** (-5*FRAC_WIDTH-INTRP_WIDTH));
    end

    typedef struct {
        logic signed [H_WIDTH-1:0] h11_re, h11_im, h12_re, h12_im, h21_re, h21_im, h22_re, h22_im;
        logic [A_WIDTH-1:0] a11, a22;
        logic signed [A_WIDTH-1:0] a12_re, a12_im;
    } test_t;

    localparam NUM_TESTS = 16;
    // localparam NUM_TESTS = 1;

    test_t tests[NUM_TESTS];

    initial begin

        for (int i = 0; i < 16; i++) begin
            tests[i].h11_re  = 16'b0000_0001_0000_0000; tests[i].h11_im  = 16'b0000_0000_0000_0000;
            tests[i].h12_re  = 16'b0000_0000_0000_0000; tests[i].h12_im  = 16'b0000_0000_0000_0000;
            tests[i].h21_re  = 16'b0000_0000_0000_0000; tests[i].h21_im  = 16'b0000_0000_0000_0000;
            tests[i].h22_re  = 16'b0000_0001_0000_0000; tests[i].h22_im  = 16'b0000_0000_0000_0000;
            if (i < 4) begin
                tests[i].a11     = $urandom_range(1, 16);
                tests[i].a22     = $urandom_range(1, 16);
                tests[i].a12_re  = $urandom_range(1, 4);
                tests[i].a12_im  = $urandom_range(1, 4);
            end
            else if (i < 8) begin
                tests[i].a11     = $urandom_range(16, 256)*4;
                tests[i].a22     = $urandom_range(16, 256)*4;
                tests[i].a12_re  = $urandom_range(16, 256)/4;
                tests[i].a12_im  = $urandom_range(16, 256)/4;
            end
            else if (i < 12) begin
                tests[i].a11     = $urandom_range(256, 4096)*4;
                tests[i].a22     = $urandom_range(256, 4096)*4;
                tests[i].a12_re  = $urandom_range(256, 4096)/4;
                tests[i].a12_im  = $urandom_range(256, 4096)/4;
            end
            else begin
                tests[i].a11     = $urandom_range(4096, 65535);
                tests[i].a22     = $urandom_range(4096, 65535);
                tests[i].a12_re  = $urandom_range(4096, 16393);
                tests[i].a12_im  = $urandom_range(4096, 16393);
            end

        end

    end

    int test_idx;
    bit test_failed = 0;
    int errors = 0;

    int cycle_cnt = 0;
    typedef struct{
        int test_idx;
        real det_a;
        real det_inv;
        logic [A_WIDTH-1:0] in_a11;
        logic [A_WIDTH-1:0] in_a12_re;
        logic [A_WIDTH-1:0] in_a12_im;
        logic [A_WIDTH-1:0] in_a22;
        real o_w11_re_fxp;
        real o_w11_im_fxp;
        real o_w12_re_fxp;
        real o_w12_im_fxp;
        real o_w21_re_fxp;
        real o_w21_im_fxp;
        real o_w22_re_fxp;
        real o_w22_im_fxp;
        real e11_re_fxp;
        real e11_im_fxp;
        real e22_re_fxp;
        real e22_im_fxp;
    } test_data_t;
    test_data_t test_storage[16];

    initial begin
        i_h11_re  = 0; i_h11_im  = 0;
        i_h12_re  = 0; i_h12_im  = 0;
        i_h21_re  = 0; i_h21_im  = 0;
        i_h22_re  = 0; i_h22_im  = 0;
        i_a11     = 0; i_a22     = 0;
        i_a12_re  = 0; i_a12_im  = 0;

        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;

        repeat (2) @(posedge clk);

        fork
            begin
                i_stb = 1;
                for (test_idx = 0; test_idx < NUM_TESTS; test_idx++) begin
                    test_storage[test_idx].test_idx = test_idx;
                    i_h11_re  = tests[test_idx].h11_re;
                    i_h11_im  = tests[test_idx].h11_im;
                    i_h12_re  = tests[test_idx].h12_re;
                    i_h12_im  = tests[test_idx].h12_im;
                    i_h21_re  = tests[test_idx].h21_re;
                    i_h21_im  = tests[test_idx].h21_im;
                    i_h22_re  = tests[test_idx].h22_re;
                    i_h22_im  = tests[test_idx].h22_im;
                    i_a11     = tests[test_idx].a11;
                    i_a22     = tests[test_idx].a22;
                    i_a12_re  = tests[test_idx].a12_re;
                    i_a12_im  = tests[test_idx].a12_im;
                    test_storage[test_idx].in_a11    = tests[test_idx].a11;
                    test_storage[test_idx].in_a22    = tests[test_idx].a22;
                    test_storage[test_idx].in_a12_re = tests[test_idx].a12_re;
                    test_storage[test_idx].in_a12_im = tests[test_idx].a12_im;

                    $display("Running Test %0d...", test_idx);

                    @(posedge clk);
                end
                i_stb = 0;
            end

            begin
                for (int i = 0; i < 35; i++) begin
                    if (cycle_cnt - 5 >= 0) begin
                        test_storage[cycle_cnt - 5].det_a = det_a_fxp;
                    end

                    if (cycle_cnt - 9 >= 0) begin
                        test_storage[cycle_cnt - 9].det_inv = det_inv_fxp;
                    end

                    if (cycle_cnt - 11 >= 0) begin
                        i_w11_re_sync = o_w11_re;
                        i_w11_im_sync = o_w11_im;
                        i_w12_re_sync = o_w12_re;
                        i_w12_im_sync = o_w12_im;
                        i_w21_re_sync = o_w21_re;
                        i_w21_im_sync = o_w21_im;
                        i_w22_re_sync = o_w22_re;
                        i_w22_im_sync = o_w22_im;
                        i_a11_sync = test_storage[cycle_cnt - 11].in_a11;
                        i_a22_sync = test_storage[cycle_cnt - 11].in_a22;
                        i_a12_re_sync = test_storage[cycle_cnt - 11].in_a12_re;
                        i_a12_im_sync = test_storage[cycle_cnt - 11].in_a12_im;
                    end

                    if (cycle_cnt - 16 >= 0) begin
                        test_storage[cycle_cnt - 16].e11_re_fxp = e11_re_fxp;
                        test_storage[cycle_cnt - 16].e11_im_fxp = e11_im_fxp;
                        test_storage[cycle_cnt - 16].e22_re_fxp = e22_re_fxp;
                        test_storage[cycle_cnt - 16].e22_im_fxp = e22_im_fxp;
                    end

                    @(posedge clk);
                    cycle_cnt++;
                end
            end
        join

        for (test_idx = 0; test_idx < NUM_TESTS; test_idx++) begin
            check_outputs(test_storage[test_idx]);
        end


        $display("\n==========================================");
        if (errors == 0) begin
            $display("TEST PASSED: All %0d tests passed successfully!", NUM_TESTS);
        end else begin
            $display("TEST FAILED: %0d errors detected in %0d tests!", errors, NUM_TESTS);
        end
        $display("==========================================\n");

    end
    task automatic check_outputs(test_data_t test);
        int local_errors = 0;

        if (test.det_a * test.det_inv > 1.05 || test.det_inv * test.det_a < 0.95
            || test.e11_re_fxp >=1.05 || test.e11_re_fxp <= 0.95
            || test.e22_re_fxp >= 1.05 || test.e22_re_fxp <= 0.95) begin
            $display(" ERROR: Test %0d, det_inv = %f, det_a = %f, det_inv * det_a = %f, expected %f",
                     test.test_idx, test.det_inv, test.det_a, test.det_inv * test.det_a, 1.0);
            $display(" e11 = %f, e22 = %f",
                     test.e11_re_fxp, test.e22_re_fxp);
            local_errors++;
        end

        if (local_errors == 0) begin
            $display("     PASSED Test %0d, det_inv = %f, det_a = %f, det_inv * det_a = %f",
                    test.test_idx, test.det_inv, test.det_a, test.det_inv * test.det_a);
            $display("     e11 = %f, e22 = %f",
                     test.e11_re_fxp, test.e22_re_fxp);
        end else begin
            errors += local_errors;
            test_failed = 1;
        end
    endtask


endmodule
