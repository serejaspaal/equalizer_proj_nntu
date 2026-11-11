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
        input longint i_x
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

        result_fxp_off = $unsigned(o_result_off) * (2.0 ** (-FRAC_WIDTH));
        result_fxp_on  = $unsigned(o_result_on)  * (2.0 ** (-FRAC_WIDTH - INTRP_WIDTH));
        exp_fxp        = (x == 0) ? (0) : (1.0 / ($unsigned(x) * (2.0 ** (-FRAC_WIDTH))));

        err_off = (result_fxp_off > exp_fxp) ? (result_fxp_off - exp_fxp) : (exp_fxp - result_fxp_off);
        err_on  = (result_fxp_on  > exp_fxp) ? (result_fxp_on  - exp_fxp) : (exp_fxp - result_fxp_on);

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
        $display("S%0d CMP: x=%0d exp=%f off_raw=%0d off_fxp=%f on_raw=%0d on_fxp=%f", test_num, x, exp_fxp, o_result_off, result_fxp_off, o_result_on, result_fxp_on);

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
    longint val_test;
    initial begin
//         @(posedge clk);
//
        for (int i = 0; i < 10; i++) begin
            test_number += 1;
            val_test = i+1;
            test(test_number, val_test);
        end

        for (int i = 0; i < 10; i++) begin
            test_number += 1;
            val_test = (i+1)*10;
            test(test_number, val_test);
        end

        for (int i = 0; i < 10; i++) begin
            test_number += 1;
            val_test = (i+1)*100;
            test(test_number, val_test);
        end

        for (int i = 0; i < 65; i++) begin
            test_number += 1;
            val_test = (i+1)*1000;
            test(test_number, val_test);
        end

        for (int i = 0; i < 65; i++) begin
            test_number += 1;
            val_test = ((i+1)*1000)<<FRAC_WIDTH;
            test(test_number, val_test);
        end
        @(posedge clk);

        $display("");
        $display("=========================================");
        $display("  OFF wins: %0d", off_win);
        $display("  ON  wins: %0d", on_win);
        $display("  Ties:                   %0d", tie);
        $display("=========================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);


    end

endmodule
