`timescale 1ns / 1ps

module a_det_tb;
    parameter int A_WIDTH       = 16;
    parameter int ROUNDED_WIDTH = 32;
    parameter int USE_DSP_VALUE = 1;

    logic clk = 0;
    logic rst = 0;

    logic [A_WIDTH-1:0] i_a11, i_a22;
    logic [A_WIDTH-1:0] i_a12_re, i_a12_im;

    logic [ROUNDED_WIDTH-1:0] o_det_a;

    logic o_sat_det;


    a_det #(
        .A_WIDTH       ( A_WIDTH ),
        .ROUNDED_WIDTH ( ROUNDED_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) dut (
        .*
    );

    always #5 clk = ~clk;

    typedef struct {
        logic [A_WIDTH-1:0] a11, a22, a12_re, a12_im;
        logic [ROUNDED_WIDTH-1:0] exp_det_a;
    } test_t;

    localparam NUM_TESTS = 4;

    test_t tests[NUM_TESTS];

    initial begin

        tests[0].a11     = 16'b1111_1111_1111_1111; tests[0].a22     = 16'b1111_1111_1111_1111;
        tests[0].a12_re  = 16'b1000_0000_0000_0000; tests[0].a12_im  = 16'b1000_0000_0000_0000;
        tests[0].exp_det_a = 2147352577;

        tests[1].a11     = 16'b1111_1111_1111_1111; tests[1].a22     = 16'b1111_1111_1111_1111;
        tests[1].a12_re  = 16'b0111_1111_1111_1111; tests[1].a12_im  = 16'b0111_1111_1111_1111;
        tests[1].exp_det_a = 2147483647;

        tests[2].a11     = 16'h01; tests[2].a22     = 16'h01;
        tests[2].a12_re  = 16'h01; tests[2].a12_im  = 16'h01;
        tests[2].exp_det_a = -1;

        tests[3].a11     = 16'h00; tests[3].a22     = 16'h00;
        tests[3].a12_re  = 16'h00; tests[3].a12_im  = 16'h00;
        tests[3].exp_det_a = 0;
    end

    int test_idx;
    bit test_failed = 0;
    int errors = 0;

    initial begin
        i_a11     = 0; i_a22     = 0;
        i_a12_re  = 0; i_a12_im  = 0;

        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;

        repeat (2) @(posedge clk);

        for (test_idx = 0; test_idx < NUM_TESTS; test_idx++) begin
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

        if (o_det_a !== expected.exp_det_a) begin
            $display("  ERROR: Test %0d, o_det_a = %d, expected %d",
                     test_idx, o_det_a, expected.exp_det_a);
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
