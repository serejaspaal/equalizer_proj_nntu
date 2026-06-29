`timescale 1ns / 1ps


module dline_tb ();
    parameter DATA_WIDTH = 4;
    parameter DELAY = 5;
    logic i_clk;
    logic [DATA_WIDTH-1:0] i_data;
    logic [DATA_WIDTH-1:0] o_data;

    dline #(.DATA_WIDTH(DATA_WIDTH), .DELAY(DELAY)) dut (.*);

    initial i_clk = 0;
    always #4 i_clk = ~i_clk;

    initial begin
        integer i;
        for (i = 0; i < 2**DATA_WIDTH; i++) begin
            @(posedge i_clk);
            i_data <= i;
        end
    end
    
endmodule


