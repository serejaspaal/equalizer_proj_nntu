`timescale 1ns / 1ps
module cmodule_tb;
    parameter int WIDTH = 8;
    logic        clk;
    logic        rst;
    logic        valid_in;
    logic signed [WIDTH-1:0] Re;
    logic signed [WIDTH-1:0] Im;
    logic        valid_out;
    logic unsigned [2*WIDTH-1:0] MagSq;
    cmodule #(
        .WIDTH         (WIDTH),
        .USE_DSP_VALUE ("yes")
    ) dut (
        .clk,
        .rst,
        .valid_in,
        .Re,
        .Im,
        .valid_out,
        .MagSq
    );
    initial clk = 0;
    always #5 clk = ~clk;
    logic unsigned [2*WIDTH-1:0] exp0, exp1;
    logic v0, v1;
    always_ff @(posedge clk) begin
        v0   <= valid_in;
        exp0 <= (Re * Re) + (Im * Im);
        v1   <= v0;
        exp1 <= exp0;
    end
    always @(posedge clk) begin
        #0; 
        if (v1 && valid_out) begin
            if (MagSq !== exp1)
                $error("FAIL at %0t: MagSq=%0d (expected %0d)", $time, MagSq, exp1);
            else
                $display("PASS at %0t: MagSq=%0d", $time, MagSq);
        end
    end
 
    initial begin
        $display("=== testbench ===");
        rst = 1; valid_in = 0; Re = 0; Im = 0;
        repeat(2) @(posedge clk);
        rst = 0;
        @(posedge clk); valid_in = 1; Re = 0;       Im = 0;       
        @(posedge clk); valid_in = 1; Re = 127;     Im = 0;       
        @(posedge clk); valid_in = 1; Re = -128;    Im = 0;       
        @(posedge clk); valid_in = 1; Re = 0;       Im = 127;
        @(posedge clk); valid_in = 1; Re = 0;       Im = -128;
        @(posedge clk); valid_in = 1; Re = 127;     Im = 127;     
        @(posedge clk); valid_in = 1; Re = -128;    Im = -128;    
        @(posedge clk); valid_in = 1; Re = 1;       Im = 1;      
        @(posedge clk); valid_in = 1; Re = -1;      Im = -1;      
        @(posedge clk); valid_in = 1; Re = 127;     Im = -128;    
        @(posedge clk); valid_in = 0; Re = 0;       Im = 0;       
        repeat(4) @(posedge clk);  
        $display("=== Done ===");
        $finish;
    end
endmodule