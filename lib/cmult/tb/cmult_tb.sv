`timescale 1ns / 1ps

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
    logic signed [A_WIDTH+B_WIDTH:0] exp_re, exp_im;
    
    assign exp_re = x0 * x1 - y0 * y1;
    assign exp_im = x0 * y1 + x1 * y0;
    
    typedef struct {
      logic [A_WIDTH+B_WIDTH:0] re;
      logic [A_WIDTH+B_WIDTH:0] im;
    } exp_t;
    exp_t exp_pipe [3];
    always_ff @(posedge clk) begin
        exp_pipe[0] <= '{re: exp_re, im: exp_im};
        for (int i = 1; i < 3; i++)
            exp_pipe[i] <= exp_pipe[i-1];
    end 
    
    task automatic check(string name, int ix0, int iy0, int ix1, int iy1);
        if (out_re !== exp_pipe[2].re || out_im !== exp_pipe[2].im) begin
            $error("%s FAIL: got (%0d,%0d), expected (%0d,%0d)",
                   name, out_re, out_im, exp_pipe[2].re, exp_pipe[2].im);
            errors++;
        end else
            $display("%s PASS: conj(%0d+%0di)*conj(%0d+%0di) = (%0d,%0d)",
                     name, ix0, iy0, ix1, iy1, out_re, out_im);
    endtask
    initial begin
        errors = 0;
        @(posedge clk);
        x0 = -128; y0 = -128; x1 = -128; y1 = -128; @(posedge clk);
        x0 = -128; y0 = -128; x1 = -128; y1 = 127;  @(posedge clk);
        x0 = -128; y0 = -128; x1 = 127;  y1 = -128; @(posedge clk);
        

        x0 = -128; y0 = -128; x1 = 127; y1 = 127; @(posedge clk);
        check("T1", -128, -128, -128, -128);

        x0 = -128; y0 = 127; x1 = -128; y1 = -128; @(posedge clk);
        check("T2", -128, -128, -128, 127);


        x0 = -128; y0 = 127; x1 = -128; y1 = 127; @(posedge clk);
        check("T3", -128, -128, 127, -128);


        x0 = -128; y0 = 127; x1 = 127; y1 = -128; @(posedge clk);
        check("T4", -128, -128, 127, 127);


        x0 = -128; y0 = 127; x1 = 127; y1 = 127; @(posedge clk);
        check("T5", -128, 127, -128, -128);

        x0 = 127; y0 = -128; x1 = -128; y1 = -128; @(posedge clk);
        check("T6", -128, 127, -128, 127);

        x0 = 127; y0 = -128; x1 = -128; y1 = 127; @(posedge clk);
        check("T7", -128, 127, 127, -128);

        x0 = 127; y0 = -128; x1 = 127; y1 = -128; @(posedge clk);
        check("T8", -128, 127, 127, 127);

        x0 = 127; y0 = -128; x1 = 127; y1 = 127; @(posedge clk);
        check("T9", 127, -128, -128, -128);

        x0 = 127; y0 = 127; x1 = -128; y1 = 127; @(posedge clk);
        check("T10", 127, -128, -128, 127);

        x0 = 127; y0 = 127; x1 = 127; y1 = -128; @(posedge clk);
        check("T11", 127, -128, 127, -128);

        x0 = 127; y0 = 127; x1 = 127; y1 = 127; @(posedge clk);
        check("T12", 127, -128, 127, 127);@(posedge clk);
        check("T13", 127, 127, -128, 127);@(posedge clk);
        check("T14", 127, 127, 127, -128);@(posedge clk);
        check("T15", 127, 127, 127, 127);

        #20;
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);
        $finish;
    end

endmodule
