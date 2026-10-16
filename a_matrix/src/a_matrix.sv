`timescale 1ns / 1ps
module a_matrix #(
    parameter int H_WIDTH = 8,
    parameter int C_WIDTH = 8,
    parameter int A_WIDTH = 2*H_WIDTH + 2,
    parameter int USE_DSP_VALUE = 1    
)(
    input logic clk,
    input logic rst,
    input logic i_stb,
    
    input logic signed [H_WIDTH-1:0] i_h11_re, i_h11_im,
    input logic signed [H_WIDTH-1:0] i_h12_re, i_h12_im,
    input logic signed [H_WIDTH-1:0] i_h21_re, i_h21_im,
    input logic signed [H_WIDTH-1:0] i_h22_re, i_h22_im,
    
    input logic [C_WIDTH-1:0] i_c11, i_c22,
    
    output logic o_stb,
    
    output logic [A_WIDTH-1:0] o_a11, o_a22,
    output logic signed [A_WIDTH-1:0] o_a12_re, o_a12_im,
    
    output logic o_sat_a11, o_sat_a22, o_sat_a12_re, o_sat_a12_im
    );
    
    logic valid_main, valid_side;
    
    a_main_diag #(
        .H_WIDTH(H_WIDTH), 
        .C_WIDTH(C_WIDTH), 
        .A_WIDTH(A_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
        ) inst_a_main_diag (
            .clk(clk),
            .rst(rst),
            .valid_in(i_stb),
           
            .i_h11_re(i_h11_re), .i_h11_im(i_h11_im),
            .i_h12_re(i_h12_re), .i_h12_im(i_h12_im),
            .i_h21_re(i_h21_re), .i_h21_im(i_h21_im),
            .i_h22_re(i_h22_re), .i_h22_im(i_h22_im),
           
            .i_c11(i_c11), .i_c22(i_c22),
          
            .o_a11(o_a11),
            .o_a22(o_a22),
            
           
            .o_sat_a11(o_sat_a11),
            .o_sat_a22(o_sat_a22),
            
            .valid_out(valid_main)
        );
    a_side_diag #(
        .H_WIDTH(H_WIDTH),
        .A_WIDTH(A_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
        ) inst_a_side_diag (
            .clk(clk),
            .rst(rst),
            .valid_in(i_stb),
            
            .i_h11_re(i_h11_re), .i_h11_im(i_h11_im),
            .i_h12_re(i_h12_re), .i_h12_im(i_h12_im),
            .i_h21_re(i_h21_re), .i_h21_im(i_h21_im),
            .i_h22_re(i_h22_re), .i_h22_im(i_h22_im),
            
            .o_a12_re(o_a12_re),
            .o_a12_im(o_a12_im),
            
            .o_sat_a12_re(o_sat_a12_re),
            .o_sat_a12_im(o_sat_a12_im),
            
            .valid_out(valid_side)
        );
        
        assign o_stb = valid_main & valid_side;
endmodule
