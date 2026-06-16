`timescale 1ns / 1ps

module cmult_a_real_tb;

    parameter int A_WIDTH = 8;
    parameter int B_WIDTH = 8;

    logic clk;
    logic [A_WIDTH-1:0] a;
    logic signed [B_WIDTH-1:0] x1, y1;
    logic signed [A_WIDTH+B_WIDTH-1:0] out_re_s, out_im_s;
    logic signed [A_WIDTH+B_WIDTH-1:0] out_re_u, out_im_u;

    cmult_a_real #(
        .A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH),
        .A_SIGNED("yes"), .USE_DSP_VALUE("yes")
    ) dut_signed (
        .clk(clk), .a(a), .x1(x1), .y1(y1),
        .out_re(out_re_s), .out_im(out_im_s)
    );

    cmult_a_real #(
        .A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH),
        .A_SIGNED("no"), .USE_DSP_VALUE("yes")
    ) dut_unsigned (
        .clk(clk), .a(a), .x1(x1), .y1(y1),
        .out_re(out_re_u), .out_im(out_im_u)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    int errors;

    initial begin
        errors = 0;

        @(posedge clk);

        
        a = $signed(3);    x1 = 4;   y1 = 5;   @(posedge clk);
        a = $signed(-5);   x1 = 2;   y1 = -3;  @(posedge clk);
        
        if (out_re_s !== 12 || out_im_s !== 15) begin
            $error("T1_s FAIL: got (%0d,%0d), expected (12,15)", out_re_s, out_im_s);
            errors++;
        end else $display("T1_s PASS: 3*(4+5i) = (12,15)");
        
        a = $signed(0);    x1 = 0;   y1 = 0;   @(posedge clk);
        
        if (out_re_s !== -10 || out_im_s !== 15) begin
            $error("T2_s FAIL: got (%0d,%0d), expected (-10,15)", out_re_s, out_im_s);
            errors++;
        end else $display("T2_s PASS: (-5)*(2-3i) = (-10,15)");
        
        a = $signed(127);  x1 = -1;  y1 = 127; @(posedge clk);
        
        if (out_re_s !== 0 || out_im_s !== 0) begin
            $error("T3_s FAIL: got (%0d,%0d), expected (0,0)", out_re_s, out_im_s);
            errors++;
        end else $display("T3_s PASS: 0*(0+0i) = (0,0)");
           
        a = $signed(-128); x1 = 127; y1 = -128;@(posedge clk);
        
        if (out_re_s !== -127 || out_im_s !== 16129) begin
            $error("T4_s FAIL: got (%0d,%0d), expected (-127,16129)", out_re_s, out_im_s);
            errors++;
        end else $display("T4_s PASS: 127*(-1+127i) = (-127,16129)");
        
        a = 3;   x1 = 4;   y1 = 5;   @(posedge clk);
        
        if (out_re_s !== -16256 || out_im_s !== 16384) begin
            $error("T5_s FAIL: got (%0d,%0d), expected (-16256,16384)", out_re_s, out_im_s);
            errors++;
        end else $display("T5_s PASS: (-128)*(127-128i) = (-16256,16384)");

        a = 255; x1 = 1;   y1 = -1;  @(posedge clk);
        
        if (out_re_u !== 12 || out_im_u !== 15) begin
            $error("T1_u FAIL: got (%0d,%0d), expected (12,15)", out_re_u, out_im_u);
            errors++;
        end else $display("T1_u PASS: 3*(4+5i) = (12,15)");
        
        a = 0;   x1 = 0;   y1 = 0;   @(posedge clk);
        
        if (out_re_u !== 255 || out_im_u !== -255) begin
            $error("T2_u FAIL: got (%0d,%0d), expected (255,-255)", out_re_u, out_im_u);
            errors++;
        end else $display("T2_u PASS: 255*(1-1i) = (255,-255)");

        a = 255; x1 = -128;y1 = 127; @(posedge clk);
        
        if (out_re_u !== 0 || out_im_u !== 0) begin
            $error("T3_u FAIL: got (%0d,%0d), expected (0,0)", out_re_u, out_im_u);
            errors++;
        end else $display("T3_u PASS: 0*(0+0i) = (0,0)");
        
        a = 200; x1 = 5;   y1 = -7;  @(posedge clk);
        
        if (out_re_u !== -32640 || out_im_u !== 32385) begin
            $error("T4_u FAIL: got (%0d,%0d), expected (-32640,32385)", out_re_u, out_im_u);
            errors++;
        end else $display("T4_u PASS: 255*(-128+127i) = (-32640,32385)");

        @(posedge clk);
        if (out_re_u !== 1000 || out_im_u !== -1400) begin
            $error("T5_u FAIL: got (%0d,%0d), expected (1000,-1400)", out_re_u, out_im_u);
            errors++;
        end else $display("T5_u PASS: 200*(5-7i) = (1000,-1400)");

        #20;
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);
        $finish;
    end

endmodule