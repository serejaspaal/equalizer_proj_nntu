`timescale 1ns / 1ps

module mult_tb ();
    parameter A_WIDTH = 8;
    parameter B_WIDTH = 8;
    parameter int USE_DSP_VALUE = 1;

    import "DPI-C" function int mult(
        input int i_a,
        input int i_b
    );

    logic clk;
    logic signed [A_WIDTH-1:0] a_s;
    logic unsigned [A_WIDTH-1:0] a_u;
    logic signed [B_WIDTH-1:0] b_s;
    logic unsigned [B_WIDTH-1:0] b_u;
    logic signed [A_WIDTH+B_WIDTH-1:0] result_s, expected_s;
    logic unsigned[A_WIDTH+B_WIDTH-1:0] result_u, expected_u;

    integer errors;
    int test_number;

    mult #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE),
        .SIGNED_OPERANDS(1)
    ) dut_s (
        .clk,
        .a(a_s),
        .b(b_s),
        .result(result_s)
    );

    mult #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE),
        .SIGNED_OPERANDS(0)
    ) dut_u (
        .clk,
        .a(a_u),
        .b(b_u),
        .result(result_u)
    );


    initial clk = 0;
    always #2 clk = ~clk;


    task automatic test(
        input int test_num,
        input int a_signed,
        input int b_signed,
        input int a_unsigned,
        input int b_unsigned
    );
        @(posedge clk);
        test_number = test_num;
        a_s = a_signed;
        b_s = b_signed;
        a_u = a_unsigned;
        b_u = b_unsigned;

        expected_s = mult(
            a_s,
            b_s
        );

        expected_u = mult(
            a_u,
            b_u
        );

        repeat(3) @(posedge clk);

        if (result_s !== expected_s) begin
            $error("FAIL at %0d: result_s=%0d (expected %0d)", test_num, result_s, expected_s);
            errors++;
        end else
            $display("PASS at %0d: result_s=%0d", test_num, result_s);

        if (result_u !== expected_u) begin
            $error("FAIL at %0d: result_u=%0d (expected %0d)", test_num, result_u, expected_u);
            errors++;
        end else
            $display("PASS at %0d: result_u=%0d", test_num, result_u);

    endtask

    initial begin
        errors = 0;
        test(0, -128, -128, 0, 0);
        test(1, -128, 127,  0, 255);
        test(2, 127,  -128, 255, 255);
        test(3, 127,  127,  255, 0);
    end
endmodule
