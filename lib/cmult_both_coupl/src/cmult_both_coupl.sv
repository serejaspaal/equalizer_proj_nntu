`timescale 1ns / 1ps

module cmult_both_coupl #(
    parameter int A_WIDTH = 4,
    parameter int B_WIDTH = 6,
    parameter int USE_DSP_VALUE = 1
)(
    input logic clk,
    input logic signed [A_WIDTH-1:0] x0,
    input logic signed [A_WIDTH-1:0] y0,
    input logic signed [B_WIDTH-1:0] x1,
    input logic signed [B_WIDTH-1:0] y1,
    output logic signed [A_WIDTH+B_WIDTH:0] out_re,
    output logic signed [A_WIDTH+B_WIDTH:0] out_im
    );
    logic signed [A_WIDTH-1:0] x0_d;
    logic signed [A_WIDTH-1:0] y0_d;
    logic signed [B_WIDTH-1:0] x1_d;
    logic signed [B_WIDTH-1:0] y1_d;
    (* use_dsp = USE_DSP_VALUE ? "yes" : "no"*)
    logic signed [A_WIDTH+B_WIDTH:0] common, multr, multi;
    
    always_ff @(posedge clk) begin
        x0_d <= x0;
        y0_d <= y0;
        x1_d <= x1;
        y1_d <= y1;
    end
       
    always_ff @(posedge clk) begin
        common <= (x0+y0)*y1;
        multr <= (x1+y1)*x0;
        multi <= (y1-x1)*y0;
    end
    
    always_ff @(posedge clk) begin
        out_re <= multr - common;
        out_im <= multi - common;
    end
endmodule
