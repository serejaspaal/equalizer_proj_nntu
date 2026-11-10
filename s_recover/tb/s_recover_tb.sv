`timescale 1ns / 1ps

module s_recover_tb;

    localparam int W_WIDTH = 8;
    localparam int S_WIDTH = 8;
    localparam int SR_WIDTH = W_WIDTH + S_WIDTH + 2;
    localparam int USE_DSP_VALUE = 1;
    
    localparam int EXP_STAGE = 5;

    localparam longint W_MIN = -128;
    localparam longint W_MAX = 127;

    localparam longint S_MIN = -128;
    localparam longint S_MAX = 127;

    localparam int NUM_TESTS = 9;
    
    typedef struct {
        longint w11_re;
        longint w11_im;
        longint w12_re;
        longint w12_im;
        longint w21_re;
        longint w21_im;
        longint w22_re;
        longint w22_im;
    } w_matrix_t;
    
    typedef struct {
        longint s11_re;
        longint s11_im;
        longint s21_re;
        longint s21_im;
    } s_vector_t;

    typedef struct {
        longint s11_re;
        longint s11_im;
        longint s21_re;
        longint s21_im;
        int sat_s11_re;
        int sat_s11_im;
        int sat_s21_re;
        int sat_s21_im;
    } s_rec_t;
    
    typedef struct {
        logic [SR_WIDTH-1:0] s11_re;
        logic [SR_WIDTH-1:0] s11_im;
        logic [SR_WIDTH-1:0] s21_re;
        logic [SR_WIDTH-1:0] s21_im;
        logic sat_s11_re;
        logic sat_s11_im;
        logic sat_s21_re;
        logic sat_s21_im;
    } exp_t;

    import "DPI-C" function void s_recover(
        input w_matrix_t w,
        input s_vector_t s,
        input int w_width,
        input int s_width,
        input int sr_width,
        output s_rec_t s_rec
    );

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

    int errors = 0;
    int tests = 0;
    int test_idx;
    int err_inc;
    int cmp_idx;
    string status;
    
    s_rec_t ref_rec;

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
    
    w_matrix_t test_w [NUM_TESTS];
    s_vector_t test_s [NUM_TESTS];
    exp_t exp_arr [NUM_TESTS];
    
    exp_t exp_pipe [0:EXP_STAGE];
    logic exp_valid_pipe [0:EXP_STAGE];
    int exp_idx_pipe [0:EXP_STAGE];
    
    task automatic show_inputs(input int idx);
        $display("  IN[%0d]: w11=(%0d,%0d) w12=(%0d,%0d) w21=(%0d,%0d) w22=(%0d,%0d) s11=(%0d,%0d) s21=(%0d,%0d)",
                 idx,
                 test_w[idx].w11_re, test_w[idx].w11_im,
                 test_w[idx].w12_re, test_w[idx].w12_im,
                 test_w[idx].w21_re, test_w[idx].w21_im,
                 test_w[idx].w22_re, test_w[idx].w22_im,
                 test_s[idx].s11_re, test_s[idx].s11_im,
                 test_s[idx].s21_re, test_s[idx].s21_im);
    endtask
    
    always_ff @(posedge clk) begin
        err_inc = 0;
        
        if (rst) begin
            test_idx <= 0;
            i_stb <= 1'b0;

            i_w11_re <= '0;
            i_w11_im <= '0;
            i_w12_re <= '0;
            i_w12_im <= '0;
            i_w21_re <= '0;
            i_w21_im <= '0;
            i_w22_re <= '0;
            i_w22_im <= '0;

            i_s11_re <= '0;
            i_s11_im <= '0;
            i_s21_re <= '0;
            i_s21_im <= '0;

            for (int k = 0; k <= EXP_STAGE; k++) begin
                exp_pipe[k].s11_re <= '0;
                exp_pipe[k].s11_im <= '0;
                exp_pipe[k].s21_re <= '0;
                exp_pipe[k].s21_im <= '0;
                exp_pipe[k].sat_s11_re <= 1'b0;
                exp_pipe[k].sat_s11_im <= 1'b0;
                exp_pipe[k].sat_s21_re <= 1'b0;
                exp_pipe[k].sat_s21_im <= 1'b0;

                exp_valid_pipe[k] <= 1'b0;
                exp_idx_pipe[k] <= 0;
            end

            errors <= 0;
            tests <= 0;
        end else begin
            if (exp_valid_pipe[EXP_STAGE]) begin
                tests <= tests + 1;

                cmp_idx = exp_idx_pipe[EXP_STAGE];

                if (o_stb !== 1'b1) begin
                    $error("ERROR VALID [test %0d]: expected o_stb=1, actual=%0b",
                           cmp_idx, o_stb);
                    show_inputs(cmp_idx);
                    err_inc++;
                end

                if (o_s11_re !== exp_pipe[EXP_STAGE].s11_re) begin
                    $error("ERROR S11 RE [test %0d]: EXPECTED(C)=%0d (0x%0h) ACTUAL(RTL)=%0d (0x%0h)",
                           cmp_idx,
                           $signed(exp_pipe[EXP_STAGE].s11_re),
                           exp_pipe[EXP_STAGE].s11_re,
                           $signed(o_s11_re),
                           o_s11_re);
                    show_inputs(cmp_idx);
                    err_inc++;
                end

                if (o_s11_im !== exp_pipe[EXP_STAGE].s11_im) begin
                    $error("ERROR S11 IM [test %0d]: EXPECTED(C)=%0d (0x%0h) ACTUAL(RTL)=%0d (0x%0h)",
                           cmp_idx,
                           $signed(exp_pipe[EXP_STAGE].s11_im),
                           exp_pipe[EXP_STAGE].s11_im,
                           $signed(o_s11_im),
                           o_s11_im);
                    show_inputs(cmp_idx);
                    err_inc++;
                end

                if (o_s21_re !== exp_pipe[EXP_STAGE].s21_re) begin
                    $error("ERROR S21 RE [test %0d]: EXPECTED(C)=%0d (0x%0h) ACTUAL(RTL)=%0d (0x%0h)",
                           cmp_idx,
                           $signed(exp_pipe[EXP_STAGE].s21_re),
                           exp_pipe[EXP_STAGE].s21_re,
                           $signed(o_s21_re),
                           o_s21_re);
                    show_inputs(cmp_idx);
                    err_inc++;
                end

                if (o_s21_im !== exp_pipe[EXP_STAGE].s21_im) begin
                    $error("ERROR S21 IM [test %0d]: EXPECTED(C)=%0d (0x%0h) ACTUAL(RTL)=%0d (0x%0h)",
                           cmp_idx,
                           $signed(exp_pipe[EXP_STAGE].s21_im),
                           exp_pipe[EXP_STAGE].s21_im,
                           $signed(o_s21_im),
                           o_s21_im);
                    show_inputs(cmp_idx);
                    err_inc++;
                end

                if (o_sat_s11_re !== exp_pipe[EXP_STAGE].sat_s11_re) begin
                    $error("ERROR SAT S11 RE [test %0d]: EXPECTED(C)=%0d ACTUAL(RTL)=%0d",
                           cmp_idx, exp_pipe[EXP_STAGE].sat_s11_re, o_sat_s11_re);
                    show_inputs(cmp_idx);
                    err_inc++;
                end

                if (o_sat_s11_im !== exp_pipe[EXP_STAGE].sat_s11_im) begin
                    $error("ERROR SAT S11 IM [test %0d]: EXPECTED(C)=%0d ACTUAL(RTL)=%0d",
                           cmp_idx, exp_pipe[EXP_STAGE].sat_s11_im, o_sat_s11_im);
                    show_inputs(cmp_idx);
                    err_inc++;
                end

                if (o_sat_s21_re !== exp_pipe[EXP_STAGE].sat_s21_re) begin
                    $error("ERROR SAT S21 RE [test %0d]: EXPECTED(C)=%0d ACTUAL(RTL)=%0d",
                           cmp_idx, exp_pipe[EXP_STAGE].sat_s21_re, o_sat_s21_re);
                    show_inputs(cmp_idx);
                    err_inc++;
                end

                if (o_sat_s21_im !== exp_pipe[EXP_STAGE].sat_s21_im) begin
                    $error("ERROR SAT S21 IM [test %0d]: EXPECTED(C)=%0d ACTUAL(RTL)=%0d",
                           cmp_idx, exp_pipe[EXP_STAGE].sat_s21_im, o_sat_s21_im);
                    show_inputs(cmp_idx);
                    err_inc++;
                end

                status = (err_inc == 0) ? "PASS" : "FAIL";

                $display("[%0d] RTL: S11=(%0d,%0d) S21=(%0d,%0d) sat=(%0d,%0d,%0d,%0d); C: S11=(%0d,%0d) S21=(%0d,%0d) sat=(%0d,%0d,%0d,%0d) | %s",
                         cmp_idx,
                         $signed(o_s11_re), $signed(o_s11_im),
                         $signed(o_s21_re), $signed(o_s21_im),
                         o_sat_s11_re, o_sat_s11_im, o_sat_s21_re, o_sat_s21_im,
                         $signed(exp_pipe[EXP_STAGE].s11_re),
                         $signed(exp_pipe[EXP_STAGE].s11_im),
                         $signed(exp_pipe[EXP_STAGE].s21_re),
                         $signed(exp_pipe[EXP_STAGE].s21_im),
                         exp_pipe[EXP_STAGE].sat_s11_re,
                         exp_pipe[EXP_STAGE].sat_s11_im,
                         exp_pipe[EXP_STAGE].sat_s21_re,
                         exp_pipe[EXP_STAGE].sat_s21_im,
                         status);
            end else if (o_stb === 1'b1) begin
                $error("ERROR VALID: unexpected o_stb=1 (no expected data)");
                err_inc++;
            end
            errors <= errors + err_inc;

            for (int k = EXP_STAGE; k > 0; k--) begin
                exp_pipe[k] <= exp_pipe[k-1];
                exp_valid_pipe[k] <= exp_valid_pipe[k-1];
                exp_idx_pipe[k] <= exp_idx_pipe[k-1];
            end

            if (test_idx < NUM_TESTS) begin
                i_stb <= 1'b1;

                i_w11_re <= test_w[test_idx].w11_re[W_WIDTH-1:0];
                i_w11_im <= test_w[test_idx].w11_im[W_WIDTH-1:0];
                i_w12_re <= test_w[test_idx].w12_re[W_WIDTH-1:0];
                i_w12_im <= test_w[test_idx].w12_im[W_WIDTH-1:0];
                i_w21_re <= test_w[test_idx].w21_re[W_WIDTH-1:0];
                i_w21_im <= test_w[test_idx].w21_im[W_WIDTH-1:0];
                i_w22_re <= test_w[test_idx].w22_re[W_WIDTH-1:0];
                i_w22_im <= test_w[test_idx].w22_im[W_WIDTH-1:0];

                i_s11_re <= test_s[test_idx].s11_re[S_WIDTH-1:0];
                i_s11_im <= test_s[test_idx].s11_im[S_WIDTH-1:0];
                i_s21_re <= test_s[test_idx].s21_re[S_WIDTH-1:0];
                i_s21_im <= test_s[test_idx].s21_im[S_WIDTH-1:0];

                exp_pipe[0] <= exp_arr[test_idx];

                exp_valid_pipe[0] <= 1'b1;
                exp_idx_pipe[0] <= test_idx;

                test_idx <= test_idx + 1;
            end else begin
                i_stb <= 1'b0;

                i_w11_re <= '0;
                i_w11_im <= '0;
                i_w12_re <= '0;
                i_w12_im <= '0;
                i_w21_re <= '0;
                i_w21_im <= '0;
                i_w22_re <= '0;
                i_w22_im <= '0;

                i_s11_re <= '0;
                i_s11_im <= '0;
                i_s21_re <= '0;
                i_s21_im <= '0;

                exp_pipe[0].s11_re <= '0;
                exp_pipe[0].s11_im <= '0;
                exp_pipe[0].s21_re <= '0;
                exp_pipe[0].s21_im <= '0;
                exp_pipe[0].sat_s11_re <= 1'b0;
                exp_pipe[0].sat_s11_im <= 1'b0;
                exp_pipe[0].sat_s21_re <= 1'b0;
                exp_pipe[0].sat_s21_im <= 1'b0;

                exp_valid_pipe[0] <= 1'b0;
                exp_idx_pipe[0] <= 0;
            end
        end
    end
    
    initial begin
        s_rec_t c_rec;
        
        clk = 1'b0;
        rst = 1'b1;
        
        $display("S_RECOVER TESTBENCH");
        $display("W_WIDTH=%0d  S_WIDTH=%0d  SR_WIDTH=%0d  NUM_TESTS=%0d  EXP_STAGE=%0d",
                 W_WIDTH, S_WIDTH, SR_WIDTH, NUM_TESTS, EXP_STAGE);

        test_w[0] = '{0, 0, 0, 0, 0, 0, 0, 0};
        test_s[0] = '{0, 0, 0, 0};

        test_w[1] = '{
            1, 0,
            0, 0,
            0, 0,
            0, 1
        };
        test_s[1] = '{5, 2, -3, 4};

        test_w[2] = '{
            1, 0,
            1, 0,
            1, 0,
            -1, 0
        };
        test_s[2] = '{2, 0, 4, 0};

        test_w[3] = '{
             1,  2,
            -1,  1,
             2, -1,
             1,  1
        };
        test_s[3] = '{3, 1, 2, -1};

        test_w[4] = '{
            -1, 1,
             0, 0,
             0, 0,
            -1, 1
        };
        test_s[4] = '{-2, 3, 1, -2};

        test_w[5] = '{
            100, 0,
              0, 0,
              0, 0,
           -100, 0
        };
        test_s[5] = '{2, 3, 1, 1};

        test_w[6] = '{0, 0, 0, 0, 0, 0, 0, 0};
        test_s[6] = '{7, 3, -4, 5};

        test_w[7] = '{
            W_MAX, W_MAX,
            W_MAX, W_MAX,
            W_MAX, W_MAX,
            W_MAX, W_MAX
        };
        test_s[7] = '{S_MAX, S_MAX, S_MAX, S_MAX};

        test_w[8] = '{
            W_MIN, W_MIN,
            W_MIN, W_MIN,
            W_MIN, W_MIN,
            W_MIN, W_MIN
        };
        test_s[8] = '{S_MIN, S_MIN, S_MIN, S_MIN};
        
        for (int i = 0; i < NUM_TESTS; i++) begin
            s_recover(
                test_w[i],
                test_s[i],
                W_WIDTH,
                S_WIDTH,
                SR_WIDTH,
                c_rec
            );

            exp_arr[i].s11_re = c_rec.s11_re[SR_WIDTH-1:0];
            exp_arr[i].s11_im = c_rec.s11_im[SR_WIDTH-1:0];
            exp_arr[i].s21_re = c_rec.s21_re[SR_WIDTH-1:0];
            exp_arr[i].s21_im = c_rec.s21_im[SR_WIDTH-1:0];
            exp_arr[i].sat_s11_re = c_rec.sat_s11_re[0];
            exp_arr[i].sat_s11_im = c_rec.sat_s11_im[0];
            exp_arr[i].sat_s21_re = c_rec.sat_s21_re[0];
            exp_arr[i].sat_s21_im = c_rec.sat_s21_im[0];
        end
        
        repeat (3) @(posedge clk);
        rst <= 1'b0;
        repeat (NUM_TESTS + EXP_STAGE + 6) @(posedge clk);

        if (errors == 0 && tests == NUM_TESTS) begin
            $display("");
            $display("S_RECOVER TEST PASSED");
            $display("Tests: %0d / %0d", tests, NUM_TESTS);
            $finish;
        end else begin
            $display("");
            $display("S_RECOVER TEST FAILED");
            $display("Tests: %0d / %0d", tests, NUM_TESTS);
            $display("Errors: %0d", errors);
            $fatal(1, "S_RECOVER: C model and RTL mismatch");
        end
    end
endmodule
