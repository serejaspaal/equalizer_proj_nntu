`timescale 1ns / 1ps


module neg #(
    parameter WIDTH = 4
)(
    input  logic               clk,
    input  logic signed [WIDTH-1:0] a,
    output logic signed [WIDTH:0] result
);
    logic signed [WIDTH:0] result_next;

    assign result_next = $signed({~a[WIDTH-1], ~a} + 1'sd1);
    
    always_ff @(posedge clk) begin
        result <= result_next;
    end
endmodule

