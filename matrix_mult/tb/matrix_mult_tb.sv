`timescale 1ns / 1ps

module matrix_mult_tb;
    parameter int W_WIDTH       = 16;
    parameter int S_WIDTH       = 16;
    parameter int F_WIDTH       = W_WIDTH + S_WIDTH + 1;
    parameter int FRAC_WIDTH    = 8;
    parameter int USE_DSP_VALUE = 1;

    logic clk = 0;
    logic rst = 0;

    logic signed [W_WIDTH-1:0] i_w11_re, i_w11_im;
    logic signed [W_WIDTH-1:0] i_w12_re, i_w12_im;
    logic signed [W_WIDTH-1:0] i_w21_re, i_w21_im;
    logic signed [W_WIDTH-1:0] i_w22_re, i_w22_im;

    logic signed [S_WIDTH-1:0] i_s11_re, i_s11_im;
    logic signed [S_WIDTH-1:0] i_s12_re, i_s12_im;
    logic signed [S_WIDTH-1:0] i_s21_re, i_s21_im;
    logic signed [S_WIDTH-1:0] i_s22_re, i_s22_im;

    logic signed [F_WIDTH-1:0] o_f11_re, o_f11_im;
    logic signed [F_WIDTH-1:0] o_f12_re, o_f12_im;
    logic signed [F_WIDTH-1:0] o_f21_re, o_f21_im;
    logic signed [F_WIDTH-1:0] o_f22_re, o_f22_im;

    logic o_sat11_re, o_sat11_im;
    logic o_sat12_re, o_sat12_im;
    logic o_sat21_re, o_sat21_im;
    logic o_sat22_re, o_sat22_im;

    logic o_udf11_re, o_udf11_im;
    logic o_udf12_re, o_udf12_im;
    logic o_udf21_re, o_udf21_im;
    logic o_udf22_re, o_udf22_im;


    real w11_re_fxp, w11_im_fxp;
    real w12_re_fxp, w12_im_fxp;
    real w21_re_fxp, w21_im_fxp;
    real w22_re_fxp, w22_im_fxp;
    real s11_re_fxp, s11_im_fxp;
    real s12_re_fxp, s12_im_fxp;
    real s21_re_fxp, s21_im_fxp;
    real s22_re_fxp, s22_im_fxp;

    real f11_re_fxp, f11_im_fxp;
    real f12_re_fxp, f12_im_fxp;
    real f21_re_fxp, f21_im_fxp;
    real f22_re_fxp, f22_im_fxp;


    /////////////////////////////////////////////////////

    matrix_mult #(
        .W_WIDTH       ( W_WIDTH ),
        .S_WIDTH       ( S_WIDTH ),
        .F_WIDTH       ( F_WIDTH ),
        .FRAC_WIDTH    ( FRAC_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) dut (
        .*
    );

    always #5 clk = ~clk;

    always @* begin
        w11_re_fxp = $signed(i_w11_re) * (2.0 ** (-FRAC_WIDTH));
        w11_im_fxp = $signed(i_w11_im) * (2.0 ** (-FRAC_WIDTH));
        w12_re_fxp = $signed(i_w12_re) * (2.0 ** (-FRAC_WIDTH));
        w12_im_fxp = $signed(i_w12_im) * (2.0 ** (-FRAC_WIDTH));
        w21_re_fxp = $signed(i_w21_re) * (2.0 ** (-FRAC_WIDTH));
        w21_im_fxp = $signed(i_w21_im) * (2.0 ** (-FRAC_WIDTH));
        w22_re_fxp = $signed(i_w22_re) * (2.0 ** (-FRAC_WIDTH));
        w22_im_fxp = $signed(i_w22_im) * (2.0 ** (-FRAC_WIDTH));

        s11_re_fxp = $signed(i_s11_re) * (2.0 ** (-FRAC_WIDTH));
        s11_im_fxp = $signed(i_s11_im) * (2.0 ** (-FRAC_WIDTH));
        s12_re_fxp = $signed(i_s12_re) * (2.0 ** (-FRAC_WIDTH));
        s12_im_fxp = $signed(i_s12_im) * (2.0 ** (-FRAC_WIDTH));
        s21_re_fxp = $signed(i_s21_re) * (2.0 ** (-FRAC_WIDTH));
        s21_im_fxp = $signed(i_s21_im) * (2.0 ** (-FRAC_WIDTH));
        s22_re_fxp = $signed(i_s22_re) * (2.0 ** (-FRAC_WIDTH));
        s22_im_fxp = $signed(i_s22_im) * (2.0 ** (-FRAC_WIDTH));

        f11_re_fxp = $signed(o_f11_re) * (2.0 ** (-2*FRAC_WIDTH+1));
        f11_im_fxp = $signed(o_f11_im) * (2.0 ** (-2*FRAC_WIDTH+1));
        f12_re_fxp = $signed(o_f12_re) * (2.0 ** (-2*FRAC_WIDTH+1));
        f12_im_fxp = $signed(o_f12_im) * (2.0 ** (-2*FRAC_WIDTH+1));
        f21_re_fxp = $signed(o_f21_re) * (2.0 ** (-2*FRAC_WIDTH+1));
        f21_im_fxp = $signed(o_f21_im) * (2.0 ** (-2*FRAC_WIDTH+1));
        f22_re_fxp = $signed(o_f22_re) * (2.0 ** (-2*FRAC_WIDTH+1));
        f22_im_fxp = $signed(o_f22_im) * (2.0 ** (-2*FRAC_WIDTH+1));
    end


    // localparam NUM_TESTS = 6;
    localparam NUM_TESTS = 6;

    typedef struct {
        logic signed [W_WIDTH-1:0] w11_re, w11_im, w12_re, w12_im, w21_re, w21_im, w22_re, w22_im;
        logic signed [S_WIDTH-1:0] s11_re, s11_im, s12_re, s12_im, s21_re, s21_im, s22_re, s22_im;
        real exp_f11_re, exp_f11_im;
        real exp_f12_re, exp_f12_im;
        real exp_f21_re, exp_f21_im;
        real exp_f22_re, exp_f22_im;
    } test_t;

    test_t tests[NUM_TESTS];
    int test_count = 0;
    int tests_passed = 0;
    int tests_failed = 0;
    int expected_queue[$];

    initial begin

        for (int i = 0; i < NUM_TESTS; i++) begin
            tests[i].w11_re  = 16'b0000_0001_0000_0000; tests[i].w11_im  = 16'b0000_0000_0000_0000;
            tests[i].w12_re  = 16'b0000_0000_0000_0000; tests[i].w12_im  = 16'b0000_0000_0000_0000;
            tests[i].w21_re  = 16'b0000_0000_0000_0000; tests[i].w21_im  = 16'b0000_0000_0000_0000;
            tests[i].w22_re  = 16'b0000_0001_0000_0000; tests[i].w22_im  = 16'b0000_0000_0000_0000;

            // tests[i].s11_re  = i * (2**(FRAC_WIDTH)); tests[i].s11_im  = ;
            // tests[i].s12_re  = ; tests[i].s12_im  = ;
            // tests[i].s21_re  = ; tests[i].s21_im  = ;
            // tests[i].s22_re  = 3*i * (2**(FRAC_WIDTH)); tests[i].s22_im  = ;
            tests[i].s11_re = i * (2**(FRAC_WIDTH));                    // i
            tests[i].s11_im = (i+1) * (2**(FRAC_WIDTH)) ;           // (i+1)/4 (мнимая)
            tests[i].s12_re = (2*i) * (2**(FRAC_WIDTH));               // 2i
            tests[i].s12_im = 16'b0000_0000_0000_0000;                 // 0
            tests[i].s21_re = 16'b0000_0000_0000_0000;                 // 0
            tests[i].s21_im = i * (2**(FRAC_WIDTH));                   // i (мнимая)
            tests[i].s22_re = 3*i * (2**(FRAC_WIDTH));                 // 3i
            tests[i].s22_im = (2*i+1) * (2**(FRAC_WIDTH)) ;        // (2i+1)/2 (мнимая)

            // test_queue.push_back(i);
            // expected_queue.push_back(i);
        end
// Формируем очередь отправки (можно отправлять все подряд)

        // Запускаем отправку
        // fork
        //     check_results();
        // join

    end

    int test_idx;
    bit test_failed = 0;
    int errors = 0;

    int cycle_cnt = 0;

    typedef struct{
        int test_idx;
        test_t test;
        real f11_re;
        real f11_im;
        real f12_re;
        real f12_im;
        real f21_re;
        real f21_im;
        real f22_re;
        real f22_im;
    } test_data_t;
    test_data_t test_storage[NUM_TESTS];

    // task check_results();
    //     int expected_idx;

    //     forever begin
    //         @(posedge clk);

    //             // Проверяем, что есть ожидаемые результаты
    //         if (expected_queue.size() == 0) begin
    //             $warning("Unexpected result received!");
    //             continue;
    //         end

    //         expected_idx = expected_queue.pop_front();

    //         // Проверяем результат
    //         compare_result(expected_idx);
    //     end
    // endtask

    // function automatic void compare_result(int idx);
    //     int local_errors = 0;
    //     if ( expected ) begin

    //         $display(" ERROR: Test %0d, det_inv = %f, det_a = %f, det_inv * det_a = %f, expected %f",
    //                 test.test_idx, test.det_inv, test.det_a, test.det_inv * test.det_a, 1.0);
    //         $display(" e11 = %f, e22 = %f",
    //                 test.e11_re_fxp, test.e22_re_fxp);
    //         local_errors++;
    //     end
    // endfunction

    initial begin
        i_w11_re  = 0; i_w11_im  = 0;
        i_w12_re  = 0; i_w12_im  = 0;
        i_w21_re  = 0; i_w21_im  = 0;
        i_w22_re  = 0; i_w22_im  = 0;

        i_s11_re  = 0; i_s11_im  = 0;
        i_s12_re  = 0; i_s12_im  = 0;
        i_s21_re  = 0; i_s21_im  = 0;
        i_s22_re  = 0; i_s22_im  = 0;

        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;

        repeat (2) @(posedge clk);
        fork
            begin
                for (test_idx = 0; test_idx < NUM_TESTS; test_idx++) begin
                    test_storage[test_idx].test_idx = test_idx;
                    i_w11_re  = tests[test_idx].w11_re;
                    i_w11_im  = tests[test_idx].w11_im;
                    i_w12_re  = tests[test_idx].w12_re;
                    i_w12_im  = tests[test_idx].w12_im;
                    i_w21_re  = tests[test_idx].w21_re;
                    i_w21_im  = tests[test_idx].w21_im;
                    i_w22_re  = tests[test_idx].w22_re;
                    i_w22_im  = tests[test_idx].w22_im;

                    i_s11_re  = tests[test_idx].s11_re;
                    i_s11_im  = tests[test_idx].s11_im;
                    i_s12_re  = tests[test_idx].s12_re;
                    i_s12_im  = tests[test_idx].s12_im;
                    i_s21_re  = tests[test_idx].s21_re;
                    i_s21_im  = tests[test_idx].s21_im;
                    i_s22_re  = tests[test_idx].s22_re;
                    i_s22_im  = tests[test_idx].s22_im;
                    test_storage[test_idx].test = tests[test_idx];


                    $display("Running Test %0d...", test_idx);
                    $display("s11_re = %0d == %0d == %0d", i_s11_re, s11_re_fxp, tests[test_idx].s11_re);
                    $display("s11_im = %0d == %0d == %0d", i_s11_im, s11_im_fxp, test_storage[test_idx].test.exp_f11_im);

                    @(posedge clk);
                end
            end

            begin
                for (int i = 0; i < NUM_TESTS+6; i++) begin
                    if (cycle_cnt - 1 >= 0) begin
                        test_storage[cycle_cnt-1].test.exp_f11_re = s11_re_fxp;
                        test_storage[cycle_cnt-1].test.exp_f11_im = s11_im_fxp;
                        test_storage[cycle_cnt-1].test.exp_f12_re = s12_re_fxp;
                        test_storage[cycle_cnt-1].test.exp_f12_im = s12_im_fxp;
                        test_storage[cycle_cnt-1].test.exp_f21_re = s21_re_fxp;
                        test_storage[cycle_cnt-1].test.exp_f21_im = s21_im_fxp;
                        test_storage[cycle_cnt-1].test.exp_f22_re = s22_re_fxp;
                        test_storage[cycle_cnt-1].test.exp_f22_im = s22_im_fxp;
                    end
                    if (cycle_cnt - 6 >= 0) begin
                        test_storage[cycle_cnt - 6].f11_im = f11_im_fxp;
                        test_storage[cycle_cnt - 6].f11_re = f11_re_fxp;
                        test_storage[cycle_cnt - 6].f12_im = f12_im_fxp;
                        test_storage[cycle_cnt - 6].f12_re = f12_re_fxp;
                        test_storage[cycle_cnt - 6].f21_im = f21_im_fxp;
                        test_storage[cycle_cnt - 6].f21_re = f21_re_fxp;
                        test_storage[cycle_cnt - 6].f22_im = f22_im_fxp;
                        test_storage[cycle_cnt - 6].f22_re = f22_re_fxp;
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

        if (test.test.exp_f11_re != test.f11_re || test.test.exp_f12_re != test.f12_re
            || test.test.exp_f21_re != test.f21_re || test.test.exp_f22_re != test.f22_re
            || test.test.exp_f11_im != test.f11_im || test.test.exp_f22_im != test.f22_im
            || test.test.exp_f12_im != test.f12_im || test.test.exp_f21_im != test.f21_im) begin
            $display(" ERROR: Test %0d, f11_re_fxp = %f, f12_re_fxp = %f, f21_re_fxp = %f, f22_re_fxp = %f, f11_im_fxp = %f, f22_im_fxp = %f, f12_im_fxp = %f, f21_im_fxp = %f, exp_f11_re = %f, exp_f12_re = %f, exp_f21_re = %f, exp_f22_re = %f, exp_f11_im = %f, exp_f22_im = %f, exp_f12_im = %f, exp_f21_im = %f",
                     test.test_idx, test.f11_re, test.f12_re, test.f21_re, test.f22_re, test.f11_im, test.f22_im, test.f12_im, test.f21_im, test.test.exp_f11_re, test.test.exp_f12_re, test.test.exp_f21_re, test.test.exp_f22_re, test.test.exp_f11_im, test.test.exp_f22_im, test.test.exp_f12_im, test.test.exp_f21_im);
            local_errors++;
        end

        if (local_errors == 0) begin
            $display("     PASSED Test %0d",
                    test.test_idx);
        end else begin
            errors += local_errors;
            test_failed = 1;
        end
    endtask


endmodule
