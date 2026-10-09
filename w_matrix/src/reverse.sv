`timescale 1ns / 1ps

module reverse #(
    parameter int DET_WIDTH     = 32,
    parameter int FRAC_WIDTH    = 8,
    parameter int USE_INTRP     = 1,
    parameter int INTRP_WIDTH   = 7,
    parameter int DET_INV_WIDTH = DET_WIDTH + USE_INTRP * INTRP_WIDTH + 1,
    parameter int IN_SIGNED     = 0,
    parameter int ROUNDED_WIDTH = 30,
    parameter int CLIP_WIDTH    = 0
)(
    input logic                 clk,
    input logic [DET_WIDTH-1:0] i_det_a,

    output logic [DET_INV_WIDTH-1:0] o_det_inv,
    output logic                     o_det_inv_inf,
    output logic [ROUNDED_WIDTH-1:0] o_det_inv_round,
    output logic                     o_sat_det_inv
);

    func_reverse #(
        .IN_WIDTH    (DET_WIDTH),
        .FRAC_WIDTH  (2*FRAC_WIDTH),
        .INTRP_WIDTH (INTRP_WIDTH),
        .USE_INTRP   (USE_INTRP)
    ) inst_func_reverse (
        .i_clk    (clk),
        .i_x      (i_det_a),
        .o_result (o_det_inv),
        .o_inf    (o_det_inv_inf)
    );

    round # (
        .IN_WIDTH   (DET_INV_WIDTH),
        .OUT_WIDTH  (ROUNDED_WIDTH),
        .IN_SIGNED  (IN_SIGNED),
        .CLIP_WIDTH (CLIP_WIDTH)
    ) inst_round (
        .clk    (clk),
        .i_data (o_det_inv),
        .o_data (o_det_inv_round),
        .o_sat  (o_sat_det_inv)
    );

endmodule
