`timescale 1ns / 1ps


module neg_tb ();
    parameter WIDTH = 4;
    logic clk;
    logic [WIDTH-1:0] a;
    logic signed [WIDTH:0] result, expected;

    neg #(.WIDTH(WIDTH)) dut (.*);

    initial clk = 0;
    always #4 clk = ~clk;
        
    integer errors;

    initial begin
      
        integer i;
        
        errors = 0;
        for (i = 0; i < 2**WIDTH; i++) begin
            @(posedge clk);
            a <= i;
            expected <= -$signed(a);
            if (result != expected) begin
                $display("FAIL: a=%sd (%sb) -> result=%sd (%sb), expected=%sd (%sb)", $signed(a), a, $signed(result), result, $signed(expected), expected);
                errors++;
            end
        end
        @(posedge clk);
        expected <= -$signed(a);
            if (result != expected) begin
                $display("FAIL: a=%sd (%sb) -> result=%sd (%sb), expected=%sd (%sb)", $signed(a), a, $signed(result), result, $signed(expected), expected);
                errors++;
            end
        if (errors == 0)
            $display("TESTS PASSED");
        else
            $display("TESTS FAILED: %0d errors", errors);
        #15;
    end
endmodule


