module a_det #(
    parameter int A_WIDTH       = 16,
    parameter int ROUNDED_WIDTH = 16,
    parameter int USE_DSP_VALUE = 1
)(
    input  logic clk,
    input  logic rst,

    input  logic [A_WIDTH-1:0] i_a11, i_a22,
    input  logic [A_WIDTH-1:0] i_a12_re, i_a12_im,

    output logic [ROUNDED_WIDTH-1:0] o_det_a,

    output logic o_sat_det
);
    logic [A_WIDTH+A_WIDTH-1:0] mult_result;
    logic [A_WIDTH+A_WIDTH-1:0] dline_result;
    logic [A_WIDTH+A_WIDTH-1:0] cmodule_result;
    logic [A_WIDTH+A_WIDTH:0] sum_result;
    logic [A_WIDTH+A_WIDTH-1:0] sum_result_drop_signed;

    mult #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( A_WIDTH ),
        .SIGNED_OPERANDS ( 0 ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_mult (
        .clk ( clk ),
        .a ( i_a11 ),
        .b ( i_a22 ),
        .result ( mult_result )
    );

    dline #(
        .DATA_WIDTH (A_WIDTH+A_WIDTH),
        .DELAY (1)
    ) inst_dline (
        .i_clk (clk),
        .i_data (mult_result),
        .o_data (dline_result)
    );

    cmodule #(
        .WIDTH (A_WIDTH),
        .USE_DSP_VALUE (USE_DSP_VALUE)
    ) inst_cmodule (
        .clk (clk),
        .rst (rst),
        .valid_in (1'b1),
        .Re (i_a12_re),
        .Im (i_a12_im),
        .valid_out (),
        .MagSq (cmodule_result)
    );

    sum #(
        .A_WIDTH (A_WIDTH+A_WIDTH),
        .B_WIDTH (A_WIDTH+A_WIDTH),
        .USE_DSP_VALUE (USE_DSP_VALUE),
        .SIGNED_OPERANDS (0)
    ) inst_sum (
        .clk (clk),
        .rst (rst),
        .valid_in (1'b1),
        .A (dline_result),
        .B (cmodule_result),
        .sub (1),
        .valid_out (),
        .S (sum_result),
        .underflow ()
    );

    assign sum_result_drop_signed = sum_result[A_WIDTH+A_WIDTH-1:0];
    //assign sum_result_drop_signed = sum_result;

    round #(
        .IN_WIDTH (A_WIDTH+A_WIDTH),
        .OUT_WIDTH (ROUNDED_WIDTH),
        .IN_SIGNED (0)
    ) inst_round (
        .clk (clk),
        .i_data (sum_result_drop_signed),
        .o_data (o_det_a),
        .o_sat (o_sat_det)
    );


endmodule
