`timescale 1ns / 1ps


module neg_tb ();
    parameter WIDTH = 4;
    logic clk;
    logic [WIDTH-1:0] a;
    logic [WIDTH:0] result;

    neg #(.WIDTH(WIDTH)) dut (.*);

    always #1 clk = ~clk;

    initial begin
        integer i;
        clk = 1;
        for (i = 0; i < 2**WIDTH; i++) begin
            a = i;
            #2;
        end
        $finish;
    end
endmodule


