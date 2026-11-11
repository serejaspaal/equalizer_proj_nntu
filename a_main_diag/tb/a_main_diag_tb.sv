`timescale 1ns / 1ps

module a_main_diag_tb;

    parameter int H_WIDTH = 16;
    parameter int C_WIDTH = 16;
    parameter int A_WIDTH = H_WIDTH + C_WIDTH + 2;
    parameter int POINT_POS = 8;
    parameter int USE_DSP_VALUE = 1;

    localparam int LATENCY = 4;
    localparam int TEST_COUNT = 16;

    typedef struct {
        longint signed h11_re;
        longint signed h11_im;
        longint signed h12_re;
        longint signed h12_im;
        longint signed h21_re;
        longint signed h21_im;
        longint signed h22_re;
        longint signed h22_im;
        longint signed c11;
        longint signed c22;
    } a_matrix_t;

    logic clk, rst, valid_in, valid_out;

    logic signed [H_WIDTH-1:0] i_h11_re, i_h11_im;
    logic signed [H_WIDTH-1:0] i_h12_re, i_h12_im;
    logic signed [H_WIDTH-1:0] i_h21_re, i_h21_im;
    logic signed [H_WIDTH-1:0] i_h22_re, i_h22_im;

    logic [C_WIDTH-1:0] i_c11, i_c22;

    logic [A_WIDTH-1:0] o_a11, o_a22;
    logic o_sat_a11, o_sat_a22;

    a_main_diag #(
        .H_WIDTH(H_WIDTH),
        .C_WIDTH(C_WIDTH),
        .A_WIDTH(A_WIDTH),
        .POINT_POS(POINT_POS),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) dut (.*);

    import "DPI-C" function void a_main_diag(
        input a_matrix_t mat,
        input int h_width,
        input int c_width,
        input int a_width,
        input int point_pos,
        output longint o_a11,
        output longint o_a22,
        output int o_sat_a11,
        output int o_sat_a22
    );

    logic [A_WIDTH-1:0] expected_a11_pipe [0:LATENCY];
    logic [A_WIDTH-1:0] expected_a22_pipe [0:LATENCY];

    logic sat_a11_pipe [0:LATENCY];
    logic sat_a22_pipe [0:LATENCY];

    logic valid_pipe [0:LATENCY];

    int errors = 0;
    int checked = 0;
    int sent = 0;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (rst) begin
            for (int k = 0; k <= LATENCY; k++) begin
                expected_a11_pipe[k] <= '0;
                expected_a22_pipe[k] <= '0;
                sat_a11_pipe[k] <= 1'b0;
                sat_a22_pipe[k] <= 1'b0;
                valid_pipe[k] <= 1'b0;
            end
        end else begin
            begin : c_model
                a_matrix_t mat;
                longint c_a11, c_a22;
                int c_sat_a11, c_sat_a22;

                mat.h11_re = i_h11_re;
                mat.h11_im = i_h11_im;
                mat.h12_re = i_h12_re;
                mat.h12_im = i_h12_im;
                mat.h21_re = i_h21_re;
                mat.h21_im = i_h21_im;
                mat.h22_re = i_h22_re;
                mat.h22_im = i_h22_im;
                mat.c11 = i_c11;
                mat.c22 = i_c22;

                a_main_diag(
                    mat,
                    H_WIDTH,
                    C_WIDTH,
                    A_WIDTH,
                    POINT_POS,
                    c_a11,
                    c_a22,
                    c_sat_a11,
                    c_sat_a22
                );

                expected_a11_pipe[0] <= c_a11[A_WIDTH-1:0];
                expected_a22_pipe[0] <= c_a22[A_WIDTH-1:0];

                sat_a11_pipe[0] <= c_sat_a11[0];
                sat_a22_pipe[0] <= c_sat_a22[0];
            end

            valid_pipe[0] <= valid_in;

            for (int k = 1; k <= LATENCY; k++) begin
                expected_a11_pipe[k] <= expected_a11_pipe[k-1];
                expected_a22_pipe[k] <= expected_a22_pipe[k-1];
                sat_a11_pipe[k] <= sat_a11_pipe[k-1];
                sat_a22_pipe[k] <= sat_a22_pipe[k-1];
                valid_pipe[k] <= valid_pipe[k-1];
            end
        end
    end

    always @(posedge clk) begin
        #1;

        if (!rst && valid_out !== valid_pipe[LATENCY]) begin
            errors++;
            $error(
                "VALID mismatch: RTL=%0b C-model=%0b",
                valid_out,
                valid_pipe[LATENCY]
            );
        end

        if (!rst && valid_out) begin
            checked++;

            if (o_a11 !== expected_a11_pipe[LATENCY] ||
                o_sat_a11 !== sat_a11_pipe[LATENCY]) begin
                errors++;
                $error(
                    "a11 mismatch: RTL=%h/%b C=%h/%b",
                    o_a11, o_sat_a11,
                    expected_a11_pipe[LATENCY],
                    sat_a11_pipe[LATENCY]
                );
            end

            if (o_a22 !== expected_a22_pipe[LATENCY] ||
                o_sat_a22 !== sat_a22_pipe[LATENCY]) begin
                errors++;
                $error(
                    "a22 mismatch: RTL=%h/%b C=%h/%b",
                    o_a22, o_sat_a22,
                    expected_a22_pipe[LATENCY],
                    sat_a22_pipe[LATENCY]
                );
            end

            if (o_a11 === expected_a11_pipe[LATENCY] &&
                o_sat_a11 === sat_a11_pipe[LATENCY] &&
                o_a22 === expected_a22_pipe[LATENCY] &&
                o_sat_a22 === sat_a22_pipe[LATENCY]) begin
                $display(
                    "PASS #%0d: a11=%h sat=%b; a22=%h sat=%b",
                    checked,
                    o_a11, o_sat_a11,
                    o_a22, o_sat_a22
                );
            end
        end
    end

    task automatic drive(
        input logic signed [H_WIDTH-1:0] h11re, h11im, h12re, h12im,
        input logic signed [H_WIDTH-1:0] h21re, h21im, h22re, h22im,
        input logic [C_WIDTH-1:0] c11, c22,
        input logic v
    );
        @(negedge clk);

        i_h11_re = h11re;
        i_h11_im = h11im;
        i_h12_re = h12re;
        i_h12_im = h12im;

        i_h21_re = h21re;
        i_h21_im = h21im;
        i_h22_re = h22re;
        i_h22_im = h22im;

        i_c11 = c11;
        i_c22 = c22;
        valid_in = v;

        if (v)
            sent++;
    endtask

    initial begin : stimulus
        logic signed [H_WIDTH-1:0] random_h [0:7];
        logic [C_WIDTH-1:0] random_c1, random_c2;

        rst = 1'b1;
        valid_in = 1'b0;

        i_h11_re = '0;
        i_h11_im = '0;
        i_h12_re = '0;
        i_h12_im = '0;
        i_h21_re = '0;
        i_h21_im = '0;
        i_h22_re = '0;
        i_h22_im = '0;
        i_c11 = '0;
        i_c22 = '0;

        repeat (3) @(negedge clk);
        rst = 1'b0;

        drive(0,0,0,0, 0,0,0,0, 0,0, 1);

        drive(1,-1,2,-2, -3,3,-4,4, 1,255, 1);

        drive(32767,32767,32767,32767,
              32767,32767,32767,32767, 0,0, 1);

        drive(-32768,-32768,-32768,-32768,
              -32768,-32768,-32768,-32768, 0,0, 1);

        drive(-32768,32767,32767,-32768,
              -32768,-1,32767,1, 16'hffff,16'h8000, 1);

        drive(127,-128,-128,127, 1,-1,0,0, 1024,1536, 1);

        drive(0,0,0,0, 0,0,0,0, 16'hffff,16'hffff, 1);

        drive(12,-34,-56,78, 90,-123,-234,321, 2048,4095, 1);

        for (int n = 0; n < TEST_COUNT; n++) begin
            for (int j = 0; j < 8; j++)
                random_h[j] = $urandom;

            random_c1 = $urandom;
            random_c2 = $urandom;

            drive(
                random_h[0], random_h[1],
                random_h[2], random_h[3],
                random_h[4], random_h[5],
                random_h[6], random_h[7],
                random_c1, random_c2,
                ($urandom_range(0,4) != 0)
            );
        end

        drive(0,0,0,0, 0,0,0,0, 0,0, 0);

        repeat (LATENCY + 3) @(negedge clk);
        #2;

        if (checked != sent) begin
            errors++;
            $error(
                "Test count mismatch: sent=%0d checked=%0d",
                sent,
                checked
            );
        end

        if (errors == 0) begin
            $display(
                "ALL TESTS PASSED: sent=%0d checked=%0d errors=%0d",
                sent, checked, errors
            );
        end else begin
            $display(
                "TEST FAILED: sent=%0d checked=%0d errors=%0d",
                sent, checked, errors
            );
            $fatal(1, "a_main_diag RTL does not match DPI-C model");
        end

        $finish;
    end

endmodule
