`timescale 1ns / 1ps

module func_reverse #(
    parameter IN_WIDTH   = 24,
    parameter FRAC_WIDTH = 16,
    parameter OUT_WIDTH  = 24
)(
    input  logic                  i_clk,
    input  logic [IN_WIDTH-1:0]  i_x,
    output logic [OUT_WIDTH-1:0] o_result,
    output logic                 o_inf
);

    localparam LUT_AW    = 11;
    localparam LUT_DW    = 18;
    localparam MAX_SHIFT = FRAC_WIDTH - 1;

    logic [LUT_AW-1:0] r_addr;
    logic [LUT_DW-1:0] r_data;

    block_ram #(
        .AW (LUT_AW),
        .DW (LUT_DW)
    ) u_lut (
        .clk  (i_clk),
        .addr (r_addr),
        .data (r_data)
    );

    logic [4:0] s1_k;
    logic       s1_shift_right;
    logic       s1_is_zero;

    logic [LUT_DW-1:0] s2_lut;
    logic [4:0]         s2_k;
    logic               s2_shift_right;
    logic               s2_is_zero;

    // Stage 1: MSB, address, normalize
    logic [4:0] msb_pos;
    integer i1, i2;

    always_comb begin
        msb_pos = 0;
        for (i1 = 0; i1 < IN_WIDTH; i1 = i1 + 1)
            if (i_x[i1]) msb_pos = i1[4:0];
    end

    wire [4:0] k_right   = msb_pos - (FRAC_WIDTH - 1);
    wire [4:0] k_left    = (FRAC_WIDTH - 1) - msb_pos;
    wire       use_right = (msb_pos >= FRAC_WIDTH);
    wire [4:0] shift_k   = use_right ? k_right : k_left;

    logic [LUT_AW-1:0] addr_comb;
    always_comb begin
        addr_comb = 0;
        for (i2 = 0; i2 < LUT_AW; i2 = i2 + 1)
            if ((msb_pos > 0) && (msb_pos - 1 >= i2))
                addr_comb[LUT_AW-1-i2] = i_x[msb_pos-1-i2];
    end

    always_ff @(posedge i_clk) begin
        s1_k           <= shift_k;
        s1_shift_right <= use_right;
        r_addr         <= addr_comb;
        s1_is_zero     <= (i_x == 0);
    end

    // Stage 2: LUT read
    always_ff @(posedge i_clk) begin
        s2_lut         <= r_data;
        s2_k           <= s1_k;
        s2_shift_right <= s1_shift_right;
        s2_is_zero     <= s1_is_zero;
    end

    // Stage 3: reverse shift + output
    logic [LUT_DW + MAX_SHIFT - 1:0] wide_result;

    always_comb begin
        if (s2_shift_right)
            wide_result = s2_lut >> s2_k;
        else
            wide_result = s2_lut << s2_k;
    end

    always_ff @(posedge i_clk) begin
        o_result <= wide_result[OUT_WIDTH-1:0];
        o_inf    <= s2_is_zero;
    end

endmodule
