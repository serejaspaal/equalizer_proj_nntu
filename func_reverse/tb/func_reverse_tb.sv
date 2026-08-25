`timescale 1ns / 1ps

module func_reverse_tb;

    parameter IN_WIDTH   = 24;
    parameter FRAC_WIDTH = 16;
    parameter OUT_WIDTH  = 24;
    parameter N_LUT      = 11;
    parameter NINTRP     = FRAC_WIDTH - N_LUT - 1;
    parameter CLK_PERIOD = 10;
    parameter NTESTS     = 94;

    localparam ACTUAL_OUT_ON = OUT_WIDTH + NINTRP;

    logic                 clk;
    logic [IN_WIDTH-1:0]  x;

    logic                      o_inf_off;
    logic [OUT_WIDTH-1:0]      o_result_off;

    logic                          o_inf_on;
    logic [ACTUAL_OUT_ON-1:0]      o_result_on;

    func_reverse #(
        .IN_WIDTH   (IN_WIDTH),
        .FRAC_WIDTH (FRAC_WIDTH),
        .OUT_WIDTH  (OUT_WIDTH),
        .USE_INTRP  (0)
    ) dut_off (
        .i_clk    (clk),
        .i_x      (x),
        .o_inf    (o_inf_off),
        .o_result (o_result_off)
    );

    func_reverse #(
        .IN_WIDTH   (IN_WIDTH),
        .FRAC_WIDTH (FRAC_WIDTH),
        .OUT_WIDTH  (OUT_WIDTH),
        .USE_INTRP  (1)
    ) dut_on (
        .i_clk    (clk),
        .i_x      (x),
        .o_inf    (o_inf_on),
        .o_result (o_result_on)
    );

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    real x_fxp;
    real result_fxp_off;
    real result_fxp_on;

    always @* begin
        x_fxp          = $unsigned(x) * (2.0 ** (-FRAC_WIDTH));
        result_fxp_off = $unsigned(o_result_off) * (2.0 ** (-FRAC_WIDTH));
        result_fxp_on  = $unsigned(o_result_on)  * (2.0 ** (-FRAC_WIDTH - NINTRP));
    end

    logic [IN_WIDTH-1:0] test_val [0:NTESTS-1];
    real                  test_exp  [0:NTESTS-1];

    logic start;
    integer test_idx;

    always_ff @(posedge clk) begin
        if (!start) begin
            test_idx <= 0;
            x        <= 0;
        end else if (test_idx < NTESTS) begin
            x        <= test_val[test_idx];
            test_idx <= test_idx + 1;
        end
    end

    integer pass_off, fail_off, pass_on, fail_on, check_idx;
    integer intrp_wins, no_intrp_wins, ties;
    real    actual_off, actual_on, input_x;
    real    err_off, err_on;

    initial begin
        test_val[0]  = 24'h00000000; test_exp[0]  = 0.0;
        test_val[1]  = 24'h00008000; test_exp[1]  = 2.0;
        test_val[2]  = 24'h00010000; test_exp[2]  = 1.0;
        test_val[3]  = 24'h00001000; test_exp[3]  = 16.0;
        test_val[4]  = 24'h00002000; test_exp[4]  = 8.0;
        test_val[5]  = 24'h00004000; test_exp[5]  = 4.0;
        test_val[6]  = 24'h0000C000; test_exp[6]  = 1.33333333;
        test_val[7]  = 24'h00005555; test_exp[7]  = 3.00004578;
        test_val[8]  = 24'h00020000; test_exp[8]  = 0.5;
        test_val[9]  = 24'h00030000; test_exp[9]  = 0.33333333;
        test_val[10] = 24'h00040000; test_exp[10] = 0.25;
        test_val[11] = 24'h00050000; test_exp[11] = 0.2;
        test_val[12] = 24'h00080000; test_exp[12] = 0.125;
        test_val[13] = 24'h000A0000; test_exp[13] = 0.1;
        test_val[14] = 24'h00100000; test_exp[14] = 0.0625;
        test_val[15] = 24'h00640000; test_exp[15] = 0.01;
        test_val[16] = 24'h00C80000; test_exp[16] = 0.005;
        test_val[17] = 24'h00FFFFFF; test_exp[17] = 0.00390625;
        test_val[18] = 24'h00001AAB; test_exp[18] = 65536.0 / 6827;
        test_val[19] = 24'h0000ABCD; test_exp[19] = 65536.0 / 43981;
        test_val[20] = 24'h0000B54C; test_exp[20] = 65536.0 / 46412;
        test_val[21] = 24'h0000FAAB; test_exp[21] = 65536.0 / 64171;
        test_val[22] = 24'h00008FA0; test_exp[22] = 65536.0 / 36768;
        test_val[23] = 24'h00010101; test_exp[23] = 65536.0 / 65793;
        test_val[24] = 24'h0001FFFF; test_exp[24] = 65536.0 / 131071;
        test_val[25] = 24'h0002AAAA; test_exp[25] = 65536.0 / 174762;
        test_val[26] = 24'h00000134; test_exp[26] = 65536.0 / 308;
        test_val[27] = 24'h000001E5; test_exp[27] = 65536.0 / 485;
        test_val[28] = 24'h000002F1; test_exp[28] = 65536.0 / 753;

        for (int i = 0; i < 65; i++) begin
            test_val[29 + i] = 24'(1000 * (i + 1));
            test_exp[29 + i] = 65536.0 / (1000 * (i + 1));
        end

        pass_off      = 0;
        fail_off      = 0;
        pass_on       = 0;
        fail_on       = 0;
        intrp_wins    = 0;
        no_intrp_wins = 0;
        ties          = 0;
        start         = 0;

        @(posedge clk);
        @(negedge clk);
        start = 1;

        repeat (4) @(posedge clk);

        for (check_idx = 0; check_idx < NTESTS; check_idx = check_idx + 1) begin
            @(posedge clk);
            #1;
            input_x    = $unsigned(test_val[check_idx]) * (2.0 ** (-FRAC_WIDTH));
            actual_off = result_fxp_off;
            actual_on  = result_fxp_on;

            if (test_exp[check_idx] != 0.0) begin
                err_off = (actual_off > test_exp[check_idx]) ?
                           actual_off - test_exp[check_idx] :
                           test_exp[check_idx] - actual_off;
                err_on  = (actual_on > test_exp[check_idx]) ?
                           actual_on  - test_exp[check_idx] :
                           test_exp[check_idx] - actual_on;

                if (err_on < err_off)
                    intrp_wins = intrp_wins + 1;
                else if (err_off < err_on)
                    no_intrp_wins = no_intrp_wins + 1;
                else
                    ties = ties + 1;
            end

            if (test_exp[check_idx] == 0.0) begin
                if (o_inf_off) begin
                    $display("  x=%f : OFF=inf    expected=inf    PASS", input_x);
                    pass_off = pass_off + 1;
                end else begin
                    $display("  x=%f : OFF=%f  expected=inf    FAIL", input_x, actual_off);
                    fail_off = fail_off + 1;
                end
                if (o_inf_on) begin
                    $display("         ON =inf    expected=inf    PASS");
                    pass_on = pass_on + 1;
                end else begin
                    $display("         ON =%f  expected=inf    FAIL", actual_on);
                    fail_on = fail_on + 1;
                end
            end else begin
                if (actual_off > test_exp[check_idx] - 0.05 &&
                    actual_off < test_exp[check_idx] + 0.05) begin
                    $display("  x=%f : OFF=%f  expected=%f  PASS  err=%.6f", input_x, actual_off, test_exp[check_idx], err_off);
                    pass_off = pass_off + 1;
                end else begin
                    $display("  x=%f : OFF=%f  expected=%f  FAIL  err=%.6f", input_x, actual_off, test_exp[check_idx], err_off);
                    fail_off = fail_off + 1;
                end
                if (actual_on > test_exp[check_idx] - 0.05 &&
                    actual_on < test_exp[check_idx] + 0.05) begin
                    $display("         ON =%f  expected=%f  PASS  err_off=%.6f err_on=%.6f", actual_on, test_exp[check_idx], err_off, err_on);
                    pass_on = pass_on + 1;
                end else begin
                    $display("         ON =%f  expected=%f  FAIL  err_off=%.6f err_on=%.6f", actual_on, test_exp[check_idx], err_off, err_on);
                    fail_on = fail_on + 1;
                end
            end
        end

        $display("");
        $display("=========================================");
        $display("  OFF (no intrp):  PASSED %0d / %0d", pass_off, pass_off + fail_off);
        $display("  ON  (intrp):     PASSED %0d / %0d", pass_on,  pass_on  + fail_on);
        $display("-----------------------------------------");
        $display("  INTRP wins:      %0d / %0d", intrp_wins,    intrp_wins + no_intrp_wins + ties);
        $display("  NO_INTRP wins:   %0d / %0d", no_intrp_wins, intrp_wins + no_intrp_wins + ties);
        $display("  Ties:            %0d / %0d", ties,          intrp_wins + no_intrp_wins + ties);
        $display("=========================================");
        $finish;
    end

endmodule