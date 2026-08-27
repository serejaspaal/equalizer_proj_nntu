`timescale 1ns / 1ps

module func_reverse #(
    parameter IN_WIDTH   = 24,
    parameter FRAC_WIDTH = 16,
    parameter USE_INTRP  = 0,
    parameter OUT_WIDTH  = IN_WIDTH + USE_INTRP * (FRAC_WIDTH - 12)
)(
    input  logic                          i_clk,
    input  logic [IN_WIDTH-1:0]          i_x,
    output logic [OUT_WIDTH-1:0]         o_result,
    output logic                         o_inf
);

    localparam LUT_AW    = 11;
    localparam LUT_DW    = 18;
    localparam N         = FRAC_WIDTH - LUT_AW - 1;
    localparam MAX_SHIFT = FRAC_WIDTH - 1;
    localparam SHIFT_W   = MAX_SHIFT + N;

    logic [4:0] msb_pos;

    always_comb begin
        msb_pos = 0;
        for (int i = 0; i < IN_WIDTH; i = i + 1)
            if (i_x[i]) msb_pos = i[4:0];
    end

    logic [4:0] k_right;
    logic [4:0] k_left;
    logic       use_right;
    logic [4:0] shift_k;

    assign k_right   = msb_pos - (FRAC_WIDTH - 1);
    assign k_left    = (FRAC_WIDTH - 1) - msb_pos;
    assign use_right = (msb_pos >= FRAC_WIDTH);
    assign shift_k   = use_right ? k_right : k_left;

    logic [LUT_AW-1:0] addr_comb;
    always_comb begin
        addr_comb = 0;
        for (int i = 0; i < LUT_AW; i = i + 1)
            if ((msb_pos > 0) && (msb_pos - 1 >= i))
                addr_comb[LUT_AW-1-i] = i_x[msb_pos-1-i];
    end

    logic [N-1:0] xfrac_comb;
    always_comb begin
        xfrac_comb = '0;
        for (int i = 0; i < N; i = i + 1)
            if (msb_pos >= LUT_AW + 1 + i)
                xfrac_comb[N-1-i] = i_x[msb_pos - 1 - LUT_AW - i];
    end

    logic [LUT_AW-1:0] r_addr, r_addr1;
    logic [N-1:0]      r_xfrac;
    logic [4:0]        s1_k;
    logic              s1_shift_right;
    logic              s1_is_zero;

    always_ff @(posedge i_clk) begin
        r_addr         <= addr_comb;
        r_addr1        <= (addr_comb == {LUT_AW{1'b1}}) ? addr_comb
                                                         : addr_comb + 1'b1;
        r_xfrac        <= xfrac_comb;
        s1_k           <= shift_k;
        s1_shift_right <= use_right;
        s1_is_zero     <= (i_x == 0);
    end

    logic [4:0] s1b_k;
    logic       s1b_shift_right;
    logic       s1b_is_zero;

    always_ff @(posedge i_clk) begin
        s1b_k           <= s1_k;
        s1b_shift_right <= s1_shift_right;
        s1b_is_zero     <= s1_is_zero;
    end

    logic [LUT_DW-1:0]     r_a0, r_a1;
    logic [LUT_DW+N-1:0]   interp;

    block_ram #(
        .AW (LUT_AW),
        .DW (LUT_DW)
    ) dut1 (
        .clk    (i_clk),
        .addr_a (r_addr),
        .addr_b (r_addr1),
        .data_a (r_a0),
        .data_b (r_a1)
    );

    generate
        if (USE_INTRP) begin : gen_linear_intrp
            linear_intrp #(
                .LUT_DW (LUT_DW),
                .N      (N)
            ) dut2 (
                .i_a0  (r_a0),
                .i_a1  (r_a1),
                .i_xf  (r_xfrac),
                .o_res (interp)
            );
        end
    endgenerate

    logic [LUT_DW-1:0]     s2_a0;
    logic [LUT_DW+N-1:0]   s2_interp;
    logic [4:0]            s2_k;
    logic                  s2_shift_right;
    logic                  s2_is_zero;

    always_ff @(posedge i_clk) begin
        s2_a0          <= r_a0;
        s2_interp      <= interp;
        s2_k           <= s1b_k;
        s2_shift_right <= s1b_shift_right;
        s2_is_zero     <= s1b_is_zero;
    end

    logic [LUT_DW + N + SHIFT_W - 1:0] wide_result;

    generate
        if (USE_INTRP) begin : gen_shift_intrp
            always_comb begin
                if (s2_shift_right)
                    wide_result = s2_interp >> s2_k;
                else
                    wide_result = s2_interp << s2_k;
            end
        end else begin : gen_shift_no_intrp
            always_comb begin
                if (s2_shift_right)
                    wide_result = s2_a0 >> s2_k;
                else
                    wide_result = s2_a0 << s2_k;
            end
        end
    endgenerate

    always_ff @(posedge i_clk) begin
        o_result <= wide_result[OUT_WIDTH-1:0];
        o_inf    <= s2_is_zero;
    end

endmodule