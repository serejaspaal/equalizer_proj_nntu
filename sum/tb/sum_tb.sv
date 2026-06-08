`timescale 1ns / 1ps

module sum_tb;

    localparam int A_WIDTH = 8;
    localparam int B_WIDTH = 8;
    localparam int MAX_W   = (A_WIDTH > B_WIDTH) ? A_WIDTH : B_WIDTH;

    logic        clk, rst;
    logic        valid_in, sub;
    logic signed [A_WIDTH-1:0] A;
    logic signed [B_WIDTH-1:0] B;
    logic        valid_out;
    logic signed [MAX_W:0]     S;

    sum #(
        .A_WIDTH       (A_WIDTH),
        .B_WIDTH       (B_WIDTH),
        .USE_DSP_VALUE ("yes")
    ) dut (
        .clk,
        .rst,
        .valid_in,
        .A,
        .B,
        .sub,
        .valid_out,
        .S
    );

    initial clk = 0;
    always #5 clk = ~clk;

    logic signed [MAX_W:0] exp_S;
    logic                exp_v;

    always_ff @(posedge clk) begin
        exp_v <= valid_in;
        exp_S <= sub ? (A - B) : (A + B);
    end

    always @(posedge clk) begin
        #0;
        if (exp_v && valid_out) begin
            if (S !== exp_S)
                $error("FAIL at %0t: S=%0d (expected %0d) | A=%0d B=%0d sub=%b",
                       $time, S, exp_S, A, B, sub);
            else
                $display("PASS at %0t: S=%0d", $time, S);
        end
    end

    initial begin
        $display("=== sum self-checking testbench ===");

        rst = 1; valid_in = 0; A = 0; B = 0; sub = 0;
        repeat(2) @(posedge clk);
        rst = 0;

        //         
        @(posedge clk); valid_in = 1; A = 0;       B = 0;       sub = 0;
        @(posedge clk); valid_in = 1; A = 127;     B = 1;       sub = 0;
        @(posedge clk); valid_in = 1; A = 127;     B = 127;     sub = 0;
        @(posedge clk); valid_in = 1; A = -128;    B = -128;    sub = 0;
        @(posedge clk); valid_in = 1; A = -128;    B = 127;     sub = 0;
        @(posedge clk); valid_in = 1; A = 1;       B = -1;      sub = 0;

        //          
        @(posedge clk); valid_in = 1; A = 127;     B = -128;    sub = 1;
        @(posedge clk); valid_in = 1; A = -128;    B = 127;     sub = 1;
        @(posedge clk); valid_in = 1; A = 127;     B = 127;     sub = 1;
        @(posedge clk); valid_in = 1; A = -128;    B = -128;    sub = 1;
        @(posedge clk); valid_in = 1; A = 0;       B = 0;       sub = 1;
        @(posedge clk); valid_in = 1; A = 1;       B = -1;      sub = 1;

        @(posedge clk); valid_in = 0; A = 0; B = 0; sub = 0;
        repeat(2) @(posedge clk);

        $display("=== Done ===");
        $finish;
    end

endmodule