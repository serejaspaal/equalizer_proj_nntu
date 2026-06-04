`timescale 1ns / 1ps


module neg_tb ();
    parameter WIDTH = 6;
    logic clk;
    logic [WIDTH-1:0] a, result;

    neg #(.WIDTH(WIDTH)) dut (.*);

    always #1 clk = ~clk;

    initial begin
        integer i;
        clk = 1;
        for (i = 0; i < 2**WIDTH; i++) begin
            a = i;
            #2;
        end
    end
endmodule


