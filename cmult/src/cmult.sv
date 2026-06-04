`timescale 1ns / 1ps

module cmult #(
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

    logic signed [A_WIDTH-1:0] x0_reg, y0_reg;
    logic signed [B_WIDTH-1:0] x1_reg, y1_reg;

    always_ff @(posedge clk) begin
        x0_reg <= x0;
        y0_reg <= y0;
        x1_reg <= x1;
        y1_reg <= y1;
    end

    (* use_dsp = USE_DSP_VALUE *)
    logic signed [A_WIDTH+B_WIDTH-1:0] p1;
    (* use_dsp = USE_DSP_VALUE *)
    logic signed [A_WIDTH+B_WIDTH-1:0] p2;
    (* use_dsp = USE_DSP_VALUE *)
    logic signed [A_WIDTH+B_WIDTH+1:0] p3;

    always_ff @(posedge clk) begin
        p1 <= x0_reg*x1_reg;
        p2 <= y0_reg*y1_reg;
        p3 <= (x0_reg+y0_reg)*(x1_reg+y1_reg);
    end

    always_ff @(posedge clk) begin
        out_re <= p1 - p2;
        out_im <= p3 - p1 - p2;
    end
endmodule
