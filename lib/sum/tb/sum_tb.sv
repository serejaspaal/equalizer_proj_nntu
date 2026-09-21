`timescale 1ns / 1ps

module sum_tb;

    localparam int A_WIDTH = 8;
    localparam int B_WIDTH = 8;
    localparam int MAX_W   = (A_WIDTH > B_WIDTH) ? A_WIDTH : B_WIDTH;

    import "DPI-C" function int sum(
        input int A,
        input int B,
        input int sub,
        input int signed_operands,
        input int A_WIDTH,
        input int B_WIDTH,
        output int underflow
    );

    logic clk;
    logic rst;

    logic                  valid_in1;
    logic [A_WIDTH-1:0]    A1;
    logic [B_WIDTH-1:0]    B1;
    logic                  sub1;
    logic                  valid_out1;
    logic signed [MAX_W:0] S1;
    logic                  underflow1;

    logic                  valid_in2;
    logic [A_WIDTH-1:0]    A2;
    logic [B_WIDTH-1:0]    B2;
    logic                  sub2;
    logic                  valid_out2;
    logic        [MAX_W:0] S2;
    logic                  underflow2;

    logic signed [MAX_W:0] exp_S1;
    logic        [MAX_W:0] exp_S2;
    logic                  exp_u1;
    logic                  exp_u2;
    logic                  exp_v1;
    logic                  exp_v2;

    int errors = 0;

    sum #(
        .A_WIDTH         (A_WIDTH),
        .B_WIDTH         (B_WIDTH),
        .USE_DSP_VALUE   (1),
        .SIGNED_OPERANDS (1)
    ) dut_signed (
        .clk       (clk),
        .rst       (rst),
        .valid_in  (valid_in1),
        .A         (A1),
        .B         (B1),
        .sub       (sub1),
        .valid_out (valid_out1),
        .S         (S1),
        .underflow (underflow1)
    );

    sum #(
        .A_WIDTH         (A_WIDTH),
        .B_WIDTH         (B_WIDTH),
        .USE_DSP_VALUE   (1),
        .SIGNED_OPERANDS (0)
    ) dut_unsigned (
        .clk       (clk),
        .rst        (rst),
        .valid_in  (valid_in2),
        .A         (A2),
        .B         (B2),
        .sub       (sub2),
        .valid_out (valid_out2),
        .S         (S2),
        .underflow (underflow2)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task automatic test(
        input int signed_a,
        input int signed_b,
        input int signed_sub,
        input int unsigned_a,
        input int unsigned_b,
        input int unsigned_sub
    );
        int c_underflow;

        @(negedge clk);

        valid_in1 = 1'b1;
        A1 = signed_a;
        B1 = signed_b;
        sub1 = signed_sub;

        valid_in2 = 1'b1;
        A2 = unsigned_a;
        B2 = unsigned_b;
        sub2 = unsigned_sub;

        c_underflow = 0;

        exp_S1 = sum(
            signed_a,
            signed_b,
            signed_sub,
            1,
            A_WIDTH,
            B_WIDTH,
            c_underflow
        );

        exp_u1 = c_underflow;

        c_underflow = 0;

        exp_S2 = sum(
            unsigned_a,
            unsigned_b,
            unsigned_sub,
            0,
            A_WIDTH,
            B_WIDTH,
            c_underflow
        );

        exp_u2 = c_underflow;

        @(posedge clk);
        #1;

        if (S1 !== exp_S1 || underflow1 !== exp_u1) begin
            $error(
                "SIGNED FAIL: A=%0d B=%0d sub=%0d | RTL S=%0d u=%b | C S=%0d u=%b",
                signed_a,
                signed_b,
                signed_sub,
                $signed(S1),
                underflow1,
                $signed(exp_S1),
                exp_u1
            );
            errors++;
        end
        else begin
            $display(
                "SIGNED PASS: A=%0d B=%0d sub=%0d -> S=%0d",
                signed_a,
                signed_b,
                signed_sub,
                $signed(S1)
            );
        end

        if (S2 !== exp_S2 || underflow2 !== exp_u2) begin
            $error(
                "UNSIGNED FAIL: A=%0d B=%0d sub=%0d | RTL S=%0d u=%b | C S=%0d u=%b",
                unsigned_a,
                unsigned_b,
                unsigned_sub,
                S2,
                underflow2,
                exp_S2,
                exp_u2
            );
            errors++;
        end
        else begin
            $display(
                "UNSIGNED PASS: A=%0d B=%0d sub=%0d -> S=%0d u=%b",
                unsigned_a,
                unsigned_b,
                unsigned_sub,
                S2,
                underflow2
            );
        end
    endtask

    initial begin
        $display("=== SUM TESTBENCH ===");

        rst = 1'b1;

        valid_in1 = 1'b0;
        A1 = '0;
        B1 = '0;
        sub1 = 1'b0;

        valid_in2 = 1'b0;
        A2 = '0;
        B2 = '0;
        sub2 = 1'b0;

        repeat (2) @(posedge clk);
        rst = 1'b0;

        test(0, 0, 0, 0, 0, 0);
        test(127, 1, 0, 255, 0, 0);
        test(127, 127, 0, 255, 255, 0);
        test(-128, -128, 0, 200, 100, 0);
        test(-128, 127, 0, 1, 254, 0);
        test(1, -1, 0, 128, 128, 0);

        test(127, -128, 1, 255, 0, 1);
        test(-128, 127, 1, 255, 255, 1);
        test(127, 127, 1, 100, 200, 1);
        test(-128, -128, 1, 0, 255, 1);
        test(0, 0, 1, 128, 1, 1);
        test(1, -1, 1, 1, 1, 1);

        @(negedge clk);

        valid_in1 = 1'b0;
        valid_in2 = 1'b0;

        repeat (2) @(posedge clk);

        if (errors == 0) begin
            $display("");
            $display("================================");
            $display("SUM TEST PASSED");
            $display("All C model and RTL values match.");
            $display("================================");
        end
        else begin
            $display("");
            $display("================================");
            $display("SUM TEST FAILED");
            $display("Errors: %0d", errors);
            $display("================================");
        end

        $finish;
    end

endmodule