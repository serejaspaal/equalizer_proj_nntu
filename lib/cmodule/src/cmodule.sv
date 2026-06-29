`timescale 1ns / 1ps
module cmodule #(
    parameter int    WIDTH         = 8,
    parameter string USE_DSP_VALUE = "yes"
)(
    input  logic clk,
    input  logic rst,
    input  logic valid_in,
    input  logic signed   [WIDTH-1:0]   Re,
    input  logic signed   [WIDTH-1:0]   Im,
    output logic valid_out,
    output logic unsigned [2*WIDTH-1:0] MagSq
);
    // Stage 0
    (* USE_DSP = USE_DSP_VALUE *) logic unsigned [2*WIDTH-1:0] re_sq_comb;
    (* USE_DSP = USE_DSP_VALUE *) logic unsigned [2*WIDTH-1:0] im_sq_comb;
    always_comb begin
        re_sq_comb = Re * Re;
        im_sq_comb = Im * Im;
    end
    // Stage 1
    logic unsigned [2*WIDTH-1:0] re_sq;
    logic unsigned [2*WIDTH-1:0] im_sq;
    logic valid_pipe;
    always_ff @(posedge clk) begin
        if (rst) begin
            re_sq      <= '0;
            im_sq      <= '0;
            valid_pipe <= '0;
        end else begin
            re_sq      <= re_sq_comb;
            im_sq      <= im_sq_comb;
            valid_pipe <= valid_in;
        end
    end
    // Stage 2
    (* USE_DSP = USE_DSP_VALUE *) logic unsigned [2*WIDTH-1:0] sum_comb;
    always_comb begin
        sum_comb = re_sq + im_sq;
    end
    // Stage 3
    always_ff @(posedge clk) begin
        if (rst) begin
            MagSq     <= '0;
            valid_out <= '0;
        end else begin
            MagSq     <= sum_comb;
            valid_out <= valid_pipe;
        end
    end
endmodule