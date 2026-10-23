`timescale 1ns / 1ps

module s_recover_tb;

    localparam int W_WIDTH = 8;
    localparam int S_WIDTH = 8;
    localparam int SR_WIDTH = W_WIDTH + S_WIDTH + 2;
    localparam int USE_DSP_VALUE = 1;

    logic clk;
    logic rst;
    logic i_stb;

    logic signed [W_WIDTH-1:0] i_w11_re;
    logic signed [W_WIDTH-1:0] i_w11_im;
    logic signed [W_WIDTH-1:0] i_w12_re;
    logic signed [W_WIDTH-1:0] i_w12_im;
    logic signed [W_WIDTH-1:0] i_w21_re;
    logic signed [W_WIDTH-1:0] i_w21_im;
    logic signed [W_WIDTH-1:0] i_w22_re;
    logic signed [W_WIDTH-1:0] i_w22_im;

    logic signed [S_WIDTH-1:0] i_s11_re;
    logic signed [S_WIDTH-1:0] i_s11_im;
    logic signed [S_WIDTH-1:0] i_s21_re;
    logic signed [S_WIDTH-1:0] i_s21_im;

    logic [SR_WIDTH-1:0] o_s11_re;
    logic [SR_WIDTH-1:0] o_s11_im;
    logic o_sat_s11_re;
    logic o_sat_s11_im;

    logic [SR_WIDTH-1:0] o_s21_re;
    logic [SR_WIDTH-1:0] o_s21_im;
    logic o_sat_s21_re;
    logic o_sat_s21_im;

    logic o_stb;

    integer tests;
    integer errors;

    s_recover #(
        .W_WIDTH(W_WIDTH),
        .S_WIDTH(S_WIDTH),
        .SR_WIDTH(SR_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .i_stb(i_stb),

        .i_w11_re(i_w11_re),
        .i_w11_im(i_w11_im),
        .i_w12_re(i_w12_re),
        .i_w12_im(i_w12_im),
        .i_w21_re(i_w21_re),
        .i_w21_im(i_w21_im),
        .i_w22_re(i_w22_re),
        .i_w22_im(i_w22_im),

        .i_s11_re(i_s11_re),
        .i_s11_im(i_s11_im),
        .i_s21_re(i_s21_re),
        .i_s21_im(i_s21_im),

        .o_s11_re(o_s11_re),
        .o_s11_im(o_s11_im),
        .o_sat_s11_re(o_sat_s11_re),
        .o_sat_s11_im(o_sat_s11_im),

        .o_s21_re(o_s21_re),
        .o_s21_im(o_s21_im),
        .o_sat_s21_re(o_sat_s21_re),
        .o_sat_s21_im(o_sat_s21_im),

        .o_stb(o_stb)
    );

    always #5 clk = ~clk;

    task automatic apply_inputs(
        input integer w11_re,
        input integer w11_im,
        input integer w12_re,
        input integer w12_im,
        input integer w21_re,
        input integer w21_im,
        input integer w22_re,
        input integer w22_im,
        input integer s11_re,
        input integer s11_im,
        input integer s21_re,
        input integer s21_im
    );
        begin
            @(negedge clk);

            i_w11_re = w11_re;
            i_w11_im = w11_im;
            i_w12_re = w12_re;
            i_w12_im = w12_im;
            i_w21_re = w21_re;
            i_w21_im = w21_im;
            i_w22_re = w22_re;
            i_w22_im = w22_im;

            i_s11_re = s11_re;
            i_s11_im = s11_im;
            i_s21_re = s21_re;
            i_s21_im = s21_im;

            i_stb = 1'b1;

            @(negedge clk);
            i_stb = 1'b0;
        end
    endtask

    task automatic check_result(
        input integer exp_s11_re,
        input integer exp_s11_im,
        input integer exp_s21_re,
        input integer exp_s21_im
    );
        integer cycles;
        logic found;
        begin
            found = 1'b0;

            for (cycles = 0; cycles < 20; cycles = cycles + 1) begin
                @(posedge clk);
                #1;

                if (o_stb === 1'b1) begin
                    found = 1'b1;
                    cycles = 20;
                end
            end

            tests = tests + 1;

            if (!found) begin
                errors = errors + 1;
                $display(
                    "FAIL TEST %0d: timeout waiting for o_stb",
                    tests
                );
            end
            else begin
                $display(
                    "TEST %0d: S11=(%0d,%0d), S21=(%0d,%0d)",
                    tests,
                    $signed(o_s11_re),
                    $signed(o_s11_im),
                    $signed(o_s21_re),
                    $signed(o_s21_im)
                );

                if (
                    $signed(o_s11_re) !== exp_s11_re ||
                    $signed(o_s11_im) !== exp_s11_im ||
                    $signed(o_s21_re) !== exp_s21_re ||
                    $signed(o_s21_im) !== exp_s21_im
                ) begin
                    errors = errors + 1;
                    $display(
                        "FAIL: expected S11=(%0d,%0d), S21=(%0d,%0d)",
                        exp_s11_re,
                        exp_s11_im,
                        exp_s21_re,
                        exp_s21_im
                    );
                end
                else begin
                    $display("PASS");
                end

                if (
                    o_sat_s11_re !== 1'b0 ||
                    o_sat_s11_im !== 1'b0 ||
                    o_sat_s21_re !== 1'b0 ||
                    o_sat_s21_im !== 1'b0
                ) begin
                    errors = errors + 1;
                    $display(
                        "FAIL TEST %0d: unexpected saturation flag",
                        tests
                    );
                end
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        i_stb = 1'b0;

        i_w11_re = '0;
        i_w11_im = '0;
        i_w12_re = '0;
        i_w12_im = '0;
        i_w21_re = '0;
        i_w21_im = '0;
        i_w22_re = '0;
        i_w22_im = '0;

        i_s11_re = '0;
        i_s11_im = '0;
        i_s21_re = '0;
        i_s21_im = '0;

        tests = 0;
        errors = 0;

        repeat (4) @(negedge clk);
        rst = 1'b0;

        // TEST 1: Complex multiplication and addition
        apply_inputs(
            1, 0,  0, 0,
            0, 0,  0, 1,
            5, 2, -3, 4
        );
        check_result(5, 2, -4, -3);

        // TEST 2: Real coefficients
        apply_inputs(
            1, 0,  1, 0,
            1, 0, -1, 0,
            2, 0,  4, 0
        );
        check_result(6, 0, -2, 0);

        // TEST 3: Complex inputs
        apply_inputs(
             1,  2, -1,  1,
             2, -1,  1,  1,
             3,  1,  2, -1
        );
        check_result(0, 10, 10, 0);

        // TEST 4: All inputs zero
        apply_inputs(
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
        );
        check_result(0, 0, 0, 0);

        // TEST 5: Negative complex inputs
        apply_inputs(
            -1,  1,  0,  0,
             0,  0, -1,  1,
            -2,  3,  1, -2
        );
        check_result(-1, -5, 1, 3);

        // TEST 6: Larger inputs
        apply_inputs(
            100, 0,    0, 0,
              0, 0, -100, 0,
              2, 3,    1, 1
        );
        check_result(200, 300, -100, -100);

        // TEST 7: Zero matrix with not zero inputs vector
        apply_inputs(
            0, 0, 0, 0,
            0, 0, 0, 0,
            7, 3, -4, 5
        );
        check_result(0, 0, 0, 0);

        repeat (5) @(posedge clk);

        $display("");
        $display("===============================");
        $display("S_RECOVER TEST FINISHED");
        $display("Tests: %0d", tests);
        $display("Errors: %0d", errors);
        $display("===============================");

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");

        $finish;
    end

endmodule
