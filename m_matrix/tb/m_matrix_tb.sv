`timescale 1ns / 1ps

module m_matrix_tb;
    parameter int    A_WIDTH       = 16;
    parameter int    H_WIDTH       = 16;
    parameter int    ROUNDED_WIDTH = 16;
 //   parameter int A_SIGNED         = 0;
 //   parameter int SIGNED_RES       = 1;
 //   parameter int USE_DSP_VALUE    = 1;
    parameter string A_SIGNED         = "no";
    parameter string SIGNED_RES       = "yes";
    parameter string USE_DSP_VALUE    = "yes";

    logic clk = 0;
    logic rst = 0;

    logic [H_WIDTH-1:0] i_h11_re, i_h11_im;
    logic [H_WIDTH-1:0] i_h12_re, i_h12_im;
    logic [H_WIDTH-1:0] i_h21_re, i_h21_im;
    logic [H_WIDTH-1:0] i_h22_re, i_h22_im;
    logic [A_WIDTH-1:0] i_a11, i_a22;
    logic [A_WIDTH-1:0] i_a12_re, i_a12_im;

//    logic [ROUNDED_WIDTH-1:0] m11_re, m11_im;
//    logic [ROUNDED_WIDTH-1:0] m12_re, m12_im;
//    logic [ROUNDED_WIDTH-1:0] m21_re, m21_im;
//    logic [ROUNDED_WIDTH-1:0] m22_re, m22_im;
    logic signed [A_WIDTH+H_WIDTH+1:0] m11_re, m11_im;
    logic signed [A_WIDTH+H_WIDTH+1:0] m12_re, m12_im;
    logic signed [A_WIDTH+H_WIDTH+1:0] m21_re, m21_im;
    logic signed [A_WIDTH+H_WIDTH+1:0] m22_re, m22_im;

    logic o_sat_m11_re, o_sat_m11_im;
    logic o_sat_m12_re, o_sat_m12_im;
    logic o_sat_m21_re, o_sat_m21_im;
    logic o_sat_m22_re, o_sat_m22_im;


    m_matrix #(
        .A_WIDTH       ( A_WIDTH ),
        .H_WIDTH       ( H_WIDTH ),
        .ROUNDED_WIDTH ( ROUNDED_WIDTH ),
        .A_SIGNED      ( A_SIGNED ),
        .SIGNED_RES    ( SIGNED_RES ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) dut (
        .*
    );

    always #5 clk = ~clk;

    typedef struct {
        logic [H_WIDTH-1:0] h11_re, h11_im, h12_re, h12_im, h21_re, h21_im, h22_re, h22_im;
        logic [A_WIDTH-1:0] a11, a22, a12_re, a12_im;
//        logic [ROUNDED_WIDTH-1:0] exp_m11_re, exp_m11_im;
//        logic [ROUNDED_WIDTH-1:0] exp_m12_re, exp_m12_im;
//        logic [ROUNDED_WIDTH-1:0] exp_m21_re, exp_m21_im;
//        logic [ROUNDED_WIDTH-1:0] exp_m22_re, exp_m22_im;
        logic signed [A_WIDTH + H_WIDTH + 1:0] exp_m11_re, exp_m11_im;
        logic signed [A_WIDTH + H_WIDTH + 1:0] exp_m12_re, exp_m12_im;
        logic signed [A_WIDTH + H_WIDTH + 1:0] exp_m21_re, exp_m21_im;
        logic signed [A_WIDTH + H_WIDTH + 1:0] exp_m22_re, exp_m22_im;
    } test_t;

    localparam NUM_TESTS = 4;

    test_t tests[NUM_TESTS];

    initial begin

        tests[0].h11_re  = 16'b1000_0000_0000_0000; tests[0].h11_im  = 16'b1000_0000_0000_0000;
        tests[0].h12_re  = 16'b1000_0000_0000_0000; tests[0].h12_im  = 16'b1000_0000_0000_0000;
        tests[0].h21_re  = 16'b1000_0000_0000_0000; tests[0].h21_im  = 16'b1000_0000_0000_0000;
        tests[0].h22_re  = 16'b1000_0000_0000_0000; tests[0].h22_im  = 16'b1000_0000_0000_0000;
        tests[0].a11     = 16'b1111_1111_1111_1111; tests[0].a22     = 16'b1111_1111_1111_1111;
        tests[0].a12_re  = 16'b1000_0000_0000_0000; tests[0].a12_im  = 16'b1000_0000_0000_0000;
        tests[0].exp_m11_re = -34'd4294934528; tests[0].exp_m11_im = 34'd2147450880;
        tests[0].exp_m12_re = -34'd4294934528; tests[0].exp_m12_im = 34'd2147450880;
        tests[0].exp_m21_re = -34'd2147450880; tests[0].exp_m21_im = 34'd4294934528;
        tests[0].exp_m22_re = -34'd2147450880; tests[0].exp_m22_im = 34'd4294934528;


        tests[1].h11_re  = 16'b0111_1111_1111_1111; tests[1].h11_im  = 16'b0111_1111_1111_1111;
        tests[1].h12_re  = 16'b0111_1111_1111_1111; tests[1].h12_im  = 16'b0111_1111_1111_1111;
        tests[1].h21_re  = 16'b0111_1111_1111_1111; tests[1].h21_im  = 16'b0111_1111_1111_1111;
        tests[1].h22_re  = 16'b0111_1111_1111_1111; tests[1].h22_im  = 16'b0111_1111_1111_1111;
        tests[1].a11     = 16'b1111_1111_1111_1111; tests[1].a22     = 16'b1111_1111_1111_1111;
        tests[1].a12_re  = 16'b0111_1111_1111_1111; tests[1].a12_im  = 16'b0111_1111_1111_1111;
        tests[1].exp_m11_re = 32767;      tests[1].exp_m11_im = -2147385345;
        tests[1].exp_m12_re = 32767;      tests[1].exp_m12_im = -2147385345;
        tests[1].exp_m21_re = 2147385345; tests[1].exp_m21_im = -32767;
        tests[1].exp_m22_re = 2147385345; tests[1].exp_m22_im = -32767;


        tests[2].h11_re  = 16'h01; tests[2].h11_im  = 16'h01;
        tests[2].h12_re  = 16'h01; tests[2].h12_im  = 16'h01;
        tests[2].h21_re  = 16'h01; tests[2].h21_im  = 16'h01;
        tests[2].h22_re  = 16'h01; tests[2].h22_im  = 16'h01;
        tests[2].a11     = 16'h01; tests[2].a22     = 16'h01;
        tests[2].a12_re  = 16'h01; tests[2].a12_im  = 16'h01;
        tests[2].exp_m11_re = -1; tests[2].exp_m11_im = -1;
        tests[2].exp_m12_re = -1; tests[2].exp_m12_im = -1;
        tests[2].exp_m21_re = 1;  tests[2].exp_m21_im = 1;
        tests[2].exp_m22_re = 1;  tests[2].exp_m22_im = 1;


        tests[3].h11_re  = 16'h00; tests[3].h11_im  = 16'h00;
        tests[3].h12_re  = 16'h00; tests[3].h12_im  = 16'h00;
        tests[3].h21_re  = 16'h00; tests[3].h21_im  = 16'h00;
        tests[3].h22_re  = 16'h00; tests[3].h22_im  = 16'h00;
        tests[3].a11     = 16'h00; tests[3].a22     = 16'h00;
        tests[3].a12_re  = 16'h00; tests[3].a12_im  = 16'h00;
        tests[3].exp_m11_re = 0; tests[3].exp_m11_im = 0;
        tests[3].exp_m12_re = 0; tests[3].exp_m12_im = 0;
        tests[3].exp_m21_re = 0; tests[3].exp_m21_im = 0;
        tests[3].exp_m22_re = 0; tests[3].exp_m22_im = 0;
    end

    int test_idx;
    bit test_failed = 0;
    int errors = 0;

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

        for (test_idx = 0; test_idx < NUM_TESTS; test_idx++) begin
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

            $display("Running Test %0d...", test_idx);

            repeat (15) @(posedge clk);

            check_outputs(tests[test_idx]);
        end

        $display("\n==========================================");
        if (errors == 0) begin
            $display("TEST PASSED: All %0d tests passed successfully!", NUM_TESTS);
        end else begin
            $display("TEST FAILED: %0d errors detected in %0d tests!", errors, NUM_TESTS);
        end
        $display("==========================================\n");

    end

    task automatic check_outputs(test_t expected);
        int local_errors = 0;

        if (m11_re !== expected.exp_m11_re) begin
            $display("  ERROR: Test %0d, m11_re = %d, expected %d",
                     test_idx, m11_re, expected.exp_m11_re);
            local_errors++;
        end
        if (m11_im !== expected.exp_m11_im) begin
            $display("  ERROR: Test %0d, m11_im = %d, expected %d",
                     test_idx, m11_im, expected.exp_m11_im);
            local_errors++;
        end
        if (m12_re !== expected.exp_m12_re) begin
            $display("  ERROR: Test %0d, m12_re = %d, expected %d",
                     test_idx, m12_re, expected.exp_m12_re);
            local_errors++;
        end
        if (m12_im !== expected.exp_m12_im) begin
            $display("  ERROR: Test %0d, m12_im = %d, expected %d",
                     test_idx, m12_im, expected.exp_m12_im);
            local_errors++;
        end
        if (m21_re !== expected.exp_m21_re) begin
            $display("  ERROR: Test %0d, m21_re = %d, expected %d",
                     test_idx, m21_re, expected.exp_m21_re);
            local_errors++;
        end
        if (m21_im !== expected.exp_m21_im) begin
            $display("  ERROR: Test %0d, m21_im = %d, expected %d",
                     test_idx, m21_im, expected.exp_m21_im);
            local_errors++;
        end
        if (m22_re !== expected.exp_m22_re) begin
            $display("  ERROR: Test %0d, m22_re = %d, expected %d",
                     test_idx, m22_re, expected.exp_m22_re);
            local_errors++;
        end
        if (m22_im !== expected.exp_m22_im) begin
            $display("  ERROR: Test %0d, m22_im = %d, expected %d",
                     test_idx, m22_im, expected.exp_m22_im);
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
