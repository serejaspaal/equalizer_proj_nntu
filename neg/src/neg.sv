`timescale 1ns / 1ps


module neg #(
    parameter WIDTH = 4
)(
    input  logic               clk,
    input  logic signed [WIDTH-1:0] a,
    output logic signed [WIDTH:0] result
);
    logic signed [WIDTH:0] result_next;
    logic signed [WIDTH-1:0] neg_a, adder;

    assign neg_a = ~a;
    assign adder = WIDTH'(1);
    
    assign result_next = neg_a + adder;
    
    always_ff @(posedge clk) begin
        result <= result_next;
    end
endmodule

