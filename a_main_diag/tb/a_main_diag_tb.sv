`timescale 1ns / 1ps

module a_main_diag_tb;
    parameter int H_WIDTH = 8;
    parameter int C_WIDTH = 16;
    parameter int A_WIDTH = 8;
    parameter int USE_DSP_VALUE = 1;

    localparam int CMAG_WIDTH = 2*H_WIDTH;
    localparam int S1_WIDTH = CMAG_WIDTH + 1;
    localparam int S2_WIDTH = (S1_WIDTH > C_WIDTH) ? S1_WIDTH : C_WIDTH;
    localparam int ROUND_IN = S2_WIDTH + 1;
    localparam int DROP = ROUND_IN - A_WIDTH;
    localparam int LATENCY = 5;
    localparam [A_WIDTH:0] MAXU = (1 <<< A_WIDTH) - 1;

    logic clk, rst, valid_in, valid_out;
    logic signed [H_WIDTH-1:0] i_h11_re, i_h11_im, i_h12_re, i_h12_im;
    logic signed [H_WIDTH-1:0] i_h21_re, i_h21_im, i_h22_re, i_h22_im;
    logic [C_WIDTH-1:0] i_c11, i_c22;
    logic [A_WIDTH-1:0] o_a11, o_a22;
    logic o_sat_a11, o_sat_a22;

    a_main_diag #(
        .H_WIDTH(H_WIDTH),
        .C_WIDTH(C_WIDTH),
        .A_WIDTH(A_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) dut (.*);

    initial clk = 0;
    always #5 clk = ~clk;

    task drive(input logic signed [H_WIDTH-1:0] h11_re, h11_im, h12_re, h12_im,
               input logic signed [H_WIDTH-1:0] h21_re, h21_im, h22_re, h22_im,
               input logic [C_WIDTH-1:0] c11, c22);
        i_h11_re = h11_re; i_h11_im = h11_im;
        i_h12_re = h12_re; i_h12_im = h12_im;
        i_h21_re = h21_re; i_h21_im = h21_im;
        i_h22_re = h22_re; i_h22_im = h22_im;
        i_c11 = c11; i_c22 = c22;
    endtask

    logic unsigned [CMAG_WIDTH-1:0] ref_re_sq [3:0], ref_im_sq [3:0], ref_cmag [3:0];
    logic [S1_WIDTH-1:0] ref_s1 [1:0];
    logic [ROUND_IN-1:0] ref_s2 [1:0];
    logic [A_WIDTH:0] ref_sum  [1:0];
    logic [A_WIDTH-1:0] exp_data [1:0];
    logic exp_sat [1:0];

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int k = 0; k < 4; k++) begin
                ref_re_sq[k] <= '0;
                ref_im_sq[k] <= '0;
                ref_cmag[k] <= '0;
            end
            ref_s1[0] <= '0; ref_s1[1] <= '0;
            ref_s2[0] <= '0; ref_s2[1] <= '0;
            exp_data[0] <= '0; exp_data[1] <= '0;
            exp_sat[0] <= 1'b0; exp_sat[1] <= 1'b0;
        end else begin
            ref_re_sq[0] <= i_h11_re * i_h11_re;
            ref_im_sq[0] <= i_h11_im * i_h11_im;
            ref_re_sq[1] <= i_h12_re * i_h12_re;
            ref_im_sq[1] <= i_h12_im * i_h12_im;
            ref_re_sq[2] <= i_h21_re * i_h21_re;
            ref_im_sq[2] <= i_h21_im * i_h21_im;
            ref_re_sq[3] <= i_h22_re * i_h22_re;
            ref_im_sq[3] <= i_h22_im * i_h22_im;

            ref_cmag[0] <= ref_re_sq[0] + ref_im_sq[0];
            ref_cmag[1] <= ref_re_sq[1] + ref_im_sq[1];
            ref_cmag[2] <= ref_re_sq[2] + ref_im_sq[2];
            ref_cmag[3] <= ref_re_sq[3] + ref_im_sq[3];

            ref_s1[0] <= ref_cmag[0] + ref_cmag[1];
            ref_s1[1] <= ref_cmag[2] + ref_cmag[3];

            ref_s2[0] <= ref_s1[0] + i_c11;
            ref_s2[1] <= ref_s1[1] + i_c22;

            for (int i = 0; i < 2; i++) begin
                if (ref_sum[i] > MAXU) begin
                    exp_data[i] <= MAXU[A_WIDTH-1:0];
                    exp_sat[i] <= 1'b1;
                end else begin
                    exp_data[i] <= ref_sum[i][A_WIDTH-1:0];
                    exp_sat[i] <= 1'b0;
                end
            end
        end
    end

    always_comb begin
        ref_sum[0] = {1'b0, ref_s2[0][ROUND_IN-1 : DROP]} + ref_s2[0][DROP-1];
        ref_sum[1] = {1'b0, ref_s2[1][ROUND_IN-1 : DROP]} + ref_s2[1][DROP-1];
    end

    int errors = 0;

    always @(posedge clk) begin
        #1;
        if (!rst && valid_out) begin
            if (o_a11 !== exp_data[0] || o_sat_a11 !== exp_sat[0]) begin
                $error("FAIL @%0t: a11=%0d sat=%0d (exp %0d %0d)", $time,
                       o_a11, o_sat_a11, exp_data[0], exp_sat[0]);
                errors++;
            end
            if (o_a22 !== exp_data[1] || o_sat_a22 !== exp_sat[1]) begin
                $error("FAIL @%0t: a22=%0d sat=%0d (exp %0d %0d)", $time,
                       o_a22, o_sat_a22, exp_data[1], exp_sat[1]);
                errors++;
            end
            if (o_a11 === exp_data[0] && o_sat_a11 === exp_sat[0] &&
                o_a22 === exp_data[1] && o_sat_a22 === exp_sat[1])
                $display("PASS @%0t: a11=%0d a22=%0d sat=%0d/%0d",
                         $time, o_a11, o_a22, o_sat_a11, o_sat_a22);
        end
    end

    initial begin
        $display("testbench: H=%0d C=%0d A=%0d", H_WIDTH, C_WIDTH, A_WIDTH);
        rst = 1;
        valid_in = 0;
        drive(0,0,0,0, 0,0,0,0, 0,0);
        repeat (2) @(posedge clk); #1;
        rst = 0;

        @(posedge clk); #1;
        valid_in = 1;
        drive(0,0,0,0, 0,0,0,0, 0,0);
        @(posedge clk); #1;
        drive(127,127,127,127, 127,127,127,127, 0,0);
        @(posedge clk); #1;
        drive(-128,-128,-128,-128, -128,-128,-128,-128, 0,0);
        @(posedge clk); #1;
        drive(1,1,1,1, 1,1,1,1, 1024,1024);
        @(posedge clk); #1;
        drive(1,1,1,1, 1,1,1,1, 1536,1536);
        @(posedge clk); #1;
        drive(-128,-128,-128,-128, 127,127,127,127, 0,0);
        @(posedge clk); #1;
        drive(-128,-128,-128,-128, -128,-128,-128,-128, 65535,65535);
        @(posedge clk); #1;
        drive(0,0,0,0, 0,0,0,0, 1023,1023);
        @(posedge clk); #1;
        drive(0,0,0,0, 0,0,0,0, 2048,2048);
        @(posedge clk); #1;
        drive(-128,-128,-128,-128, 0,0,0,0, 0,1024);

        @(posedge clk); #1;
        valid_in = 0;
        drive(0,0,0,0, 0,0,0,0, 0,0);

        repeat (LATENCY + 2) @(posedge clk);
        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("Done: %0d ERROR", errors);
        $finish;
    end
endmodule