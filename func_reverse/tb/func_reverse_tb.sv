`timescale 1ns / 1ps

module func_reverse_tb;

    parameter IN_WIDTH   = 24;
    parameter FRAC_WIDTH = 16;
    parameter OUT_WIDTH  = 24;
    parameter CLK_PERIOD = 10;
    parameter NTESTS     = 18;

    logic                clk;
    logic [IN_WIDTH-1:0] x;
    logic                o_inf;
    logic [OUT_WIDTH-1:0] o_result;

    func_reverse #(
        .IN_WIDTH   (IN_WIDTH),
        .FRAC_WIDTH (FRAC_WIDTH),
        .OUT_WIDTH  (OUT_WIDTH)
    ) dut (
        .i_clk    (clk),
        .i_x      (x),
        .o_inf    (o_inf),
        .o_result (o_result)
    );

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    real x_fxp;
    real result_fxp;

    always @* begin
        x_fxp      = $unsigned(x)       * (2.0 ** (-FRAC_WIDTH));
        result_fxp = $unsigned(o_result) * (2.0 ** (-FRAC_WIDTH));
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

    integer pass_count, fail_count, check_idx;
    real    actual_real, input_x;

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
        test_val[17] = 24'hFFFFFF;   test_exp[17] = 0.00390625;

        pass_count = 0;
        fail_count = 0;
        start      = 0;

        @(posedge clk);
        @(negedge clk);
        start = 1;

        repeat (3) @(posedge clk);

        for (check_idx = 0; check_idx < NTESTS; check_idx = check_idx + 1) begin
            @(posedge clk);
            #1;
            input_x   = $unsigned(test_val[check_idx]) * (2.0 ** (-FRAC_WIDTH));
            actual_real = result_fxp;

            if (test_exp[check_idx] == 0.0) begin
                if (o_inf) begin
                    $display("  x=%f : result = inf   expected = inf   PASS",
                             input_x);
                    pass_count = pass_count + 1;
                end else begin
                    $display("  x=%f : result = %f  expected = inf   FAIL",
                             input_x, actual_real);
                    fail_count = fail_count + 1;
                end
            end else begin
                if (actual_real > test_exp[check_idx] - 0.05 &&
                    actual_real < test_exp[check_idx] + 0.05) begin
                    $display("  x=%f : result = %f  expected = %f  PASS",
                             input_x, actual_real, test_exp[check_idx]);
                    pass_count = pass_count + 1;
                end else begin
                    $display("  x=%f : result = %f  expected = %f  FAIL",
                             input_x, actual_real, test_exp[check_idx]);
                    fail_count = fail_count + 1;
                end
            end
        end

        $display("");
        $display("=========================================");
        $display("  PASSED: %0d / %0d", pass_count, pass_count + fail_count);
        $display("=========================================");
        $finish;
    end

endmodule
