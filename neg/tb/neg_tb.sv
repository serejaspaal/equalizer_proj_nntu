`timescale 1ns / 1ps


module neg_tb ();
    parameter WIDTH = 4;
    logic clk;
    logic [WIDTH-1:0] a;
    logic [WIDTH:0] result;

    neg #(.WIDTH(WIDTH)) dut (.*);

    initial clk = 0;
    always #4 clk = ~clk;

    initial begin
        integer i;
        for (i = 0; i < 2**WIDTH; i++) begin
            @(posedge clk);
            a <= i;
            #1;
        end
        #15;
        $finish;
    end
endmodule


