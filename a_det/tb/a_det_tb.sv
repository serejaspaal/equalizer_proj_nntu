`timescale 1ns / 1ps

module a_det_tb;
    parameter int A_WIDTH       = 16;
    parameter int DET_WIDTH     = 2*A_WIDTH;
    parameter int USE_DSP_VALUE = 1;

    typedef struct {
        int a11;
        int a22;
        int a12_re;
        int a12_im;
    } a_matrix_t;

    import "DPI-C" function int a_det(
        input  a_matrix_t mat,
        input  int        a_width,
        input  int        det_width,
        output int        o_det_sat,
        output int        o_sum_udf
    );

    logic clk = 0;
    logic rst = 0;

    logic [A_WIDTH-1:0]   i_a11, i_a22;
    logic [A_WIDTH-1:0]   i_a12_re, i_a12_im;

    logic [DET_WIDTH-1:0] o_det_a;
    logic                 o_det_sat;
    logic                 o_sum_udf;

    logic [DET_WIDTH-1:0] exp_det_a;
    logic                 exp_det_sat;
    logic                 exp_sum_udf;

    a_det #(
        .A_WIDTH       ( A_WIDTH ),
        .DET_WIDTH     ( DET_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) dut (
        .*
    );

    always #5 clk = ~clk;

    localparam int NUM_TESTS = 6;
    a_matrix_t tests[NUM_TESTS];

    initial begin
    
        tests[0] = '{a11: 16'hFFFF, a22: 16'hFFFF, a12_re: 16'h8000, a12_im: 16'h8000};

        tests[1] = '{a11: 16'hFFFF, a22: 16'hFFFF, a12_re: 16'h7FFF, a12_im: 16'h7FFF};

        tests[2] = '{a11: 16'h0001, a22: 16'h0001, a12_re: 16'h0001, a12_im: 16'h0001};

        tests[3] = '{a11: 16'h0000, a22: 16'h0000, a12_re: 16'h0000, a12_im: 16'h0000};

        tests[4] = '{a11: 16'd100,  a22: 16'd200,  a12_re: 16'd5,    a12_im: -16'sd5};

        tests[5] = '{a11: 16'd0,    a22: 16'd0,    a12_re: 16'd30000, a12_im: 16'd30000};
    end

    int test_idx;
    int errors = 0;

    initial begin
        $display("=== A_DET TESTBENCH (RTL vs C Model) ===");

        i_a11    = '0; i_a22    = '0;
        i_a12_re = '0; i_a12_im = '0;

        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;
        repeat (2) @(posedge clk);

        for (test_idx = 0; test_idx < NUM_TESTS; test_idx++) begin
            int c_det, c_sat, c_udf;

            @(posedge clk);
            i_a11    = tests[test_idx].a11[A_WIDTH-1:0];
            i_a22    = tests[test_idx].a22[A_WIDTH-1:0];
            i_a12_re = tests[test_idx].a12_re[A_WIDTH-1:0];
            i_a12_im = tests[test_idx].a12_im[A_WIDTH-1:0];

            c_det = a_det(
                tests[test_idx],
                A_WIDTH,
                DET_WIDTH,
                c_sat,
                c_udf
            );

            exp_det_a   = c_det[DET_WIDTH-1:0];
            exp_det_sat = c_sat[0];
            exp_sum_udf = c_udf[0];

            repeat (15) @(posedge clk);

            check_outputs(test_idx);
        end

        $display("\n==========================================");
        if (errors == 0) begin
            $display("TEST PASSED: All %0d tests matched C golden model!", NUM_TESTS);
        end else begin
            $error("TEST FAILED: %0d errors detected in %0d tests!", errors, NUM_TESTS);
        end
        $display("==========================================\n");
        $finish;
    end

    task automatic check_outputs(input int idx);
        int local_errors = 0;

        if (o_det_a !== exp_det_a) begin
            $error("  ERROR [Test %0d]: o_det_a = %0d (0x%0h), C expected = %0d (0x%0h)",
                   idx, o_det_a, o_det_a, exp_det_a, exp_det_a);
            local_errors++;
        end

        if (o_det_sat !== exp_det_sat) begin
            $error("  ERROR [Test %0d]: o_det_sat = %0b, C expected = %0b",
                   idx, o_det_sat, exp_det_sat);
            local_errors++;
        end

        if (o_sum_udf !== exp_sum_udf) begin
            $error("  ERROR [Test %0d]: o_sum_udf = %0b, C expected = %0b",
                   idx, o_sum_udf, exp_sum_udf);
            local_errors++;
        end

        if (local_errors == 0) begin
            $display("  Test %0d PASSED | o_det_a = %0d, sat = %0b, udf = %0b",
                     idx, o_det_a, o_det_sat, o_sum_udf);
        end else begin
            errors += local_errors;
        end
    endtask

endmodule