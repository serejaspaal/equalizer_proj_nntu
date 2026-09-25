`timescale 1ns / 1ps

module a_main_diag #(
    parameter int H_WIDTH = 8,
    parameter int C_WIDTH = 8,
    parameter int A_WIDTH = 8,
    parameter int USE_DSP_VALUE = 1    
)(
    input logic clk,
    input logic rst,
    input logic valid_in,
    
    input logic signed [H_WIDTH-1:0] i_h11_re, i_h11_im,
    input logic signed [H_WIDTH-1:0] i_h12_re, i_h12_im,
    input logic signed [H_WIDTH-1:0] i_h21_re, i_h21_im,
    input logic signed [H_WIDTH-1:0] i_h22_re, i_h22_im,
    
    input logic [C_WIDTH-1:0] i_c11, i_c22,
    
    output logic [A_WIDTH-1:0] o_a11, o_a22,
    output logic o_sat_a11, o_sat_a22,
    
    output logic valid_out
    );
    
    localparam int CMAG_WIDTH = 2*H_WIDTH;
    localparam int S1_WIDTH = CMAG_WIDTH + 1;
    localparam int S2_WIDTH = (S1_WIDTH > C_WIDTH) ? S1_WIDTH : C_WIDTH;
    localparam int ROUND_IN = S2_WIDTH + 1;
    
    logic valid_cm [1:0], valid_s1 [1:0], valid_s2 [1:0];
    
    logic unsigned [CMAG_WIDTH-1:0] cmag_out [3:0];
    logic [S1_WIDTH-1:0] s1_out [1:0];
    logic [ROUND_IN-1:0] s2_out [1:0];
    logic [A_WIDTH-1:0] a_out [1:0];
    logic sat_out [1:0];
    
    genvar i;
    generate
        for (i=0;i<2;i++) begin : gen_lane
            cmodule #(
                .WIDTH(H_WIDTH),
                .USE_DSP_VALUE(USE_DSP_VALUE)
            ) inst_cmodule1 (
                .clk(clk),
                .rst(rst),
                .valid_in(valid_in),
                .Re(i == 0 ? i_h11_re : i_h21_re),
                .Im(i == 0 ? i_h11_im : i_h21_im),
                .valid_out(valid_cm[i]),
                .MagSq(cmag_out[i*2])
            );
            
            cmodule #(
                .WIDTH(H_WIDTH),
                .USE_DSP_VALUE(USE_DSP_VALUE)
            ) inst_cmodule2 (
                .clk(clk),
                .rst(rst),
                .valid_in(valid_in),
                .Re(i == 0 ? i_h12_re : i_h22_re),
                .Im(i == 0 ? i_h12_im : i_h22_im),
                .valid_out(),
                .MagSq(cmag_out[i*2+1])
            );
            
            sum #(
                .A_WIDTH(CMAG_WIDTH),
                .B_WIDTH(CMAG_WIDTH),
                .SIGNED_OPERANDS(0)
            ) inst_sum1 (
                .clk(clk),
                .rst(rst),
                .valid_in(valid_cm[i]),
                .A(cmag_out[i*2]),
                .B(cmag_out[i*2+1]),
                .sub(1'b0),
                .valid_out(valid_s1[i]),
                .S(s1_out[i]),
                .underflow()
            );
            
            sum #(
                .A_WIDTH(S1_WIDTH),
                .B_WIDTH(C_WIDTH),
                .SIGNED_OPERANDS(0)
            ) inst_sum2 (
                .clk(clk),
                .rst(rst),
                .valid_in(valid_s1[i]),
                .A(s1_out[i]),
                .B(i == 0 ? i_c11 : i_c22),
                .sub(1'b0),
                .valid_out(valid_s2[i]),
                .S(s2_out[i]),
                .underflow()
            );
            
            round #(
                .IN_WIDTH(ROUND_IN),
                .OUT_WIDTH(A_WIDTH),
                .IN_SIGNED(0)
            ) inst_round (
                .clk(clk),
                .i_data(s2_out[i]),
                .o_data(a_out[i]),
                .o_sat(sat_out[i])
            );
        end
    endgenerate
    
    logic valid_r;
    always_ff @(posedge clk) begin
        if (rst) valid_r <= 1'b0;
        else valid_r <= valid_s2[0];
    end
    
    assign valid_out = valid_r;
    
    always_comb begin
        o_a11 = a_out[0];
        o_a22 = a_out[1];
        o_sat_a11 = sat_out[0];
        o_sat_a22 = sat_out[1];
    end
endmodule
