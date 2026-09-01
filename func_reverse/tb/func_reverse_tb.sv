`timescale 1ns / 1ps

module func_reverse_tb;

    parameter N_LUT      = 11;

    parameter IN_WIDTH   = 32;
    parameter FRAC_WIDTH = 16;
    parameter INTRP_WIDTH = 10;

    parameter CLK_PERIOD = 10;
    parameter NTESTS     = 160;

    parameter RES_OFF_W  = (IN_WIDTH + 0 * INTRP_WIDTH) + 1;
    parameter RES_ON_W   = (IN_WIDTH + 1 * INTRP_WIDTH) + 1;

    logic                 clk;
    logic [IN_WIDTH-1:0]  x;

    logic                    o_inf_off;
    logic [RES_OFF_W-1:0]   o_result_off;

    logic                    o_inf_on;
    logic [RES_ON_W-1:0]    o_result_on;

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

    real x_fxp;
    real result_fxp_off;
    real result_fxp_on;

    always @* begin
        x_fxp          = $unsigned(x) * (2.0 ** (-FRAC_WIDTH));
        result_fxp_off = $unsigned(o_result_off) * (2.0 ** (-FRAC_WIDTH));
        result_fxp_on  = $unsigned(o_result_on)  * (2.0 ** (-FRAC_WIDTH - INTRP_WIDTH));
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
    integer intrp_lose, intrp_wins, no_intrp_wins, ties;
    real    actual_off, actual_on, input_x;
    real    err_off, err_on;

    initial begin
        for (int i = 0; i < 10; i++) begin
            test_val[i] = i+1;
            test_exp[i] = real'(1<<FRAC_WIDTH) / (i+1);
        end

        for (int i = 0; i < 10; i++) begin
            test_val[i+10] = (i+1)*10;
            test_exp[i+10] = real'(1<<FRAC_WIDTH) / ((i+1)*10);
        end

        for (int i = 0; i < 10; i++) begin
            test_val[i+20] = (i+1)*100;
            test_exp[i+20] = real'(1<<FRAC_WIDTH) / ((i+1)*100);
        end

        for (int i = 0; i < 65; i++) begin
            test_val[i+30] = (i+1)*1000;
            test_exp[i+30] = real'(1<<FRAC_WIDTH) / ((i+1)*1000);
        end

        for (int i = 0; i < 65; i++) begin
            test_val[i+30+65] = ((i+1)*1000)<<FRAC_WIDTH;
            test_exp[i+30+65] = 1.0 / ((i+1)*1000);
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

                if (err_on < err_off) begin
                    intrp_lose = 0;
                    intrp_wins = intrp_wins + 1;
                end else if (err_off < err_on) begin
                    intrp_lose = 1;
                    no_intrp_wins = no_intrp_wins + 1;
                end else begin
                    intrp_lose = 0;
                    ties = ties + 1;
                end
            end

            $display("test =%.4d \t x=%f \t expected=%f \t intrp_lose=%.1d", check_idx, input_x, test_exp[check_idx], intrp_lose);

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
                    $display("OFF=%f PASS  err_off=%.10f", actual_off, err_off);
                    pass_off = pass_off + 1;
                end else begin
                    $display("OFF=%f FAIL  err_off=%.10f", actual_off, err_off);
                    fail_off = fail_off + 1;
                end
                if (actual_on > test_exp[check_idx] - 0.05 &&
                    actual_on < test_exp[check_idx] + 0.05) begin
                    $display("ON =%f PASS  err_on =%.10f", actual_on, err_on);
                    pass_on = pass_on + 1;
                end else begin
                    $display("ON =%f FAIL  err_on =%.10f", actual_on, err_on);
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
        // $finish;
    end

endmodule