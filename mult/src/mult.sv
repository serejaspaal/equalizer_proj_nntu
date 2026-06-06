`timescale 1ns / 1ps


module mult #(
    parameter A_WIDTH = 8,
    parameter B_WIDTH = 8,
    parameter string USE_DSP_VALUE = "yes"
    
)(
    input  logic clk,
    input  logic signed [A_WIDTH-1:0] a,
    input  logic signed [B_WIDTH-1:0] b,
    output logic signed [A_WIDTH+B_WIDTH-1:0] result
);
    (* use_dsp = USE_DSP_VALUE *)
    logic signed [A_WIDTH+B_WIDTH-1:0] result_next;
    
    assign result_next = a * b;

    always_ff @(posedge clk) begin
        result <= result_next;
    end
endmodule

