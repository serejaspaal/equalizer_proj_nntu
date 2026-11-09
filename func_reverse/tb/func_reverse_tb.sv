`timescale 1ns / 1ps

module func_reverse_tb;
    parameter IN_WIDTH   = 32;
    parameter FRAC_WIDTH = 16;
    parameter INTRP_WIDTH = 7;

    parameter CLK_PERIOD = 10;


    parameter RES_OFF_W  = (IN_WIDTH + 0 * INTRP_WIDTH) + 1;
    parameter RES_ON_W   = (IN_WIDTH + 1 * INTRP_WIDTH) + 1;

    import "DPI-C" function void func_reverse(
        input int IN_WIDTH,
        input int FRAC_WIDTH,
        input longint i_x,
        input int USE_INTRP,
        input int INTRP_WIDTH,
        output longint o_result,
        output int o_inf
    );

    logic                 clk;
    logic [IN_WIDTH-1:0]  x;

    logic                    o_inf_off;
    logic [RES_OFF_W-1:0]   o_result_off;

    logic                    o_inf_on;
    logic [RES_ON_W-1:0]    o_result_on;

    int errors;
    int on_win = 0;
    int off_win = 0;
    int tie = 0;
    logic [RES_OFF_W-1:0] exp_o_result;
    logic [RES_ON_W-1:0] exp_o_result_intrp;
    logic exp_o_inf;
    logic exp_o_inf_intrp;

    longint ref_res_pipe [0:3];
    int     ref_inf_pipe [0:3];
    longint ref_res_pipe_intrp [0:3];
    int     ref_inf_pipe_intrp [0:3];

    always_ff @(posedge clk) begin
        ref_res_pipe[0] <= exp_o_result;
        ref_inf_pipe[0] <= exp_o_inf;
        ref_res_pipe_intrp[0] <= exp_o_result_intrp;
        ref_inf_pipe_intrp[0] <= exp_o_inf_intrp;
        for (int i = 1; i < 4; i++) begin
            ref_res_pipe[i] <= ref_res_pipe[i-1];
            ref_inf_pipe[i] <= ref_inf_pipe[i-1];
            ref_res_pipe_intrp[i] <= ref_res_pipe_intrp[i-1];
            ref_inf_pipe_intrp[i] <= ref_inf_pipe_intrp[i-1];
        end
    end

    func_reverse #(
        .IN_WIDTH    (IN_WIDTH),
        .FRAC_WIDTH  (FRAC_WIDTH),
        .USE_INTRP   (0),
        .INTRP_WIDTH (INTRP_WIDTH)
    ) dut_off (
        .i_clk    (clk),
        .i_x      (x),
        .o_inf    (o_inf_off),
        .o_result (o_result_off)
    );

    func_reverse #(
        .IN_WIDTH    (IN_WIDTH),
        .FRAC_WIDTH  (FRAC_WIDTH),
        .USE_INTRP   (1),
        .INTRP_WIDTH (INTRP_WIDTH)
    ) dut_on (
        .i_clk    (clk),
        .i_x      (x),
        .o_inf    (o_inf_on),
        .o_result (o_result_on)
    );

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    task automatic test(
        input int test_num,
        input longint i_x,
        input real exp
    );
        longint exp_res = 0;
        int exp_inf = 0;

        real result_fxp_off, result_fxp_on, exp_fxp;
        real err_off, err_on;
        @(posedge clk);

        x = i_x;

        func_reverse(
            IN_WIDTH,
            FRAC_WIDTH,
            x,
            0,
            INTRP_WIDTH,
            exp_res,
            exp_inf
        );
        exp_o_result = exp_res;
        exp_o_inf = exp_inf;

        func_reverse(
            IN_WIDTH,
            FRAC_WIDTH,
            x,
            1,
            INTRP_WIDTH,
            exp_res,
            exp_inf
        );
        exp_o_result_intrp = exp_res;
        exp_o_inf_intrp = exp_inf;


        repeat (4) @(posedge clk);
        #1;

        // Приводим всё к вещественному виду, так как разрядность выходов разная:
        // OFF:  IN_WIDTH + 1 бит,        масштаб 2^-FRAC_WIDTH
        // ON:   IN_WIDTH + INTRP_WIDTH+1 бит, масштаб 2^-(FRAC_WIDTH+INTRP_WIDTH)
        result_fxp_off = $unsigned(o_result_off) * (2.0 ** (-FRAC_WIDTH));
        result_fxp_on  = $unsigned(o_result_on)  * (2.0 ** (-FRAC_WIDTH - INTRP_WIDTH));
        exp_fxp        = 1.0 / ($unsigned(x) * (2.0 ** (-FRAC_WIDTH)));
        // Модуль разницы от эталона
        err_off = (result_fxp_off > exp_fxp) ? (result_fxp_off - exp_fxp) : (exp_fxp - result_fxp_off);
        err_on  = (result_fxp_on  > exp_fxp) ? (result_fxp_on  - exp_fxp) : (exp_fxp - result_fxp_on);

        //                 err_off = (actual_off > test_exp[check_idx]) ?
        //                            actual_off - test_exp[check_idx] :
        //                            test_exp[check_idx] - actual_off;
        //                 err_on  = (actual_on > test_exp[check_idx]) ?
        //                            actual_on  - test_exp[check_idx] :
        //                            test_exp[check_idx] - actual_on;
        //
        //                 if (err_on < err_off) begin
        //                     intrp_lose = 0;
        //                     intrp_wins = intrp_wins + 1;
        //                 end else if (err_off < err_on) begin
        //                     intrp_lose = 1;
        //                     no_intrp_wins = no_intrp_wins + 1;
        //                 end else begin
        //                     intrp_lose = 0;
        //                     ties = ties + 1;
        //                 end
        if (err_on < err_off) begin
            on_win = on_win + 1;
        end else if (err_off < err_on) begin
            off_win = off_win + 1;
        end else begin
            tie = tie + 1;
        end
        if (o_inf_on !== ref_inf_pipe_intrp[3]) begin
            $error("S%0d_ON FAIL: inf mismatch", test_num);
            errors++;
        end else if (!o_inf_on && o_result_on !== ref_res_pipe_intrp[3]) begin
            $error("S%0d_ON FAIL: got (%0d,%0d), expected (%0d,%0d)", test_num, o_result_on, o_inf_on, ref_res_pipe_intrp[3], ref_inf_pipe_intrp[3]);
            errors++;
        end else
            $display("S%0d_ON PASS: x=%0d result=%0d inf=%0d", test_num, x, ref_res_pipe_intrp[3], ref_inf_pipe_intrp[3]);
        if (o_inf_off !== ref_inf_pipe[3]) begin
            $error("S%0d FAIL: inf mismatch", test_num);
            errors++;
        end else if (!o_inf_off && o_result_off !== ref_res_pipe[3]) begin
            $error("S%0d FAIL: got (%0d,:on_win%0d), expected (%0d,%0d)", test_num, o_result_off, o_inf_off, ref_res_pipe[3], ref_inf_pipe[3]);
            errors++;
        end else $display("S%0d PASS: x=%0d result=%0d inf=%0d", test_num, x, ref_res_pipe[3], ref_inf_pipe[3]);

        // @(posedge clk);
//         #1;
//
//         if (o_result_off !== exp_o_result || o_inf_off !== exp_o_inf) begin
//             $error("S%0d FAIL: got (%0d,%0d), expected (%0d,%0d)", test_num, o_result_off, o_inf_off, exp_o_result, exp_o_inf);
//             errors++;
//         end else $display("S%0d PASS", test_num);

    endtask

//
//     real x_fxp;
//     real result_fxp_off;
//     real result_fxp_on;
//
//     always @* begin
//         x_fxp          = $unsigned(x) * (2.0 ** (-FRAC_WIDTH));
//         result_fxp_off = $unsigned(o_result_off) * (2.0 ** (-FRAC_WIDTH));
//         result_fxp_on  = $unsigned(o_result_on)  * (2.0 ** (-FRAC_WIDTH - INTRP_WIDTH));
//     end
//
//     logic [IN_WIDTH-1:0] test_val [0:NTESTS-1];
//     real                  test_exp  [0:NTESTS-1];
//
//     logic start;
//     integer test_idx;
//
//     always_ff @(posedge clk) begin
//         if (!start) begin
//             test_idx <= 0;
//             x        <= 0;
//         end else if (test_idx < NTESTS) begin
//             x        <= test_val[test_idx];
//             test_idx <= test_idx + 1;
//         end
//     end
//
//     integer pass_off, fail_off, pass_on, fail_on, check_idx;
//     integer intrp_lose, intrp_wins, no_intrp_wins, ties;
//     real    actual_off, actual_on, input_x;
//     real    err_off, err_on;

    int test_number = 0;
    longint exp_test;
    longint val_test;
    initial begin
//         @(posedge clk);
//         test(0,0);
//         test(1,1);
//         test(2,2);
//         test(3,4);
//         test(4,8);
//         test(5,16);
//         test(6,32);
//         test(7,64);
//         test(8,128);
//         test(9,256);
//         test(10,517);
//         test(11,1537);
//         test(12,2048);
//         test(13,4096);
//         test(14,8192);
//         test(15,16384);
//         test(16,32768);
//         test(17,65536);
//         test(18,131072);
//         test(19,2147483647);
//
        for (int i = 0; i < 10; i++) begin
            test_number += 1;
            val_test = i+1;
            exp_test = real'(1<<FRAC_WIDTH) / (i+1);
            test(test_number, val_test, exp_test);
        end

        for (int i = 0; i < 10; i++) begin
            test_number += 1;
            val_test = (i+1)*10;
            exp_test = real'(1<<FRAC_WIDTH) / ((i+1)*10);
            test(test_number, val_test, exp_test);
        end

        for (int i = 0; i < 10; i++) begin
            test_number += 1;
            val_test = (i+1)*100;
            exp_test = real'(1<<FRAC_WIDTH) / ((i+1)*100);
            test(test_number, val_test, exp_test);
        end

        for (int i = 0; i < 65; i++) begin
            test_number += 1;
            val_test = (i+1)*1000;
            exp_test = real'(1<<FRAC_WIDTH) / ((i+1)*1000);
            test(test_number, val_test, exp_test);
        end

        for (int i = 0; i < 65; i++) begin
            test_number += 1;
            val_test = ((i+1)*1000)<<FRAC_WIDTH;
            exp_test = 1.0 / ((i+1)*1000);
            test(test_number, val_test, exp_test);
        end
        @(posedge clk);

        $display("");
        $display("=========================================");
        $display("  OFF wins (ближе к exp): %0d", off_win);
        $display("  ON  wins (ближе к exp): %0d", on_win);
        $display("  Ties:                   %0d", tie);
        $display("=========================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);


//         for (int i = 0; i < 10; i++) begin
//             val_test = i+1;
//             exp_test = real'(1<<FRAC_WIDTH) / (i+1);
//             test(test_number, val_test, exp_test);
//         end
//
//         for (int i = 0; i < 10; i++) begin
//             val_test = (i+1)*10;
//             exp_test = real'(1<<FRAC_WIDTH) / ((i+1)*10);
//             test(test_number, val_test, exp_test);
//         end
//
//         for (int i = 0; i < 10; i++) begin
//             val_test = (i+1)*100;
//             exp_test = real'(1<<FRAC_WIDTH) / ((i+1)*100);
//             test(test_number, val_test, exp_test);
//         end
//
//         for (int i = 0; i < 65; i++) begin
//             val_test = (i+1)*1000;
//             exp_test = real'(1<<FRAC_WIDTH) / ((i+1)*1000);
//             test(test_number, val_test, exp_test);
//         end
//
//         for (int i = 0; i < 65; i++) begin
//             val_test = ((i+1)*1000)<<FRAC_WIDTH;
//             exp_test = 1.0 / ((i+1)*1000);
//             test(test_number, val_test, exp_test);
//         end

        // pass_off      = 0;
        // fail_off      = 0;
        // pass_on       = 0;
        // fail_on       = 0;
        // intrp_wins    = 0;
        // no_intrp_wins = 0;
        // ties          = 0;
        // start         = 0;
//
//         @(posedge clk);
//         @(negedge clk);
//         start = 1;
//
//         repeat (4) @(posedge clk);
//
//         for (check_idx = 0; check_idx < NTESTS; check_idx = check_idx + 1) begin
//             @(posedge clk);
//             #1;
//             input_x    = $unsigned(test_val[check_idx]) * (2.0 ** (-FRAC_WIDTH));
//             actual_off = result_fxp_off;
//             actual_on  = result_fxp_on;
//
//             if (test_exp[check_idx] != 0.0) begin
//                 err_off = (actual_off > test_exp[check_idx]) ?
//                            actual_off - test_exp[check_idx] :
//                            test_exp[check_idx] - actual_off;
//                 err_on  = (actual_on > test_exp[check_idx]) ?
//                            actual_on  - test_exp[check_idx] :
//                            test_exp[check_idx] - actual_on;
//
//                 if (err_on < err_off) begin
//                     intrp_lose = 0;
//                     intrp_wins = intrp_wins + 1;
//                 end else if (err_off < err_on) begin
//                     intrp_lose = 1;
//                     no_intrp_wins = no_intrp_wins + 1;
//                 end else begin
//                     intrp_lose = 0;
//                     ties = ties + 1;
//                 end
//             end
//
//             $display("test =%.4d \t x=%f \t expected=%f \t intrp_lose=%.1d", check_idx, input_x, test_exp[check_idx], intrp_lose);
//
//             if (test_exp[check_idx] == 0.0) begin
//                 if (o_inf_off) begin
//                     $display("  x=%f : OFF=inf    expected=inf    PASS", input_x);
//                     pass_off = pass_off + 1;
//                 end else begin
//                     $display("  x=%f : OFF=%f  expected=inf    FAIL", input_x, actual_off);
//                     fail_off = fail_off + 1;
//                 end
//                 if (o_inf_on) begin
//                     $display("         ON =inf    expected=inf    PASS");
//                     pass_on = pass_on + 1;
//                 end else begin
//                     $display("         ON =%f  expected=inf    FAIL", actual_on);
//                     fail_on = fail_on + 1;
//                 end
//             end else begin
//                 if (actual_off > test_exp[check_idx] - 0.05 &&
//                     actual_off < test_exp[check_idx] + 0.05) begin
//                     $display("OFF=%f PASS  err_off=%.10f", actual_off, err_off);
//                     pass_off = pass_off + 1;
//                 end else begin
//                     $display("OFF=%f FAIL  err_off=%.10f", actual_off, err_off);
//                     fail_off = fail_off + 1;
//                 end
//                 if (actual_on > test_exp[check_idx] - 0.05 &&
//                     actual_on < test_exp[check_idx] + 0.05) begin
//                     $display("ON =%f PASS  err_on =%.10f", actual_on, err_on);
//                     pass_on = pass_on + 1;
//                 end else begin
//                     $display("ON =%f FAIL  err_on =%.10f", actual_on, err_on);
//                     fail_on = fail_on + 1;
//                 end
//             end
//         end
//
//         $display("");
//         $display("=========================================");
//         $display("  OFF (no intrp):  PASSED %0d / %0d", pass_off, pass_off + fail_off);
//         $display("  ON  (intrp):     PASSED %0d / %0d", pass_on,  pass_on  + fail_on);
//         $display("-----------------------------------------");
//         $display("  INTRP wins:      %0d / %0d", intrp_wins,    intrp_wins + no_intrp_wins + ties);
//         $display("  NO_INTRP wins:   %0d / %0d", no_intrp_wins, intrp_wins + no_intrp_wins + ties);
//         $display("  Ties:            %0d / %0d", ties,          intrp_wins + no_intrp_wins + ties);
//         $display("=========================================");
        // $finish;
    end

endmodule
