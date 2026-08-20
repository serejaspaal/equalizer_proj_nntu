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
    localparam N         = FRAC_WIDTH - LUT_AW - 1;  
    localparam MAX_SHIFT = FRAC_WIDTH - 1;           
    localparam SHIFT_W   = MAX_SHIFT + N;           

    logic [4:0] msb_pos;
    integer i1, i2, i3;
    
    //находим позицию старшего бита целой части
    always_comb begin
        msb_pos = 0;
        for (i1 = 0; i1 < IN_WIDTH; i1 = i1 + 1)
            if (i_x[i1]) msb_pos = i1[4:0];
    end

    //находим сдвиг
    wire [4:0] k_right   = msb_pos - (FRAC_WIDTH - 1);
    wire [4:0] k_left    = (FRAC_WIDTH - 1) - msb_pos;
    wire       use_right = (msb_pos >= FRAC_WIDTH);
    wire [4:0] shift_k   = use_right ? k_right : k_left;
    
    //вычисляем адрес в таблице
    logic [LUT_AW-1:0] addr_comb;
    always_comb begin
        addr_comb = 0;
        for (i2 = 0; i2 < LUT_AW; i2 = i2 + 1)
            if ((msb_pos > 0) && (msb_pos - 1 >= i2))
                addr_comb[LUT_AW-1-i2] = i_x[msb_pos-1-i2];
    end

    //вычисляем биты для интерполяции, для случая, когда значение окажется между двумя узлами 
    logic [N-1:0] xfrac_comb;
    always_comb begin
        xfrac_comb = '0;
        for (i3 = 0; i3 < N; i3 = i3 + 1)
            if (msb_pos >= LUT_AW + 1 + i3)
                xfrac_comb[N-1-i3] = i_x[msb_pos - 1 - LUT_AW - i3];
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

    logic [LUT_DW-1:0]   r_a0, r_a1;
    logic [LUT_DW+N-1:0] interp;

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

    linear_intrp #(
        .LUT_DW (LUT_DW),
        .N      (N)
    ) dut2 (
        .i_a0  (r_a0),
        .i_a1  (r_a1),
        .i_xf  (r_xfrac),
        .o_res (interp)
    );

    logic [LUT_DW+N-1:0] s2_interp;
    logic [4:0]          s2_k;
    logic                s2_shift_right;
    logic                s2_is_zero;

    always_ff @(posedge i_clk) begin
        s2_interp      <= interp;
        s2_k           <= s1b_k;
        s2_shift_right <= s1b_shift_right;
        s2_is_zero     <= s1b_is_zero;
    end

    logic [LUT_DW + N + SHIFT_W - 1:0] wide_result;   
    logic [LUT_DW + N - 1:0]           s2_16;

    always_comb begin
        s2_16 = s2_interp >> N;         
        if (s2_shift_right)
            wide_result = s2_16 >> s2_k;
        else
            wide_result = s2_16 << s2_k;
    end

    always_ff @(posedge i_clk) begin
        o_result <= wide_result[OUT_WIDTH-1:0];
        o_inf    <= s2_is_zero;
    end

endmodule