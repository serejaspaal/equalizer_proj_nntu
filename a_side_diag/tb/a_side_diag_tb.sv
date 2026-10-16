`timescale 1ns / 1ps

module a_side_diag_tb;

    localparam int H_WIDTH       = 8;
    localparam int A_WIDTH       = 2 * H_WIDTH + 2;
    localparam int USE_DSP_VALUE = 1;

    localparam int CMULT_WIDTH = 2 * H_WIDTH + 1;
    localparam int SUM_WIDTH   = CMULT_WIDTH + 1;
    localparam int DROP        = SUM_WIDTH - A_WIDTH;

    localparam int MAX_VALUE = (1 <<< (A_WIDTH - 1)) - 1;
    localparam int MIN_VALUE = -(1 <<< (A_WIDTH - 1));

    logic clk;
    logic rst;
    logic valid_in;

    logic signed [H_WIDTH-1:0] h11_re;
    logic signed [H_WIDTH-1:0] h11_im;

    logic signed [H_WIDTH-1:0] h12_re;
    logic signed [H_WIDTH-1:0] h12_im;

    logic signed [H_WIDTH-1:0] h21_re;
    logic signed [H_WIDTH-1:0] h21_im;

    logic signed [H_WIDTH-1:0] h22_re;
    logic signed [H_WIDTH-1:0] h22_im;

    logic [A_WIDTH-1:0] a12_re;
    logic [A_WIDTH-1:0] a12_im;

    logic sat_a12_re;
    logic sat_a12_im;

    logic valid_out;

    integer errors;
    integer tests;

    a_side_diag #(
        .H_WIDTH(H_WIDTH),
        .A_WIDTH(A_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),

        .i_h11_re(h11_re),
        .i_h11_im(h11_im),

        .i_h12_re(h12_re),
        .i_h12_im(h12_im),

        .i_h21_re(h21_re),
        .i_h21_im(h21_im),

        .i_h22_re(h22_re),
        .i_h22_im(h22_im),

        .o_a12_re(a12_re),
        .o_a12_im(a12_im),

        .o_sat_a12_re(sat_a12_re),
        .o_sat_a12_im(sat_a12_im),

        .valid_out(valid_out)
    );

    always #5 clk = ~clk;

    task automatic reference_round(
        input integer value,
        output integer result,
        output logic saturation
    );

        logic signed [SUM_WIDTH-1:0] raw_value;
        integer truncated_value;
        integer rounded_value;

        begin
            raw_value = value;

            if (DROP == 0) begin
                rounded_value = $signed(raw_value);
            end else begin
                truncated_value =
                    $signed(raw_value[SUM_WIDTH-1:DROP]);

                rounded_value =
                    truncated_value + raw_value[DROP-1];
            end

            if (rounded_value > MAX_VALUE) begin
                result = MAX_VALUE & ((1 <<< A_WIDTH) - 1);
                saturation = 1'b1;
            end else if (rounded_value < MIN_VALUE) begin
                result = MIN_VALUE & ((1 <<< A_WIDTH) - 1);
                saturation = 1'b1;
            end else begin
                result = rounded_value & ((1 <<< A_WIDTH) - 1);
                saturation = 1'b0;
            end
        end

    endtask

    task automatic run_test(
        input integer test_h11_re,
        input integer test_h11_im,

        input integer test_h12_re,
        input integer test_h12_im,

        input integer test_h21_re,
        input integer test_h21_im,

        input integer test_h22_re,
        input integer test_h22_im
    );

        integer expected_re;
        integer expected_im;

        logic expected_sat_re;
        logic expected_sat_im;

        integer product_re_1;
        integer product_im_1;

        integer product_re_2;
        integer product_im_2;

        integer total_re;
        integer total_im;

        begin
            product_re_1 =
                test_h11_re * test_h21_re +
                test_h11_im * test_h21_im;

            product_im_1 =
                test_h11_im * test_h21_re -
                test_h11_re * test_h21_im;

            product_re_2 =
                test_h12_re * test_h22_re +
                test_h12_im * test_h22_im;

            product_im_2 =
                test_h12_im * test_h22_re -
                test_h12_re * test_h22_im;

            total_re = product_re_1 + product_re_2;
            total_im = product_im_1 + product_im_2;

            reference_round(
                total_re,
                expected_re,
                expected_sat_re
            );

            reference_round(
                total_im,
                expected_im,
                expected_sat_im
            );

            @(negedge clk);

            h11_re = test_h11_re;
            h11_im = test_h11_im;

            h12_re = test_h12_re;
            h12_im = test_h12_im;

            h21_re = test_h21_re;
            h21_im = test_h21_im;

            h22_re = test_h22_re;
            h22_im = test_h22_im;

            valid_in = 1'b1;

            @(negedge clk);

            valid_in = 1'b0;

            h11_re = '0;
            h11_im = '0;

            h12_re = '0;
            h12_im = '0;

            h21_re = '0;
            h21_im = '0;

            h22_re = '0;
            h22_im = '0;

            @(posedge valid_out);

            #1;

            tests = tests + 1;

            if (a12_re !== expected_re[A_WIDTH-1:0]) begin
                $display(
                    "ERROR RE: H11=(%0d,%0d) H12=(%0d,%0d) H21=(%0d,%0d) H22=(%0d,%0d) EXPECTED=%0d ACTUAL=%0d",
                    test_h11_re,
                    test_h11_im,
                    test_h12_re,
                    test_h12_im,
                    test_h21_re,
                    test_h21_im,
                    test_h22_re,
                    test_h22_im,
                    expected_re,
                    a12_re
                );

                errors = errors + 1;
            end

            if (a12_im !== expected_im[A_WIDTH-1:0]) begin
                $display(
                    "ERROR IM: H11=(%0d,%0d) H12=(%0d,%0d) H21=(%0d,%0d) H22=(%0d,%0d) EXPECTED=%0d ACTUAL=%0d",
                    test_h11_re,
                    test_h11_im,
                    test_h12_re,
                    test_h12_im,
                    test_h21_re,
                    test_h21_im,
                    test_h22_re,
                    test_h22_im,
                    expected_im,
                    a12_im
                );

                errors = errors + 1;
            end

            if (sat_a12_re !== expected_sat_re) begin
                $display(
                    "ERROR SAT RE: EXPECTED=%0d ACTUAL=%0d",
                    expected_sat_re,
                    sat_a12_re
                );

                errors = errors + 1;
            end

            if (sat_a12_im !== expected_sat_im) begin
                $display(
                    "ERROR SAT IM: EXPECTED=%0d ACTUAL=%0d",
                    expected_sat_im,
                    sat_a12_im
                );

                errors = errors + 1;
            end

            if (
                a12_re === expected_re[A_WIDTH-1:0] &&
                a12_im === expected_im[A_WIDTH-1:0] &&
                sat_a12_re === expected_sat_re &&
                sat_a12_im === expected_sat_im
            ) begin
                $display(
                    "PASS: H11=(%0d,%0d) H12=(%0d,%0d) H21=(%0d,%0d) H22=(%0d,%0d) -> A12=(%0d,%0d)",
                    test_h11_re,
                    test_h11_im,
                    test_h12_re,
                    test_h12_im,
                    test_h21_re,
                    test_h21_im,
                    test_h22_re,
                    test_h22_im,
                    expected_re,
                    expected_im
                );
            end

        end

    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        valid_in = 1'b0;

        h11_re = '0;
        h11_im = '0;

        h12_re = '0;
        h12_im = '0;

        h21_re = '0;
        h21_im = '0;

        h22_re = '0;
        h22_im = '0;

        errors = 0;
        tests = 0;

        repeat (3) @(posedge clk);

        rst = 1'b0;

        run_test(
             0,  0,
             0,  0,
             0,  0,
             0,  0
        );

        run_test(
             1,  0,
             2,  0,
             3,  0,
             4,  0
        );

        run_test(
             1,  2,
             3,  4,
             5,  6,
             7,  8
        );

        run_test(
            -1,  2,
             3, -4,
            -5,  6,
             7, -8
        );

        run_test(
            -10, -20,
             30,  40,
            -50,  60,
             70, -80
        );

        run_test(
            127, 127,
            127, 127,
            127, 127,
            127, 127
        );

        run_test(
           -128, -128,
           -128, -128,
           -128, -128,
           -128, -128
        );

        run_test(
            127, -128,
           -128, 127,
            100, -100,
           -100, 100
        );

        run_test(
             5,  -7,
            -9,  11,
            13, -15,
            17, -19
        );

        run_test(
            -32,  16,
             24, -12,
            -18,  27,
             31, -14
        );

        repeat (10) @(posedge clk);

        if (errors == 0) begin
            $display("");
            $display("===============================");
            $display("A_SIDE_DIAG TEST PASSED");
            $display("Tests: %0d", tests);
            $display("===============================");
            $display("");
            $finish;
        end else begin
            $display("");
            $display("===============================");
            $display("A_SIDE_DIAG TEST FAILED");
            $display("Tests: %0d", tests);
            $display("Errors: %0d", errors);
            $display("===============================");
            $display("");
            $fatal;
        end
    end

endmodule