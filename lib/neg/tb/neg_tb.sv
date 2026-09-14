`timescale 1ns / 1ps

import "DPI-C" function int neg(input int a);

module neg_tb;

    localparam int WIDTH = 4;

    logic clk;
    logic signed [WIDTH-1:0] a;
    logic signed [WIDTH:0] result;

    int expected;
    int error_count;

    neg #(
        .WIDTH(WIDTH)
    ) dut (
        .clk    (clk),
        .a      (a),
        .result (result)
    );

    initial begin
        clk = 1'b0;
        forever #4 clk = ~clk;
    end

    initial begin
        error_count = 0;
        a = '0;
        expected = 0;

        for (int value = -(2**(WIDTH-1));
                     value < 2**(WIDTH-1);
                     value++) begin

            @(negedge clk);

            a = value;
            expected = neg(value);

            @(posedge clk);
            #1;

            if ($signed(result) != expected) begin

                $display(
                    "ERROR: a = %0d (%b), RTL = %0d (%b), C = %0d (%b)",
                    $signed(a),
                    a,
                    $signed(result),
                    result,
                    expected,
                    expected
                );

                error_count++;
            end
            else begin

                $display(
                    "OK: a = %0d (%b), result = %0d (%b)",
                    $signed(a),
                    a,
                    $signed(result),
                    result
                );

            end
        end

        $display("");

        if (error_count == 0) begin
            $display("================================");
            $display("NEG TEST PASSED");
            $display("All values match C reference.");
            $display("================================");
        end
        else begin
            $display("================================");
            $display("NEG TEST FAILED");
            $display("Errors: %0d", error_count);
            $display("================================");
        end

        #10;
        $finish;
    end

endmodule