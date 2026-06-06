`timescale 1ns / 1ps



module mult_tb ();
    parameter A_WIDTH = 4;
    parameter B_WIDTH = 4;
    logic clk;
    logic [A_WIDTH-1:0] a;
    logic [B_WIDTH-1:0] b;
    logic [A_WIDTH+B_WIDTH-1:0] result;

    mult #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH)) dut (.*);

    initial clk = 0;
    always #2 clk = ~clk;

    initial begin
        integer ai, bi;
        for (ai = 0; ai < 2**A_WIDTH; ai++) begin
            for (bi = 0; bi < 2**B_WIDTH; bi++) begin
                @(posedge clk);
                a <= ai;
                b <= bi;
                #1;
            end
        end
        #7;
        $finish;
    end

endmodule

