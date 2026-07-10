module cmult_matrix_on_real#(
    parameter int DET_WIDTH = 8,
    parameter int M_WIDTH = 8,
    localparam int CMULT_WIDTH = DET_WIDTH+M_WIDTH,
    parameter int ROUND_WIDTH = 8,
    parameter string USE_DSP_VALUE = "yes"
)(
    input logic clk,
    input logic [DET_WIDTH-1:0] det_inv,
    input logic signed [M_WIDTH-1:0] i_m11_re, i_m11_im,
    input logic signed [M_WIDTH-1:0] i_m12_re, i_m12_im,
    input logic signed [M_WIDTH-1:0] i_m21_re, i_m21_im,
    input logic signed [M_WIDTH-1:0] i_m22_re, i_m22_im,
    
    output logic signed [ROUND_WIDTH-1:0] o_w11_re, o_w11_im,
    output logic signed [ROUND_WIDTH-1:0] o_w12_re, o_w12_im,
    output logic signed [ROUND_WIDTH-1:0] o_w21_re, o_w21_im,
    output logic signed [ROUND_WIDTH-1:0] o_w22_re, o_w22_im,
    
    output logic o_sat_w11_re, o_sat_w11_im,
    output logic o_sat_w12_re, o_sat_w12_im,
    output logic o_sat_w21_re, o_sat_w21_im,
    output logic o_sat_w22_re, o_sat_w22_im
    );
    
    logic signed [CMULT_WIDTH-1:0] cmult_out[7:0];
    
    logic signed [ROUND_WIDTH-1:0] round_out_data[7:0];
    
    logic round_out_sat[7:0];
    
    // W11
    cmult_a_real #(
        .A_WIDTH(DET_WIDTH),
        .B_WIDTH(M_WIDTH),
        .A_SIGNED("no"),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) cmult_a_real_w11 (
        .clk(clk),
        .a(det_inv),
        .x1(i_m11_re),
        .y1(i_m11_im),
        .out_re(cmult_out[0]),
        .out_im(cmult_out[1])
    );
    //W11_re
    round #(
        .IN_WIDTH(CMULT_WIDTH),
        .OUT_WIDTH(ROUND_WIDTH),
        .IN_SIGNED("yes")
    ) round_w11_re (
        .clk(clk),
        .i_data(cmult_out[0]),
        .o_data(round_out_data[0]),
        .o_sat(round_out_sat[0])
    );
    //W11_im
    round #(
        .IN_WIDTH(CMULT_WIDTH),
        .OUT_WIDTH(ROUND_WIDTH),
        .IN_SIGNED("yes")
    ) round_w11_im (
        .clk(clk),
        .i_data(cmult_out[1]),
        .o_data(round_out_data[1]),
        .o_sat(round_out_sat[1])
    );
    
    // W12
    cmult_a_real #(
        .A_WIDTH(DET_WIDTH),
        .B_WIDTH(M_WIDTH),
        .A_SIGNED("no"),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) cmult_a_real_w12 (
        .clk(clk),
        .a(det_inv),
        .x1(i_m12_re),
        .y1(i_m12_im),
        .out_re(cmult_out[2]),
        .out_im(cmult_out[3])
    );
    //W12_re
    round #(
        .IN_WIDTH(CMULT_WIDTH),
        .OUT_WIDTH(ROUND_WIDTH),
        .IN_SIGNED("yes")
    ) round_w12_re (
        .clk(clk),
        .i_data(cmult_out[2]),
        .o_data(round_out_data[2]),
        .o_sat(round_out_sat[2])
    );
    //W12_im
    round #(
        .IN_WIDTH(CMULT_WIDTH),
        .OUT_WIDTH(ROUND_WIDTH),
        .IN_SIGNED("yes")
    ) round_w12_im (
        .clk(clk),
        .i_data(cmult_out[3]),
        .o_data(round_out_data[3]),
        .o_sat(round_out_sat[3])
    );
    
    // W21
    cmult_a_real #(
        .A_WIDTH(DET_WIDTH),
        .B_WIDTH(M_WIDTH),
        .A_SIGNED("no"),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) cmult_a_real_w21 (
        .clk(clk),
        .a(det_inv),
        .x1(i_m21_re),
        .y1(i_m21_im),
        .out_re(cmult_out[4]),
        .out_im(cmult_out[5])
    );
    //W21_re
    round #(
        .IN_WIDTH(CMULT_WIDTH),
        .OUT_WIDTH(ROUND_WIDTH),
        .IN_SIGNED("yes")
    ) round_w21_re (
        .clk(clk),
        .i_data(cmult_out[4]),
        .o_data(round_out_data[4]),
        .o_sat(round_out_sat[4])
    );
    //W21_im
    round #(
        .IN_WIDTH(CMULT_WIDTH),
        .OUT_WIDTH(ROUND_WIDTH),
        .IN_SIGNED("yes")
    ) round_w21_im (
        .clk(clk),
        .i_data(cmult_out[5]),
        .o_data(round_out_data[5]),
        .o_sat(round_out_sat[5])
    );
    
    // W22
    cmult_a_real #(
        .A_WIDTH(DET_WIDTH),
        .B_WIDTH(M_WIDTH),
        .A_SIGNED("no"),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) cmult_a_real_w22 (
        .clk(clk),
        .a(det_inv),
        .x1(i_m22_re),
        .y1(i_m22_im),
        .out_re(cmult_out[6]),
        .out_im(cmult_out[7])
    );
    //W22_re
    round #(
        .IN_WIDTH(CMULT_WIDTH),
        .OUT_WIDTH(ROUND_WIDTH),
        .IN_SIGNED("yes")
    ) round_w22_re (
        .clk(clk),
        .i_data(cmult_out[6]),
        .o_data(round_out_data[6]),
        .o_sat(round_out_sat[6])
    );
    //W22_im
    round #(
        .IN_WIDTH(CMULT_WIDTH),
        .OUT_WIDTH(ROUND_WIDTH),
        .IN_SIGNED("yes")
    ) round_w22_im (
        .clk(clk),
        .i_data(cmult_out[7]),
        .o_data(round_out_data[7]),
        .o_sat(round_out_sat[7])
    );
    
    always_ff @(posedge clk) begin
        o_w11_re <= round_out_data[0]; o_w11_im <= round_out_data[1];
        o_w12_re <= round_out_data[2]; o_w12_im <= round_out_data[3];
        o_w21_re <= round_out_data[4]; o_w21_im <= round_out_data[5];
        o_w22_re <= round_out_data[6]; o_w22_im <= round_out_data[7];

        o_sat_w11_re <= round_out_sat[0]; o_sat_w11_im <= round_out_sat[1];
        o_sat_w12_re <= round_out_sat[2]; o_sat_w12_im <= round_out_sat[3];
        o_sat_w21_re <= round_out_sat[4]; o_sat_w21_im <= round_out_sat[5];
        o_sat_w22_re <= round_out_sat[6]; o_sat_w22_im <= round_out_sat[7];
    end
endmodule
