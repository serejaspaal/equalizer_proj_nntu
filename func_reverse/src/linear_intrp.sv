`timescale 1ns / 1ps

module linear_intrp #(
    parameter LUT_DW = 18,
    parameter N = 4
)(
    input  logic [LUT_DW-1:0]   i_a0,
    input  logic [LUT_DW-1:0]   i_a1,
    input  logic [N-1:0]        i_xf,
    output logic [LUT_DW+N-1:0] o_res
);
    always_comb begin
        logic [LUT_DW-1:0]   diff;
        logic [N+LUT_DW-1:0] corr;
        diff = i_a0 - i_a1;
        corr = i_xf * diff;
        o_res = {i_a0, {N{1'b0}}} - corr;
    end
endmodule