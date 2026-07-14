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
    
    logic signed [M_WIDTH-1:0] i_m_re[4], i_m_im[4];
    assign i_m_re[0] = i_m11_re; assign i_m_im[0] = i_m11_im;
    assign i_m_re[1] = i_m12_re; assign i_m_im[1] = i_m12_im;
    assign i_m_re[2] = i_m21_re; assign i_m_im[2] = i_m21_im;
    assign i_m_re[3] = i_m22_re; assign i_m_im[3] = i_m22_im;
    
    genvar i;
    generate
        for (i=0;i<4;i++) begin : gen_w
            cmult_a_real #(
                .A_WIDTH(DET_WIDTH),
                .B_WIDTH(M_WIDTH),
                .A_SIGNED("no"),
                .USE_DSP_VALUE(USE_DSP_VALUE)
            ) cmult_a_real_w11 (
                .clk(clk),
                .a(det_inv),
                .x1(i_m_re[i]),
                .y1(i_m_im[i]),
                .out_re(cmult_out[i*2]),
                .out_im(cmult_out[i*2+1])
            );
            round #(
                .IN_WIDTH(CMULT_WIDTH),
                .OUT_WIDTH(ROUND_WIDTH),
                .IN_SIGNED("yes")
            ) round_w11_re (
                .clk(clk),
                .i_data(cmult_out[i*2]),
                .o_data(round_out_data[i*2]),
                .o_sat(round_out_sat[i*2])
            );
            round #(
                .IN_WIDTH(CMULT_WIDTH),
                .OUT_WIDTH(ROUND_WIDTH),
                .IN_SIGNED("yes")
            ) round_w11_im (
                .clk(clk),
                .i_data(cmult_out[i*2+1]),
                .o_data(round_out_data[i*2+1]),
                .o_sat(round_out_sat[i*2+1])
            );
        end
    endgenerate
    
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
