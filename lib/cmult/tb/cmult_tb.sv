`timescale 1ns / 1ps

import "DPI-C" function void cmult_ref(
    input  int A_WIDTH,
    input  int B_WIDTH,
    input  int x0, input int y0,
    input  int x1, input int y1,
    output int out_re, output int out_im
);

module cmult_tb;
    
    parameter int A_WIDTH = 8;
    parameter int B_WIDTH = 8;

    logic clk;
    logic signed [A_WIDTH-1:0] x0, y0;
    logic signed [B_WIDTH-1:0] x1, y1;
    logic signed [A_WIDTH+B_WIDTH:0] out_re, out_im;

    cmult #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .USE_DSP_VALUE(1)
    ) dut (.*);

    initial clk = 0;
    always #5 clk = ~clk;
    
    int errors;
    logic signed [A_WIDTH+B_WIDTH:0] ref_re, ref_im;
        
    typedef struct {
      logic signed [A_WIDTH+B_WIDTH:0] re;
      logic signed [A_WIDTH+B_WIDTH:0] im;
    } exp_t;
    exp_t exp_pipe [3];
    
    always_ff @(posedge clk) begin
        exp_pipe[0] <= '{re: ref_re, im: ref_im};
        for (int i = 1; i < 3; i++)
            exp_pipe[i] <= exp_pipe[i-1];
    end 
    
    task automatic check(string name, int ix0, int iy0, int ix1, int iy1);
        int c_re, c_im;
        cmult_ref(A_WIDTH, B_WIDTH, ix0, iy0, ix1, iy1, c_re, c_im);
        ref_re = c_re;
        ref_im = c_im;
    endtask
    
    task automatic compare(string name);
        if (out_re !== exp_pipe[2].re || out_im !== exp_pipe[2].im) begin
            $error("%s FAIL: DUT=(%0d,%0d) REF=(%0d,%0d) | in: x0=%0d y0=%0d x1=%0d y1=%0d",
                   name, out_re, out_im,
                   exp_pipe[2].re, exp_pipe[2].im,
                   x0, y0, x1, y1);
            errors++;
        end else begin
            $display("%s PASS: DUT=(%0d,%0d) REF=(%0d,%0d)",
                     name, out_re, out_im,
                     exp_pipe[2].re, exp_pipe[2].im);
        end
    endtask
    initial begin
        errors = 0;
        @(posedge clk);
        check("T1",  -128, -128, -128, -128);
        x0 = -128; y0 = -128; x1 = -128; y1 = -128; @(posedge clk);
        
        check("T2",  -128, -128, -128,  127);
        x0 = -128; y0 = -128; x1 = -128; y1 = 127;  @(posedge clk);
        
        check("T3",  -128, -128,  127, -128);
        x0 = -128; y0 = -128; x1 = 127;  y1 = -128; @(posedge clk);
        
        check("T4",  -128, -128,  127,  127);
        x0 = -128; y0 = -128; x1 = 127; y1 = 127; @(posedge clk);
        compare("T1");
        
        check("T5", -128, 127, -128, -128);
        x0 = -128; y0 = 127; x1 = -128; y1 = -128; @(posedge clk);
        compare("T2");
        
        check("T6", -128, 127, -128, 127);
        x0 = -128; y0 = 127; x1 = -128; y1 = 127; @(posedge clk);
        compare("T3");
        
        check("T7", -128, 127, 127, -128);
        x0 = -128; y0 = 127; x1 = 127; y1 = -128; @(posedge clk);
        compare("T4");
        
        check("T8", -128, 127, 127, 127);
        x0 = -128; y0 = 127; x1 = 127; y1 = 127; @(posedge clk);
        compare("T5");
        
        check("T9", 127, -128, -128, -128);
        x0 = 127; y0 = -128; x1 = -128; y1 = -128; @(posedge clk);
        compare("T6");

        check("T10", 127, -128, -128, 127);
        x0 = 127; y0 = -128; x1 = -128; y1 = 127; @(posedge clk);
        compare("T7");

        check("T11", 127, -128, 127, -128);
        x0 = 127; y0 = -128; x1 = 127; y1 = -128; @(posedge clk);
        compare("T8");

        check("T12", 127, -128, 127, 127);
        x0 = 127; y0 = -128; x1 = 127; y1 = 127; @(posedge clk);
        compare("T9");
        
        check("T13", 127, 127, -128, 127);
        x0 = 127; y0 = 127; x1 = -128; y1 = 127; @(posedge clk);
        compare("T10");
        
        check("T14", 127, 127, 127, -128);
        x0 = 127; y0 = 127; x1 = 127; y1 = -128; @(posedge clk);
        compare("T11");
        
        check("T15", 127, 127, 127, 127);
        x0 = 127; y0 = 127; x1 = 127; y1 = 127; @(posedge clk);
        compare("T12");@(posedge clk);
        compare("T13");@(posedge clk);
        compare("T14");@(posedge clk);
        compare("T15");

        #20;
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);
        $finish;
    end

endmodule