`timescale 1ns / 1ps


module neg #(
    parameter WIDTH = 8
)(
    input  logic               clk,
    input  logic [WIDTH-1:0] a,
    output logic [WIDTH-1:0] result
);
    logic [WIDTH-1:0] result_next;

    assign result_next = ~a + 1'b1;

    always_ff @(posedge clk) begin
        result <= result_next;
    end
endmodule

