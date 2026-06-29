`timescale 1ns / 1ps

module cmult_a_real_tb;

    parameter int A_WIDTH = 8;
    parameter int B_WIDTH = 8;

    logic clk;
    logic signed [A_WIDTH-1:0] a_s;
    logic [A_WIDTH-1:0] a_u;
    logic signed [B_WIDTH-1:0] x1, y1;
    logic signed [A_WIDTH+B_WIDTH-1:0] out_re_s, out_im_s;
    logic signed [A_WIDTH+B_WIDTH-1:0] out_re_u, out_im_u;

    cmult_a_real #(
        .A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH),
        .A_SIGNED("yes"), .USE_DSP_VALUE("yes")
    ) dut_signed (
        .clk(clk), .a(a_s), .x1(x1), .y1(y1),
        .out_re(out_re_s), .out_im(out_im_s)
    );

    cmult_a_real #(
        .A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH),
        .A_SIGNED("no"), .USE_DSP_VALUE("yes")
    ) dut_unsigned (
        .clk(clk), .a(a_u), .x1(x1), .y1(y1),
        .out_re(out_re_u), .out_im(out_im_u)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    int errors;
    logic signed [A_WIDTH+B_WIDTH-1:0] exp_re_s, exp_im_s;
    logic signed [A_WIDTH+B_WIDTH-1:0] exp_re_u, exp_im_u;

    always_ff @(posedge clk) begin
        exp_re_s <= $signed(a_s) * x1;
        exp_im_s <= $signed(a_s) * y1;
        exp_re_u <= $signed({1'b0, a_u}) * x1;
        exp_im_u <= $signed({1'b0, a_u}) * y1;
    end
    initial begin
        errors = 0;

        @(posedge clk);

        
        a_s = -128; a_u = 0; x1 = -128; y1 = -128; @(posedge clk);
        a_s = -128; a_u = 0; x1 = -128; y1 = 127;  @(posedge clk);

        if (out_re_s !== exp_re_s || out_im_s !== exp_im_s) begin
            $error("S1 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_s, out_im_s, exp_re_s, exp_im_s);
            errors++;
        end else $display("S1 PASS: (-128)*(-128-128i) = (%0d,%0d)", out_re_s, out_im_s);

        a_s = -128; a_u = 0; x1 = 127; y1 = -128; @(posedge clk);

        if (out_re_s !== exp_re_s || out_im_s !== exp_im_s) begin
            $error("S2 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_s, out_im_s, exp_re_s, exp_im_s);
            errors++;
        end else $display("S2 PASS: (-128)*(-128+127i) = (%0d,%0d)", out_re_s, out_im_s);

        a_s = -128; a_u = 0; x1 = 127; y1 = 127;  @(posedge clk);

        if (out_re_s !== exp_re_s || out_im_s !== exp_im_s) begin
            $error("S3 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_s, out_im_s, exp_re_s, exp_im_s);
            errors++;
        end else $display("S3 PASS: (-128)*(127-128i) = (%0d,%0d)", out_re_s, out_im_s);

        a_s = 127; a_u = 0; x1 = -128; y1 = -128; @(posedge clk);

        if (out_re_s !== exp_re_s || out_im_s !== exp_im_s) begin
            $error("S4 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_s, out_im_s, exp_re_s, exp_im_s);
            errors++;
        end else $display("S4 PASS: (-128)*(127+127i) = (%0d,%0d)", out_re_s, out_im_s);

        a_s = 127; a_u = 0; x1 = -128; y1 = 127;  @(posedge clk);

        if (out_re_s !== exp_re_s || out_im_s !== exp_im_s) begin
            $error("S5 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_s, out_im_s, exp_re_s, exp_im_s);
            errors++;
        end else $display("S5 PASS: (127)*(-128-128i) = (%0d,%0d)", out_re_s, out_im_s);

        a_s = 127; a_u = 0; x1 = 127; y1 = -128; @(posedge clk);

        if (out_re_s !== exp_re_s || out_im_s !== exp_im_s) begin
            $error("S6 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_s, out_im_s, exp_re_s, exp_im_s);
            errors++;
        end else $display("S6 PASS: (127)*(-128+127i) = (%0d,%0d)", out_re_s, out_im_s);

        a_s = 127; a_u = 0; x1 = 127; y1 = 127;  @(posedge clk);

        if (out_re_s !== exp_re_s || out_im_s !== exp_im_s) begin
            $error("S7 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_s, out_im_s, exp_re_s, exp_im_s);
            errors++;
        end else $display("S7 PASS: (127)*(127-128i) = (%0d,%0d)", out_re_s, out_im_s);

        a_s = 0; a_u = 0;   x1 = -128; y1 = -128; @(posedge clk);
        
	if (out_re_s !== exp_re_s || out_im_s !== exp_im_s) begin
            $error("S8 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_s, out_im_s, exp_re_s, exp_im_s);
            errors++;
        end else $display("S8 PASS: (127)*(127+127i) = (%0d,%0d)", out_re_s, out_im_s);
        
	a_s = 0; a_u = 0;   x1 = -128; y1 = 127;  @(posedge clk);
	
	if (out_re_u !== exp_re_u || out_im_u !== exp_im_u) begin
            $error("U1 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_u, out_im_u, exp_re_u, exp_im_u);
            errors++;
        end else $display("U1 PASS: 0*(-128-128i) = (%0d,%0d)", out_re_u, out_im_u);

        a_s = 0; a_u = 0;   x1 = 127; y1 = -128; @(posedge clk);

        if (out_re_u !== exp_re_u || out_im_u !== exp_im_u) begin
            $error("U2 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_u, out_im_u, exp_re_u, exp_im_u);
            errors++;
        end else $display("U2 PASS: 0*(-128+127i) = (%0d,%0d)", out_re_u, out_im_u);

        a_s = 0; a_u = 0;   x1 = 127; y1 = 127;  @(posedge clk);

        if (out_re_u !== exp_re_u || out_im_u !== exp_im_u) begin
            $error("U3 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_u, out_im_u, exp_re_u, exp_im_u);
            errors++;
        end else $display("U3 PASS: 0*(127-128i) = (%0d,%0d)", out_re_u, out_im_u);

        a_s = 0; a_u = 255; x1 = -128; y1 = -128; @(posedge clk);

        if (out_re_u !== exp_re_u || out_im_u !== exp_im_u) begin
            $error("U4 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_u, out_im_u, exp_re_u, exp_im_u);
            errors++;
        end else $display("U4 PASS: 0*(127+127i) = (%0d,%0d)", out_re_u, out_im_u);

        a_s = 0; a_u = 255; x1 = -128; y1 = 127; @(posedge clk);

        if (out_re_u !== exp_re_u || out_im_u !== exp_im_u) begin
            $error("U5 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_u, out_im_u, exp_re_u, exp_im_u);
            errors++;
        end else $display("U5 PASS: 255*(-128-128i) = (%0d,%0d)", out_re_u, out_im_u);

        a_s = 0; a_u = 255; x1 = 127; y1 = -128; @(posedge clk);

        if (out_re_u !== exp_re_u || out_im_u !== exp_im_u) begin
            $error("U6 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_u, out_im_u, exp_re_u, exp_im_u);
            errors++;
        end else $display("U6 PASS: 255*(-128+127i) = (%0d,%0d)", out_re_u, out_im_u);

        a_s = 0; a_u = 255; x1 = 127; y1 = 127; @(posedge clk);

        if (out_re_u !== exp_re_u || out_im_u !== exp_im_u) begin
            $error("U7 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_u, out_im_u, exp_re_u, exp_im_u);
            errors++;
        end else $display("U7 PASS: 255*(127-128i) = (%0d,%0d)", out_re_u, out_im_u);

        @(posedge clk);
        if (out_re_u !== exp_re_u || out_im_u !== exp_im_u) begin
            $error("U8 FAIL: got (%0d,%0d), expected (%0d,%0d)", out_re_u, out_im_u, exp_re_u, exp_im_u);
            errors++;
        end else $display("U8 PASS: 255*(127+127i) = (%0d,%0d)", out_re_u, out_im_u);

        #20;
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);
        $finish;
    end

endmodule