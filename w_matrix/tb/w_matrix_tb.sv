`timescale 1ns / 1ps

module w_matrix_tb;
    parameter int A_WIDTH       = 16;
    parameter int H_WIDTH       = 16;
    parameter int M_WIDTH       = A_WIDTH + H_WIDTH + 2;
    parameter int DET_WIDTH     = 2*A_WIDTH;
    parameter int FRAC_WIDTH    = 8;
    parameter int W_WIDTH       = DET_WIDTH + M_WIDTH;
    parameter int USE_DSP_VALUE = 1;

    logic clk = 0;
    logic rst = 0;

    logic signed [H_WIDTH-1:0] i_h11_re, i_h11_im;
    logic signed [H_WIDTH-1:0] i_h12_re, i_h12_im;
    logic signed [H_WIDTH-1:0] i_h21_re, i_h21_im;
    logic signed [H_WIDTH-1:0] i_h22_re, i_h22_im;
    //real i_a11, i_a22;
    logic [A_WIDTH-1:0] i_a11, i_a22;
    //real i_a12_re, i_a12_im;
    logic signed [A_WIDTH-1:0] i_a12_re, i_a12_im;

    logic signed [W_WIDTH-1:0] o_w11_re, o_w11_im;
    logic signed [W_WIDTH-1:0] o_w12_re, o_w12_im;
    logic signed [W_WIDTH-1:0] o_w21_re, o_w21_im;
    logic signed [W_WIDTH-1:0] o_w22_re, o_w22_im;

    logic o_sat_w11_re, o_sat_w11_im;
    logic o_sat_w12_re, o_sat_w12_im;
    logic o_sat_w21_re, o_sat_w21_im;
    logic o_sat_w22_re, o_sat_w22_im;

    /////////////////////////////////////////////////////
    logic [DET_WIDTH-1:0] o_det_a;
    logic o_det_sat;
    logic o_det_udf;

    logic signed [M_WIDTH-1:0] o_m11_re, o_m11_im;
    logic signed [M_WIDTH-1:0] o_m12_re, o_m12_im;
    logic signed [M_WIDTH-1:0] o_m21_re, o_m21_im;
    logic signed [M_WIDTH-1:0] o_m22_re, o_m22_im;
    logic o_sat_m11_re, o_sat_m11_im;
    logic o_sat_m12_re, o_sat_m12_im;
    logic o_sat_m21_re, o_sat_m21_im;
    logic o_sat_m22_re, o_sat_m22_im;

    logic [DET_WIDTH-1:0] o_det_inv;
    logic o_det_inv_inf;

    real i_a11_fxp, i_a22_fxp;
    real i_a12_re_fxp, i_a12_im_fxp;
    real det_a_fxp, det_inv_fxp;

    /////////////////////////////////////////////////////

    w_matrix #(
        .A_WIDTH       ( A_WIDTH ),
        .H_WIDTH       ( H_WIDTH ),
        .M_WIDTH       ( M_WIDTH ),
        .DET_WIDTH     ( DET_WIDTH ),
        .FRAC_WIDTH    ( FRAC_WIDTH ),
        .W_WIDTH       ( W_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) dut (
        .*
    );

    always #5 clk = ~clk;

    always @* begin
        i_a11_fxp    = $unsigned(i_a11) * (2.0 ** (-FRAC_WIDTH));
        i_a22_fxp    = $unsigned(i_a22) * (2.0 ** (-FRAC_WIDTH));

        i_a12_re_fxp = $signed(i_a12_re) * (2.0 ** (-FRAC_WIDTH));
        i_a12_im_fxp = $signed(i_a12_im) * (2.0 ** (-FRAC_WIDTH));

        det_a_fxp    = $unsigned(o_det_a) * (2.0 ** (-2*FRAC_WIDTH));
        det_inv_fxp  = $unsigned(o_det_inv) * (2.0 ** (-2*FRAC_WIDTH));
    end

    typedef struct {
        logic signed [H_WIDTH-1:0] h11_re, h11_im, h12_re, h12_im, h21_re, h21_im, h22_re, h22_im;
        logic [A_WIDTH-1:0] a11, a22;
        logic signed [A_WIDTH-1:0] a12_re, a12_im;
//        logic signed [M_WIDTH-1:0] exp_m11_re, exp_m11_im;
//        logic signed [M_WIDTH-1:0] exp_m12_re, exp_m12_im;
//        logic signed [M_WIDTH-1:0] exp_m21_re, exp_m21_im;
//        logic signed [M_WIDTH-1:0] exp_m22_re, exp_m22_im;
    } test_t;

    localparam NUM_TESTS = 16;

    test_t tests[NUM_TESTS];

    initial begin

        //tests[0].h11_re  = 16'b1000_0000_0000_0000; tests[0].h11_im  = 16'b1000_0000_0000_0000;
        //tests[0].h12_re  = 16'b1000_0000_0000_0000; tests[0].h12_im  = 16'b1000_0000_0000_0000;
        //tests[0].h21_re  = 16'b1000_0000_0000_0000; tests[0].h21_im  = 16'b1000_0000_0000_0000;
        //tests[0].h22_re  = 16'b1000_0000_0000_0000; tests[0].h22_im  = 16'b1000_0000_0000_0000;
        //tests[0].a11     = 16'b0000_0100_1001_1010; tests[0].a22     = 16'b0011_0010_0110_0110;
        //tests[0].a12_re  = 16'b0001_1011_0011_0011; tests[0].a12_im  = 16'b0000_0010_0110_0110;
   //     tests[0].exp_m11_re = -34'd4294934528; tests[0].exp_m11_im = 34'd2147450880;
   //     tests[0].exp_m12_re = -34'd4294934528; tests[0].exp_m12_im = 34'd2147450880;
   //     tests[0].exp_m21_re = -34'd2147450880; tests[0].exp_m21_im = 34'd4294934528;
   //     tests[0].exp_m22_re = -34'd2147450880; tests[0].exp_m22_im = 34'd4294934528;
        for (int i = 0; i < 16; i++) begin
            tests[i].h11_re  = 16'b1000_0000_0000_0000; tests[i].h11_im  = 16'b1000_0000_0000_0000;
            tests[i].h12_re  = 16'b1000_0000_0000_0000; tests[i].h12_im  = 16'b1000_0000_0000_0000;
            tests[i].h21_re  = 16'b1000_0000_0000_0000; tests[i].h21_im  = 16'b1000_0000_0000_0000;
            tests[i].h22_re  = 16'b1000_0000_0000_0000; tests[i].h22_im  = 16'b1000_0000_0000_0000;
            if (i < 4) begin
                tests[i].a11     = $urandom_range(1, 16);
                tests[i].a22     = $urandom_range(1, 16);
                tests[i].a12_re  = $urandom_range(1, 4);
                tests[i].a12_im  = $urandom_range(1, 4);
            end
            else if (i < 8) begin
                tests[i].a11     = $urandom_range(16, 256)*4;
                tests[i].a22     = $urandom_range(16, 256)*4;
                tests[i].a12_re  = $urandom_range(16, 256)/4;
                tests[i].a12_im  = $urandom_range(16, 256)/4;
            end
            else if (i < 12) begin
                tests[i].a11     = $urandom_range(256, 4096)*4;
                tests[i].a22     = $urandom_range(256, 4096)*4;
                tests[i].a12_re  = $urandom_range(256, 4096)/4;
                tests[i].a12_im  = $urandom_range(256, 4096)/4;
            end
            else begin
                tests[i].a11     = $urandom_range(4096, 65535);
                tests[i].a22     = $urandom_range(4096, 65535);
                tests[i].a12_re  = $urandom_range(4096, 16393);
                tests[i].a12_im  = $urandom_range(4096, 16393);
            end

        end

        //tests[1].h11_re  = 16'b0111_1111_1111_1111; tests[1].h11_im  = 16'b0111_1111_1111_1111;
        //tests[1].h12_re  = 16'b0111_1111_1111_1111; tests[1].h12_im  = 16'b0111_1111_1111_1111;
        //tests[1].h21_re  = 16'b0111_1111_1111_1111; tests[1].h21_im  = 16'b0111_1111_1111_1111;
        //tests[1].h22_re  = 16'b0111_1111_1111_1111; tests[1].h22_im  = 16'b0111_1111_1111_1111;
        //tests[1].a11     = 16'b1111_1111_1111_1111; tests[1].a22     = 16'b1111_1111_1111_1111;
        //tests[1].a12_re  = 16'b0111_1111_1111_1111; tests[1].a12_im  = 16'b0111_1111_1111_1111;
  //      tests[1].exp_m11_re = 32767;      tests[1].exp_m11_im = -2147385345;
  //      tests[1].exp_m12_re = 32767;      tests[1].exp_m12_im = -2147385345;
  //      tests[1].exp_m21_re = 2147385345; tests[1].exp_m21_im = -32767;
  //      tests[1].exp_m22_re = 2147385345; tests[1].exp_m22_im = -32767;


        //tests[2].h11_re  = 16'h01; tests[2].h11_im  = 16'h01;
        //tests[2].h12_re  = 16'h01; tests[2].h12_im  = 16'h01;
        //tests[2].h21_re  = 16'h01; tests[2].h21_im  = 16'h01;
        //tests[2].h22_re  = 16'h01; tests[2].h22_im  = 16'h01;
        //tests[2].a11     = 16'h01; tests[2].a22     = 16'h01;
        //tests[2].a12_re  = 16'h01; tests[2].a12_im  = 16'h01;
 //       tests[2].exp_m11_re = -1; tests[2].exp_m11_im = -1;
 //       tests[2].exp_m12_re = -1; tests[2].exp_m12_im = -1;
 //       tests[2].exp_m21_re = 1;  tests[2].exp_m21_im = 1;
 //       tests[2].exp_m22_re = 1;  tests[2].exp_m22_im = 1;


        //tests[3].h11_re  = 16'h00; tests[3].h11_im  = 16'h00;
        //tests[3].h12_re  = 16'h00; tests[3].h12_im  = 16'h00;
        //tests[3].h21_re  = 16'h00; tests[3].h21_im  = 16'h00;
        //tests[3].h22_re  = 16'h00; tests[3].h22_im  = 16'h00;
        //tests[3].a11     = 16'h00; tests[3].a22     = 16'h00;
        //tests[3].a12_re  = 16'h00; tests[3].a12_im  = 16'h00;
//        tests[3].exp_m11_re = 0; tests[3].exp_m11_im = 0;
//        tests[3].exp_m12_re = 0; tests[3].exp_m12_im = 0;
//        tests[3].exp_m21_re = 0; tests[3].exp_m21_im = 0;
//        tests[3].exp_m22_re = 0; tests[3].exp_m22_im = 0;
    end

    int test_idx;
    bit test_failed = 0;
    int errors = 0;

    int cycle_cnt = 0;
    typedef struct{
        int test_idx;
        real det_a;
        real det_inv;
    } test_data_t;
    test_data_t test_storage[16];

    initial begin
        i_h11_re  = 0; i_h11_im  = 0;
        i_h12_re  = 0; i_h12_im  = 0;
        i_h21_re  = 0; i_h21_im  = 0;
        i_h22_re  = 0; i_h22_im  = 0;
        i_a11     = 0; i_a22     = 0;
        i_a12_re  = 0; i_a12_im  = 0;

        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;

        repeat (2) @(posedge clk);

        fork
            begin
                for (test_idx = 0; test_idx < NUM_TESTS; test_idx++) begin
                    test_storage[test_idx].test_idx = test_idx;
                    i_h11_re  = tests[test_idx].h11_re;
                    i_h11_im  = tests[test_idx].h11_im;
                    i_h12_re  = tests[test_idx].h12_re;
                    i_h12_im  = tests[test_idx].h12_im;
                    i_h21_re  = tests[test_idx].h21_re;
                    i_h21_im  = tests[test_idx].h21_im;
                    i_h22_re  = tests[test_idx].h22_re;
                    i_h22_im  = tests[test_idx].h22_im;
                    i_a11     = tests[test_idx].a11;
                    i_a22     = tests[test_idx].a22;
                    i_a12_re  = tests[test_idx].a12_re;
                    i_a12_im  = tests[test_idx].a12_im;

                    $display("Running Test %0d...", test_idx);


                    @(posedge clk);
                    //check_outputs(tests[test_idx]);
                end
            end

            begin
                for (int i = 0; i < 25; i++) begin
                    if (cycle_cnt - 5 >= 0) begin
                        test_storage[cycle_cnt - 5].det_a = det_a_fxp;
                    end

                    if (cycle_cnt - 9 >= 0) begin
                        test_storage[cycle_cnt - 9].det_inv = det_inv_fxp;
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

        if (test.det_a * test.det_inv > 1.05 || test.det_inv * test.det_a < 0.95) begin
            $display(" ERROR: Test %0d, det_inv = %f, det_a = %f, det_inv * det_a = %f, expected %f",
                     test.test_idx, test.det_inv, test.det_a, test.det_inv * test.det_a, 1.0);
            local_errors++;
        end

        if (local_errors == 0) begin
            $display("     PASSED Test %0d, det_inv = %f, det_a = %f, det_inv * det_a = %f",
                    test.test_idx, test.det_inv, test.det_a, test.det_inv * test.det_a);
        end else begin
            errors += local_errors;
            test_failed = 1;
        end
    endtask


endmodule
