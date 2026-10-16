`timescale 1ns / 1ps

module cmodule_tb;

    parameter int WIDTH = 8;

    import "DPI-C" function int cmodule(
        input int i_Re,
        input int i_Im
    );

    logic        clk;
    logic        rst;
    logic        valid_in;
    logic signed [WIDTH-1:0] Re;
    logic signed [WIDTH-1:0] Im;
    logic        valid_out;
    logic unsigned [2*WIDTH-1:0] MagSq;
    logic unsigned [2*WIDTH-1:0] exp;
    int          test_number;
    int          errors = 0;

    cmodule #(
        .WIDTH         (WIDTH),
        .USE_DSP_VALUE (1)
    ) dut (
        .clk,
        .rst,
        .valid_in,
        .Re,
        .Im,
        .valid_out,
        .MagSq
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task automatic test(
            input int test_num,
            input int in_re,
            input int in_im
        );
            @(posedge clk);
            test_number = test_num;
            Re = in_re;
            Im = in_im;

            exp = cmodule(
                Re,
                Im
            );

            repeat(3) @(posedge clk);

            if (MagSq !== exp) begin
                $error("FAIL at %0t: MagSq=%0d (expected %0d)", $time, MagSq, exp);
                errors++;
            end else
                $display("PASS at %0t: MagSq=%0d", $time, MagSq);

        endtask
    initial begin
        rst = 1; valid_in = 0; Re = 0; Im = 0;
        repeat(2) @(posedge clk);
        rst = 0;
        valid_in = 1;
        test(1, 0, 0);
        test(2, 127, 0);
        test(3, -128, 0);
        test(4, 0, 127);
        test(5, 0, -128);
        test(6, 127, 127);
        test(7, -128, -128);
        test(8, 1, 1);
        test(9, -1, -1);
        test(10, 127, -128);
        valid_in = 0;
        @(posedge clk);
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);
    end
endmodule
