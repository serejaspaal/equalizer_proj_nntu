`timescale 1ns / 1ps
module sum_tb;
    localparam int A_WIDTH = 8;
    localparam int B_WIDTH = 8;
    localparam int MAX_W   = (A_WIDTH > B_WIDTH) ? A_WIDTH : B_WIDTH;

    logic clk, rst;


    logic                   valid_in1, sub1;
    logic [A_WIDTH-1:0]     A1;
    logic [B_WIDTH-1:0]     B1;
    logic                   valid_out1;
    logic signed [MAX_W:0]  S1;

    logic                   valid_in2, sub2;
    logic [A_WIDTH-1:0]     A2;
    logic [B_WIDTH-1:0]     B2;
    logic                   valid_out2;
    logic [MAX_W:0]         S2;
    logic                   underflow2;

    sum #(
        .A_WIDTH        (A_WIDTH),
        .B_WIDTH        (B_WIDTH),
        .USE_DSP_VALUE  ("yes"),
        .SIGNED_OPERANDS("yes")
    ) dut_1 (
        .clk, .rst,
        .valid_in (valid_in1), .A (A1), .B (B1), .sub (sub1),
        .valid_out(valid_out1), .S (S1),
        .underflow ()
    );

    sum #(
        .A_WIDTH        (A_WIDTH),
        .B_WIDTH        (B_WIDTH),
        .USE_DSP_VALUE  ("yes"),
        .SIGNED_OPERANDS("no")
    ) dut_2 (
        .clk, .rst,
        .valid_in (valid_in2), .A (A2), .B (B2), .sub (sub2),
        .valid_out(valid_out2), .S (S2), .underflow (underflow2)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    logic signed [MAX_W:0] exp_S1;  logic exp_v1;
    logic        [MAX_W:0] exp_S2;  logic exp_v2, exp_u2;

    logic [A_WIDTH-1:0] A1_d, A2_d;
    logic [B_WIDTH-1:0] B1_d, B2_d;
    logic               sub1_d, sub2_d;

    always_ff @(posedge clk) begin
        // signed
        exp_v1 <= valid_in1;
        if (sub1) exp_S1 <= $signed(A1) - $signed(B1);
        else      exp_S1 <= $signed(A1) + $signed(B1);
        A1_d <= A1; B1_d <= B1; sub1_d <= sub1;

        // unsigned
        exp_v2 <= valid_in2;
        if (sub2) exp_S2 <= A2 - B2;
        else      exp_S2 <= A2 + B2;
        exp_u2 <= sub2 && (A2 < B2);
        A2_d <= A2; B2_d <= B2; sub2_d <= sub2;
    end

    int errors = 0;

    always @(posedge clk) begin
        #1;
        if (exp_v1 && valid_out1) begin
            if (S1 !== exp_S1) begin
                $error("dut_1 (signed)   FAIL @%0t: S=%0d (exp %0d) | A=%0d B=%0d sub=%b",
                       $time, S1, exp_S1, $signed(A1_d), $signed(B1_d), sub1_d);
                errors++;
            end else
                $display("dut_1 (signed)   PASS @%0t: A=%0d B=%0d sub=%b -> S=%0d",
                         $time, $signed(A1_d), $signed(B1_d), sub1_d, S1);
        end
        if (exp_v2 && valid_out2) begin
            if (S2 !== exp_S2 || underflow2 !== exp_u2) begin
                $error("dut_2 (unsigned) FAIL @%0t: S=%0d u=%b (exp S=%0d u=%b) | A=%0d B=%0d sub=%b",
                       $time, S2, underflow2, exp_S2, exp_u2, A2_d, B2_d, sub2_d);
                errors++;
            end else
                $display("dut_2 (unsigned) PASS @%0t: A=%0d B=%0d sub=%b -> S=%0d u=%b",
                         $time, A2_d, B2_d, sub2_d, S2, underflow2);
        end
    end

    initial begin
        $display("=== testbench ===");
        rst = 1;
        valid_in1 = 0; A1 = 0; B1 = 0; sub1 = 0;
        valid_in2 = 0; A2 = 0; B2 = 0; sub2 = 0;
        repeat (2) @(posedge clk); #1;
        rst = 0;

        @(posedge clk); #1;
        valid_in1=1; A1=0;    B1=0;    sub1=0;   
        valid_in2=1; A2=0;    B2=0;    sub2=0;   
        @(posedge clk); #1;
        valid_in1=1; A1=127;  B1=1;    sub1=0;   
        valid_in2=1; A2=255;  B2=0;    sub2=0;   
        @(posedge clk); #1;
        valid_in1=1; A1=127;  B1=127;  sub1=0;   
        valid_in2=1; A2=255;  B2=255;  sub2=0;   
        @(posedge clk); #1;
        valid_in1=1; A1=-128; B1=-128; sub1=0;   
        valid_in2=1; A2=200;  B2=100;  sub2=0;   
        @(posedge clk); #1;
        valid_in1=1; A1=-128; B1=127;  sub1=0;   
        valid_in2=1; A2=1;    B2=254;  sub2=0;   
        @(posedge clk); #1;
        valid_in1=1; A1=1;    B1=-1;   sub1=0;   
        valid_in2=1; A2=128;  B2=128;  sub2=0;   

     
        @(posedge clk); #1;
        valid_in1=1; A1=127;  B1=-128; sub1=1;   
        valid_in2=1; A2=255;  B2=0;    sub2=1;   
        @(posedge clk); #1;
        valid_in1=1; A1=-128; B1=127;  sub1=1;   
        valid_in2=1; A2=255;  B2=255;  sub2=1;   
        @(posedge clk); #1;
        valid_in1=1; A1=127;  B1=127;  sub1=1;   
        valid_in2=1; A2=100;  B2=200;  sub2=1;   
        @(posedge clk); #1;
        valid_in1=1; A1=-128; B1=-128; sub1=1;   
        valid_in2=1; A2=0;    B2=255;  sub2=1;   
        @(posedge clk); #1;
        valid_in1=1; A1=0;    B1=0;    sub1=1;   
        valid_in2=1; A2=128;  B2=1;    sub2=1;   
        @(posedge clk); #1;
        valid_in1=1; A1=1;    B1=-1;   sub1=1;   
        valid_in2=1; A2=1;    B2=1;    sub2=1;  

        @(posedge clk); #1;
        valid_in1=0; A1=0; B1=0; sub1=0;
        valid_in2=0; A2=0; B2=0; sub2=0;

        repeat (3) @(posedge clk);
        if (errors == 0) $display("=== Done: ALL TESTS PASSED ===");
        else             $display("=== Done: %0d ERROR(S) ===", errors);
        $finish;
    end
endmodule