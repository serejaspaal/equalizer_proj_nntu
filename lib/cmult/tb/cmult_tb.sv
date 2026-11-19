`timescale 1ns / 1ps

import "DPI-C" function void cmult(
    input longint x0, input longint y0,
    input longint x1, input longint y1,
    output longint out_re, output longint out_im
);

module cmult_tb;
    
    parameter int A_WIDTH = 16;
    parameter int B_WIDTH = 16;

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
    
    task automatic check(string name, longint ix0, longint iy0, longint ix1, longint iy1);
        longint c_re, c_im;
        cmult(ix0, iy0, ix1, iy1, c_re, c_im);
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
        check("T1",  -32768, -32768, -32768, -32768);
        x0 = -32768; y0 = -32768; x1 = -32768; y1 = -32768; @(posedge clk);
        
        check("T2",  -32768, -32768, -32768,  32767);
        x0 = -32768; y0 = -32768; x1 = -32768; y1 = 32767;  @(posedge clk);
        
        check("T3",  -32768, -32768,  32767, -32768);
        x0 = -32768; y0 = -32768; x1 = 32767;  y1 = -32768; @(posedge clk);
        
        check("T4",  -32768, -32768,  32767,  32767);
        x0 = -32768; y0 = -32768; x1 = 32767; y1 = 32767; @(posedge clk);
        compare("T1");
        
        check("T5", -32768, 32767, -32768, -32768);
        x0 = -32768; y0 = 32767; x1 = -32768; y1 = -32768; @(posedge clk);
        compare("T2");
        
        check("T6", -32768, 32767, -32768, 32767);
        x0 = -32768; y0 = 32767; x1 = -32768; y1 = 32767; @(posedge clk);
        compare("T3");
        
        check("T7", -32768, 32767, 32767, -32768);
        x0 = -32768; y0 = 32767; x1 = 32767; y1 = -32768; @(posedge clk);
        compare("T4");
        
        check("T8", -32768, 32767, 32767, 32767);
        x0 = -32768; y0 = 32767; x1 = 32767; y1 = 32767; @(posedge clk);
        compare("T5");
        
        check("T9", 32767, -32768, -32768, -32768);
        x0 = 32767; y0 = -32768; x1 = -32768; y1 = -32768; @(posedge clk);
        compare("T6");

        check("T10", 32767, -32768, -32768, 32767);
        x0 = 32767; y0 = -32768; x1 = -32768; y1 = 32767; @(posedge clk);
        compare("T7");

        check("T11", 32767, -32768, 32767, -32768);
        x0 = 32767; y0 = -32768; x1 = 32767; y1 = -32768; @(posedge clk);
        compare("T8");

        check("T12", 32767, -32768, 32767, 32767);
        x0 = 32767; y0 = -32768; x1 = 32767; y1 = 32767; @(posedge clk);
        compare("T9");
        
        check("T13", 32767, 32767, -32768, 32767);
        x0 = 32767; y0 = 32767; x1 = -32768; y1 = 32767; @(posedge clk);
        compare("T10");
        
        check("T14", 32767, 32767, 32767, -32768);
        x0 = 32767; y0 = 32767; x1 = 32767; y1 = -32768; @(posedge clk);
        compare("T11");
        
        check("T15", 32767, 32767, 32767, 32767);
        x0 = 32767; y0 = 32767; x1 = 32767; y1 = 32767; @(posedge clk);
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