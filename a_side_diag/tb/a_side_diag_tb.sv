`timescale 1ns / 1ps

module a_side_diag_tb;

    localparam int H_WIDTH = 16;
    localparam int A_WIDTH = 2 * H_WIDTH + 2;
    localparam int USE_DSP_VALUE = 1;

    localparam int EXP_STAGE = 5;

    localparam longint H_MIN = -32768;
    localparam longint H_MAX = 32767;

    localparam int NUM_TESTS = 8;

    typedef struct {
        longint h11_re;
        longint h11_im;
        longint h12_re;
        longint h12_im;
        longint h21_re;
        longint h21_im;
        longint h22_re;
        longint h22_im;
    } a_matrix_t;

    typedef struct {
        logic [A_WIDTH-1:0] re;
        logic [A_WIDTH-1:0] im;
        logic sat_re;
        logic sat_im;
    } exp_t;

    import "DPI-C" function void a_side_diag(
        input a_matrix_t mat,
        input int h_width,
        input int a_width,
        output longint o_a12_re,
        output longint o_a12_im,
        output int o_sat_a12_re,
        output int o_sat_a12_im
    );

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

    int errors = 0;
    int tests = 0;
    int test_idx;
    int err_inc;
    int cmp_idx;
    string status;

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

    a_matrix_t test_vectors [NUM_TESTS];

    logic [A_WIDTH-1:0] exp_re_arr [NUM_TESTS];
    logic [A_WIDTH-1:0] exp_im_arr [NUM_TESTS];
    logic exp_sat_re_arr [NUM_TESTS];
    logic exp_sat_im_arr [NUM_TESTS];

    exp_t exp_pipe [0:EXP_STAGE];
    logic exp_valid_pipe [0:EXP_STAGE];
    int exp_idx_pipe [0:EXP_STAGE];

    task automatic show_matrix(input int idx);
        $display("  H[%0d]: h11=(%0d,%0d) h12=(%0d,%0d) h21=(%0d,%0d) h22=(%0d,%0d)",
                 idx,
                 test_vectors[idx].h11_re, test_vectors[idx].h11_im,
                 test_vectors[idx].h12_re, test_vectors[idx].h12_im,
                 test_vectors[idx].h21_re, test_vectors[idx].h21_im,
                 test_vectors[idx].h22_re, test_vectors[idx].h22_im);
    endtask

    always_ff @(posedge clk) begin
        err_inc = 0;

        if (rst) begin
            test_idx <= 0;
            valid_in <= 1'b0;

            h11_re <= '0;
            h11_im <= '0;
            h12_re <= '0;
            h12_im <= '0;
            h21_re <= '0;
            h21_im <= '0;
            h22_re <= '0;
            h22_im <= '0;

            for (int k = 0; k <= EXP_STAGE; k++) begin
                exp_pipe[k].re <= '0;
                exp_pipe[k].im <= '0;
                exp_pipe[k].sat_re <= 1'b0;
                exp_pipe[k].sat_im <= 1'b0;

                exp_valid_pipe[k] <= 1'b0;
                exp_idx_pipe[k] <= 0;
            end

            errors <= 0;
            tests <= 0;
        end else begin
            if (exp_valid_pipe[EXP_STAGE]) begin
                tests <= tests + 1;

                cmp_idx = exp_idx_pipe[EXP_STAGE];

                if (valid_out !== 1'b1) begin
                    $error("ERROR VALID [test %0d]: expected valid_out=1, actual=%0b",
                           cmp_idx, valid_out);
                    show_matrix(cmp_idx);
                    err_inc++;
                end

                if (a12_re !== exp_pipe[EXP_STAGE].re) begin
                    $error("ERROR RE [test %0d]: EXPECTED(C)=%0d (0x%0h) ACTUAL(RTL)=%0d (0x%0h)",
                           cmp_idx,
                           $signed(exp_pipe[EXP_STAGE].re),
                           exp_pipe[EXP_STAGE].re,
                           $signed(a12_re),
                           a12_re);
                    show_matrix(cmp_idx);
                    err_inc++;
                end

                if (a12_im !== exp_pipe[EXP_STAGE].im) begin
                    $error("ERROR IM [test %0d]: EXPECTED(C)=%0d (0x%0h) ACTUAL(RTL)=%0d (0x%0h)",
                           cmp_idx,
                           $signed(exp_pipe[EXP_STAGE].im),
                           exp_pipe[EXP_STAGE].im,
                           $signed(a12_im),
                           a12_im);
                    show_matrix(cmp_idx);
                    err_inc++;
                end

                if (sat_a12_re !== exp_pipe[EXP_STAGE].sat_re) begin
                    $error("ERROR SAT RE [test %0d]: EXPECTED(C)=%0d ACTUAL(RTL)=%0d",
                           cmp_idx,
                           exp_pipe[EXP_STAGE].sat_re,
                           sat_a12_re);
                    show_matrix(cmp_idx);
                    err_inc++;
                end

                if (sat_a12_im !== exp_pipe[EXP_STAGE].sat_im) begin
                    $error("ERROR SAT IM [test %0d]: EXPECTED(C)=%0d ACTUAL(RTL)=%0d",
                           cmp_idx,
                           exp_pipe[EXP_STAGE].sat_im,
                           sat_a12_im);
                    show_matrix(cmp_idx);
                    err_inc++;
                end

                status = (err_inc == 0) ? "PASS" : "FAIL";

                $display("[%0d] RTL: A12 = (%0d,%0d), sat = (%0d,%0d); C: A12 = (%0d,%0d), sat = (%0d,%0d) | %s",
                         cmp_idx,
                         $signed(a12_re), $signed(a12_im),
                         sat_a12_re, sat_a12_im,
                         $signed(exp_pipe[EXP_STAGE].re),
                         $signed(exp_pipe[EXP_STAGE].im),
                         exp_pipe[EXP_STAGE].sat_re,
                         exp_pipe[EXP_STAGE].sat_im,
                         status);
            end else if (valid_out === 1'b1) begin
                $error("ERROR VALID: unexpected valid_out=1 (no expected data)");
                err_inc++;
            end

            errors <= errors + err_inc;

            for (int k = EXP_STAGE; k > 0; k--) begin
                exp_pipe[k] <= exp_pipe[k-1];
                exp_valid_pipe[k] <= exp_valid_pipe[k-1];
                exp_idx_pipe[k] <= exp_idx_pipe[k-1];
            end

            if (test_idx < NUM_TESTS) begin
                valid_in <= 1'b1;

                h11_re <= test_vectors[test_idx].h11_re[H_WIDTH-1:0];
                h11_im <= test_vectors[test_idx].h11_im[H_WIDTH-1:0];
                h12_re <= test_vectors[test_idx].h12_re[H_WIDTH-1:0];
                h12_im <= test_vectors[test_idx].h12_im[H_WIDTH-1:0];
                h21_re <= test_vectors[test_idx].h21_re[H_WIDTH-1:0];
                h21_im <= test_vectors[test_idx].h21_im[H_WIDTH-1:0];
                h22_re <= test_vectors[test_idx].h22_re[H_WIDTH-1:0];
                h22_im <= test_vectors[test_idx].h22_im[H_WIDTH-1:0];

                exp_pipe[0].re <= exp_re_arr[test_idx];
                exp_pipe[0].im <= exp_im_arr[test_idx];
                exp_pipe[0].sat_re <= exp_sat_re_arr[test_idx];
                exp_pipe[0].sat_im <= exp_sat_im_arr[test_idx];

                exp_valid_pipe[0] <= 1'b1;
                exp_idx_pipe[0] <= test_idx;

                test_idx <= test_idx + 1;
            end else begin
                valid_in <= 1'b0;

                h11_re <= '0;
                h11_im <= '0;
                h12_re <= '0;
                h12_im <= '0;
                h21_re <= '0;
                h21_im <= '0;
                h22_re <= '0;
                h22_im <= '0;

                exp_pipe[0].re <= '0;
                exp_pipe[0].im <= '0;
                exp_pipe[0].sat_re <= 1'b0;
                exp_pipe[0].sat_im <= 1'b0;

                exp_valid_pipe[0] <= 1'b0;
                exp_idx_pipe[0] <= 0;
            end
        end
    end

    initial begin
        longint c_re;
        longint c_im;
        int c_sat_re;
        int c_sat_im;

        clk = 1'b0;
        rst = 1'b1;

        $display("A_SIDE_DIAG TESTBENCH");
        $display("H_WIDTH=%0d  A_WIDTH=%0d  NUM_TESTS=%0d  EXP_STAGE=%0d",
                 H_WIDTH, A_WIDTH, NUM_TESTS, EXP_STAGE);

        test_vectors[0] = '{0, 0, 0, 0, 0, 0, 0, 0};

        test_vectors[1] = '{
            H_MAX, H_MAX,
            H_MAX, H_MAX,
            H_MAX, H_MAX,
            H_MAX, H_MAX
        };

        test_vectors[2] = '{
            H_MIN, H_MIN,
            H_MIN, H_MIN,
            H_MIN, H_MIN,
            H_MIN, H_MIN
        };

        test_vectors[3] = '{
            H_MAX, H_MIN,
            H_MAX, H_MAX,
            H_MAX, H_MAX,
            H_MIN, H_MIN
        };

        test_vectors[4] = '{
            2000, 1000,
            -3000, 500,
            700, -4000,
            1500, -250
        };

        test_vectors[5] = '{
            1, 2,
            3, -4,
            5, 6,
            -7, 8
        };

        test_vectors[6] = '{
            256, 0,
            0, 256,
            256, 0,
            0, -256
        };


        test_vectors[7] = '{
            0, 256,
            256, 0,
            0, -256,
            0, 256
        };

        for (int i = 0; i < NUM_TESTS; i++) begin
            a_side_diag(
                test_vectors[i],
                H_WIDTH,
                A_WIDTH,
                c_re,
                c_im,
                c_sat_re,
                c_sat_im
            );

            exp_re_arr[i] = c_re[A_WIDTH-1:0];
            exp_im_arr[i] = c_im[A_WIDTH-1:0];
            exp_sat_re_arr[i] = c_sat_re[0];
            exp_sat_im_arr[i] = c_sat_im[0];
        end

        repeat (3) @(posedge clk);
        rst <= 1'b0;
        repeat (NUM_TESTS + EXP_STAGE + 6) @(posedge clk);

        if (errors == 0 && tests == NUM_TESTS) begin
            $display("");
            $display("A_SIDE_DIAG TEST PASSED");
            $display("Tests: %0d / %0d", tests, NUM_TESTS);
            $finish;
        end else begin
            $display("");
            $display("A_SIDE_DIAG TEST FAILED");
            $display("Tests: %0d / %0d", tests, NUM_TESTS);
            $display("Errors: %0d", errors);
            $fatal(1, "A_SIDE_DIAG: C model and RTL mismatch");
        end
    end

endmodule