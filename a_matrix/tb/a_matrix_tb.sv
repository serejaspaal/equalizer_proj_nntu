`timescale 1ns / 1ps

import "DPI-C" function void set_disp(input int idx);
import "DPI-C" function void next_sample(
    output real h11_re, h11_im,
    output real h12_re, h12_im,
    output real h21_re, h21_im,
    output real h22_re, h22_im,
    output real c11, c22
    );

module a_matrix_tb;

    parameter int H_WIDTH = 16;
    parameter int C_WIDTH = 16;
    parameter int A_WIDTH = 2*H_WIDTH + 2;
    parameter int POINT_POS = 8;
    parameter int USE_DSP_VALUE = 1;
    
    logic clk, rst, i_stb, o_stb;
    
    logic signed [H_WIDTH-1:0] i_h11_re, i_h11_im;
    logic signed [H_WIDTH-1:0] i_h12_re, i_h12_im;
    logic signed [H_WIDTH-1:0] i_h21_re, i_h21_im;
    logic signed [H_WIDTH-1:0] i_h22_re, i_h22_im;
    
    logic [C_WIDTH-1:0] i_c11, i_c22;
    
    logic [A_WIDTH-1:0] o_a11, o_a22;
    logic signed [A_WIDTH-1:0] o_a12_re, o_a12_im;
    logic o_sat_a11, o_sat_a22, o_sat_a12_re, o_sat_a12_im;
    
    localparam real H_SCALE = 2**POINT_POS;
    localparam real C_SCALE = 2**POINT_POS;
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    a_matrix #(
        .H_WIDTH(H_WIDTH),
        .C_WIDTH(C_WIDTH),
        .A_WIDTH(A_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .i_stb(i_stb),
        
        .i_h11_re(i_h11_re), .i_h11_im(i_h11_im),
        .i_h12_re(i_h12_re), .i_h12_im(i_h12_im),
        .i_h21_re(i_h21_re), .i_h21_im(i_h21_im),
        .i_h22_re(i_h22_re), .i_h22_im(i_h22_im),

        .i_c11(i_c11), .i_c22(i_c22),

        .o_stb(o_stb),
        .o_a11(o_a11), .o_a22(o_a22),
        .o_a12_re(o_a12_re), .o_a12_im(o_a12_im),
        .o_sat_a11(o_sat_a11), .o_sat_a22(o_sat_a22),
        .o_sat_a12_re(o_sat_a12_re), .o_sat_a12_im(o_sat_a12_im)
    );
    
    real rh11r,rh11i,rh12r,rh12i,rh21r,rh21i,rh22r,rh22i, rc11,rc22;
    
    initial begin
        set_disp(3);
        
        rst = 1'b1;
        i_stb = 1'b0;
        
        i_h11_re='0; i_h11_im='0; 
        i_h12_re='0; i_h12_im='0;
        i_h21_re='0; i_h21_im='0; 
        i_h22_re='0; i_h22_im='0;
        i_c11='0; i_c22='0;
        
        repeat(10) @(posedge clk);
        rst = 1'b0;
        repeat(2) @(posedge clk);
        
        forever begin
            @(posedge clk);
            next_sample(rh11r,rh11i,rh12r,rh12i,rh21r,rh21i,rh22r,rh22i, rc11,rc22);
            
            i_h11_re <= H_WIDTH'($rtoi(rh11r * H_SCALE));
            i_h11_im <= H_WIDTH'($rtoi(rh11i * H_SCALE));
            i_h12_re <= H_WIDTH'($rtoi(rh12r * H_SCALE));
            i_h12_im <= H_WIDTH'($rtoi(rh12i * H_SCALE));
            i_h21_re <= H_WIDTH'($rtoi(rh21r * H_SCALE));
            i_h21_im <= H_WIDTH'($rtoi(rh21i * H_SCALE));
            i_h22_re <= H_WIDTH'($rtoi(rh22r * H_SCALE));
            i_h22_im <= H_WIDTH'($rtoi(rh22i * H_SCALE));
            
            i_c11 <= C_WIDTH'($rtoi(rc11 * C_SCALE));
            i_c22 <= C_WIDTH'($rtoi(rc22 * C_SCALE));
            
            i_stb <= 1'b1;
        end
    end
    
    initial begin
        #5000ns;
        $finish;
    end
endmodule
