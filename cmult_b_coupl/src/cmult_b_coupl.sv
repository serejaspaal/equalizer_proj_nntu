`timescale 1ns / 1ps

module cmult_b_coupl #(
    parameter int A_WIDTH = 4,
    parameter int B_WIDTH = 6,
    parameter string USE_DSP_VALUE = "yes"
)(
    input logic clk,
    input logic signed [A_WIDTH-1:0] x0,
    input logic signed [A_WIDTH-1:0] y0,
    input logic signed [B_WIDTH-1:0] x1,
    input logic signed [B_WIDTH-1:0] y1,
    output logic signed [A_WIDTH+B_WIDTH:0] out_re,
    output logic signed [A_WIDTH+B_WIDTH:0] out_im
    );
    (* use_dsp = USE_DSP_VALUE *)
    logic signed [A_WIDTH:0] sum_a;
    (* use_dsp = USE_DSP_VALUE *)
    logic signed [B_WIDTH:0] dif_b;
        
    (* use_dsp = USE_DSP_VALUE *)
    logic signed [A_WIDTH+B_WIDTH-1:0] p1;
    (* use_dsp = USE_DSP_VALUE *)
    logic signed [A_WIDTH+B_WIDTH-1:0] p2;
    (* use_dsp = USE_DSP_VALUE *)
    logic signed [A_WIDTH+B_WIDTH+1:0] p3;
    
    logic signed [A_WIDTH+B_WIDTH-1:0] p1_reg;
    logic signed [A_WIDTH+B_WIDTH-1:0] p2_reg;
    
    always_ff @(posedge clk) begin
        sum_a <= x0+y0;
        dif_b <= x1-y1;
        p1 <= x0*x1;
        p2 <= y0*y1;
    end
    
    always_ff @(posedge clk) begin
        p1_reg <= p1;
        p2_reg <= p2;
        p3 <= (sum_a)*(dif_b);
    end
    
    always_ff @(posedge clk) begin
        out_re <= p1_reg + p2_reg;
        out_im <= p3 - p1_reg + p2_reg;
    end
endmodule
