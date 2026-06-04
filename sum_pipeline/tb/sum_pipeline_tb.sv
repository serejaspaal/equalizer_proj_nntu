`timescale 1ns / 1ps

module sum_pipeline_tb;

    localparam int AW = 4;
    localparam int BW = 8;
    localparam int MAXW = (AW > BW) ? AW : BW;
    localparam int OW   = MAXW + 1;
    localparam int LATENCY = 1;

    logic clk = 0;
    logic rst;
    logic valid_in;
    logic signed [AW-1:0] a;
    logic signed [BW-1:0] b;
    logic sub;
    logic valid_out;
    logic signed [OW-1:0] s;

    always #5 clk = ~clk;

    sum_pipeline #(
        .A_WIDTH(AW),
        .B_WIDTH(BW),
        .USE_DSP_VALUE("yes")
    ) dut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .A(a),
        .B(b),
        .sub(sub),
        .valid_out(valid_out),
        .S(s)
    );

    task automatic check(
        input string test_name,
        input logic signed [OW-1:0] expected_s,
        input bit expected_valid
    );
        if (s !== expected_s || valid_out !== expected_valid) begin
            $error("[%s] FAIL: expected S=%0d valid=%b, got S=%0d valid=%b",
                   test_name, expected_s, expected_valid, s, valid_out);
        end else begin
            $display("[%s] PASS: S=%0d, valid_out=%b", test_name, s, valid_out);
        end
    endtask

    initial begin
        $display("========================================");
        $display("   sum_pipeline testbench (LATENCY=%0d)", LATENCY);
        $display("========================================");

        rst <= 1;
        valid_in <= 0;
        a <= 0;
        b <= 0;
        sub <= 0;
        @(posedge clk);
        @(posedge clk);
        rst <= 0;

        // Test 1: 7 + 10 = 17
        a <= 4'sd7; b <= 8'sd10; sub <= 1'b0; valid_in <= 1'b1;
        @(posedge clk);

        // Test 2: -8 + (-5) = -13
        a <= -4'sd8; b <= -8'sd5; sub <= 1'b0; valid_in <= 1'b1;
        check("7+10", 17, 1'b1);
        @(posedge clk);

        // Test 3: 3 - 3 = 0
        a <= 4'sd3; b <= 8'sd3; sub <= 1'b1; valid_in <= 1'b1;
        check("-8+-5", -13, 1'b1);
        @(posedge clk);

        // Test 4: 0 + 127 = 127
        a <= 4'sd0; b <= 8'sd127; sub <= 1'b0; valid_in <= 1'b1;
        check("3-3", 0, 1'b1);
        @(posedge clk);

        // Test 5: -8 - 5 = -13
        a <= -4'sd8; b <= 8'sd5; sub <= 1'b1; valid_in <= 1'b1;
        check("0+127", 127, 1'b1);
        @(posedge clk);

        // Test 6: 7 + 127 = 134
        a <= 4'sd7; b <= 8'sd127; sub <= 1'b0; valid_in <= 1'b1;
        check("-8-5", -13, 1'b1);
        @(posedge clk);

        // Test 7: -8 + (-128) = -136
        a <= -4'sd8; b <= -8'sd128; sub <= 1'b0; valid_in <= 1'b1;
        check("7+127", 134, 1'b1);
        @(posedge clk);

        // Idle cycle
        a <= 4'sd0; b <= 8'sd0; sub <= 1'b0; valid_in <= 1'b0;
        check("-8-128", -136, 1'b1);
        @(posedge clk);

        repeat(2) @(posedge clk);

        $display("========================================");
        $display("         Simulation finished");
        $display("========================================");
        $finish;
    end

    initial begin
        $dumpfile("sum_pipeline.vcd");
        $dumpvars(0, sum_pipeline_tb);
    end

endmodule