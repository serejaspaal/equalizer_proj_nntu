module m_matrix #(
    parameter int    A_WIDTH       = 16,
    parameter int    H_WIDTH       = 16,
    parameter int    ROUNDED_WIDTH = 16,
    parameter string A_SIGNED      = "no",
    parameter string SIGNED_RES    = "yes",
    parameter string USE_DSP_VALUE = "yes",
    localparam int   M_WIDTH       = A_WIDTH + H_WIDTH + 2
)(
    input  logic clk,
    input  logic rst,
    input  logic [H_WIDTH-1:0] i_h11_re, i_h11_im,
    input  logic [H_WIDTH-1:0] i_h12_re, i_h12_im, 
    input  logic [H_WIDTH-1:0] i_h21_re, i_h21_im, 
    input  logic [H_WIDTH-1:0] i_h22_re, i_h22_im,
    
    input  logic [A_WIDTH-1:0] i_a11, i_a22, 
    input  logic [A_WIDTH-1:0] i_a12_re, i_a12_im,
    
    input  logic sub, 
//    output logic underflow, o_sat,
    
//    output logic [ROUNDED_WIDTH-1:0] m11_re, m11_im,
//    output logic [ROUNDED_WIDTH-1:0] m12_re, m12_im,
//    output logic [ROUNDED_WIDTH-1:0] m21_re, m21_im,
//    output logic [ROUNDED_WIDTH-1:0] m22_re, m22_im,
    output logic signed [A_WIDTH+H_WIDTH+1:0] m11_re, m11_im,
    output logic signed [A_WIDTH+H_WIDTH+1:0] m12_re, m12_im,
    output logic signed [A_WIDTH+H_WIDTH+1:0] m21_re, m21_im,
    output logic signed [A_WIDTH+H_WIDTH+1:0] m22_re, m22_im,
    
    output logic [A_WIDTH+H_WIDTH-1:0] cmult1_reg_m11_re, cmult1_reg_m11_im,
    output logic [A_WIDTH+H_WIDTH-1:0] cmult1_reg_m12_re, cmult1_reg_m12_im,
    output logic [A_WIDTH+H_WIDTH-1:0] cmult1_reg_m21_re, cmult1_reg_m21_im,
    output logic [A_WIDTH+H_WIDTH-1:0] cmult1_reg_m22_re, cmult1_reg_m22_im,
    
    output logic [A_WIDTH+H_WIDTH:0] cmult2_reg_m11_re, cmult2_reg_m11_im,
    output logic [A_WIDTH+H_WIDTH:0] cmult2_reg_m12_re, cmult2_reg_m12_im,
    output logic [A_WIDTH+H_WIDTH:0] cmult2_reg_m21_re, cmult2_reg_m21_im,
    output logic [A_WIDTH+H_WIDTH:0] cmult2_reg_m22_re, cmult2_reg_m22_im,
    
    output logic [M_WIDTH-1:0] sum_reg_m11_re, sum_reg_m11_im,
    output logic [M_WIDTH-1:0] sum_reg_m12_re, sum_reg_m12_im,
    output logic [M_WIDTH-1:0] sum_reg_m21_re, sum_reg_m21_im,
    output logic [M_WIDTH-1:0] sum_reg_m22_re, sum_reg_m22_im,   
    
    output logic [ROUNDED_WIDTH-1:0] round_m11_re, round_m11_im,
    output logic [ROUNDED_WIDTH-1:0] round_m12_re, round_m12_im,
    output logic [ROUNDED_WIDTH-1:0] round_m21_re, round_m21_im,
    output logic [ROUNDED_WIDTH-1:0] round_m22_re, round_m22_im,
    
    output logic o_sat_m11_re, o_sat_m11_im,
    output logic o_sat_m12_re, o_sat_m12_im,
    output logic o_sat_m21_re, o_sat_m21_im,
    output logic o_sat_m22_re, o_sat_m22_im
);


    logic [A_WIDTH+H_WIDTH-1:0] cmult1_m11_re, cmult1_m11_im;
    logic [A_WIDTH+H_WIDTH-1:0] cmult1_m12_re, cmult1_m12_im;
    logic [A_WIDTH+H_WIDTH-1:0] cmult1_m21_re, cmult1_m21_im;
    logic [A_WIDTH+H_WIDTH-1:0] cmult1_m22_re, cmult1_m22_im;
    
    logic [A_WIDTH+H_WIDTH:0] cmult2_m11_re, cmult2_m11_im;
    logic [A_WIDTH+H_WIDTH:0] cmult2_m12_re, cmult2_m12_im;
    logic [A_WIDTH+H_WIDTH:0] cmult2_m21_re, cmult2_m21_im;
    logic [A_WIDTH+H_WIDTH:0] cmult2_m22_re, cmult2_m22_im;
    

    
    
    logic sub_reg;
    
    
    logic [M_WIDTH-1:0] sum_m11_re, sum_m11_im;
    logic [M_WIDTH-1:0] sum_m12_re, sum_m12_im;
    logic [M_WIDTH-1:0] sum_m21_re, sum_m21_im;
    logic [M_WIDTH-1:0] sum_m22_re, sum_m22_im;
    
    

    
    //M[1][1]
    cmult_a_real_b_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( H_WIDTH ),
        .A_SIGNED ( A_SIGNED ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) cmult_a_real_b_coupl_m11 (
        .clk ( clk ),
        .a ( i_a22 ),
        .x1 ( i_h11_re ),
        .y1 ( i_h11_im ),
        .out_re ( cmult1_m11_re ),
        .out_im ( cmult1_m11_im )
    );
    
    cmult_b_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( H_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) cmult_b_coupl_m11 (
        .clk ( clk ),
        .x0 ( i_a12_re ),
        .y0 ( i_a12_im ),
        .x1 ( i_h12_re ),
        .y1 ( i_h12_im ),
        .out_re ( cmult2_m11_re ),
        .out_im ( cmult2_m11_im )
    );
    
    //M[1][2]
    cmult_a_real_b_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( H_WIDTH ),
        .A_SIGNED ( A_SIGNED ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) u_cmult_a_real_b_coupl_m12 (
        .clk ( clk ),
        .a ( i_a22 ),
        .x1 ( i_h21_re ),
        .y1 ( i_h21_im ),
        .out_re ( cmult1_m12_re ),
        .out_im ( cmult1_m12_im )
    );
    
    cmult_b_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( H_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) cmult_b_coupl_m12 (
        .clk ( clk ),
        .x0 ( i_a12_re ),
        .y0 ( i_a12_im ),
        .x1 ( i_h22_re ),
        .y1 ( i_h22_im ),
        .out_re ( cmult2_m12_re ),
        .out_im ( cmult2_m12_im )
    );
    
    //M[2][1]
    cmult_a_real_b_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( H_WIDTH ),
        .A_SIGNED ( A_SIGNED ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) cmult_a_real_b_coupl_m21 (
        .clk ( clk ),
        .a ( i_a11 ),
        .x1 ( i_h12_re ),
        .y1 ( i_h12_im ),
        .out_re ( cmult1_m21_re ),
        .out_im ( cmult1_m21_im )
    );
    
    cmult_both_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( H_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) cmult_both_coupl_m21 (
        .clk ( clk ),
        .x0 ( i_a12_re ),
        .y0 ( i_a12_im ),
        .x1 ( i_h11_re ),
        .y1 ( i_h11_im ),
        .out_re ( cmult2_m21_re ),
        .out_im ( cmult2_m21_im )
    );
    
    //M[2][2]
    cmult_a_real_b_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( H_WIDTH ),
        .A_SIGNED ( A_SIGNED ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) u_cmult_a_real_b_coupl_m22 (
        .clk ( clk ),
        .a ( i_a11 ),
        .x1 ( i_h22_re ),
        .y1 ( i_h22_im ),
        .out_re ( cmult1_m22_re ),
        .out_im ( cmult1_m22_im )
    );
    
    cmult_both_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( H_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) cmult_both_coupl_m22 (
        .clk ( clk ),
        .x0 ( i_a12_re ),
        .y0 ( i_a12_im ),
        .x1 ( i_h21_re ),
        .y1 ( i_h21_im ),
        .out_re ( cmult2_m22_re ),
        .out_im ( cmult2_m22_im )
    );
    
    // ============ –≈√»—“–€ Ã≈∆ƒ” 1-Ï » 2-Ï  ¿— ¿ƒ¿Ã» ============
//    always_ff @(posedge clk or posedge rst) begin
    always @(cmult2_m11_re or negedge rst) begin
        if (rst) begin
            cmult1_reg_m11_re <= '0;      
            cmult1_reg_m11_im <= '0;      
            cmult1_reg_m12_re <= '0;      
            cmult1_reg_m12_im <= '0;      
            cmult1_reg_m21_re <= '0;      
            cmult1_reg_m21_im <= '0;      
            cmult1_reg_m22_re <= '0;      
            cmult1_reg_m22_im <= '0;      
                                          
            cmult2_reg_m11_re <= '0;      
            cmult2_reg_m11_im <= '0;      
            cmult2_reg_m12_re <= '0;      
            cmult2_reg_m12_im <= '0;      
            cmult2_reg_m21_re <= '0;      
            cmult2_reg_m21_im <= '0;      
            cmult2_reg_m22_re <= '0;      
            cmult2_reg_m22_im <= '0;      
            
            sub_reg <= '0;
        end else begin
            cmult1_reg_m11_re <= cmult1_m11_re;
            cmult1_reg_m11_im <= cmult1_m11_im;
            cmult1_reg_m12_re <= cmult1_m12_re;
            cmult1_reg_m12_im <= cmult1_m12_im;
            cmult1_reg_m21_re <= cmult1_m21_re;
            cmult1_reg_m21_im <= cmult1_m21_im;
            cmult1_reg_m22_re <= cmult1_m22_re;
            cmult1_reg_m22_im <= cmult1_m22_im;
            
            cmult2_reg_m11_re <= cmult2_m11_re;
            cmult2_reg_m11_im <= cmult2_m11_im;
            cmult2_reg_m12_re <= cmult2_m12_re;
            cmult2_reg_m12_im <= cmult2_m12_im;
            cmult2_reg_m21_re <= cmult2_m21_re;
            cmult2_reg_m21_im <= cmult2_m21_im;
            cmult2_reg_m22_re <= cmult2_m22_re;
            cmult2_reg_m22_im <= cmult2_m22_im;
            
            sub_reg <= sub;
        end
    end
    
    // ============ 2-È  ¿— ¿ƒ: —ÛÏÏ‡ÚÓ˚ ============
    
    sum #(
        .A_WIDTH ( A_WIDTH+H_WIDTH ),
        .B_WIDTH ( A_WIDTH+H_WIDTH+1 ),
        .SIGNED_OPERANDS ( SIGNED_RES ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) _sum_m11_re (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( cmult1_reg_m11_re ),
        .B ( cmult2_reg_m11_re ),
        .sub ( sub_reg ),
        .valid_out (  ),
        .S ( sum_m11_re ),
        .underflow (  )
    );
    sum #(
        .A_WIDTH ( A_WIDTH+H_WIDTH ),
        .B_WIDTH ( A_WIDTH+H_WIDTH+1 ),
        .SIGNED_OPERANDS ( SIGNED_RES ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) _sum_m11_im (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( cmult1_reg_m11_im ),
        .B ( cmult2_reg_m11_im ),
        .sub ( sub_reg ),
        .valid_out (  ),
        .S ( sum_m11_im ),
        .underflow (  )
    );
    
    sum #(
        .A_WIDTH ( A_WIDTH+H_WIDTH ),
        .B_WIDTH ( A_WIDTH+H_WIDTH+1 ),
        .SIGNED_OPERANDS ( SIGNED_RES ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) _sum_m12_re (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( cmult1_reg_m12_re ),
        .B ( cmult2_reg_m12_re ),
        .sub ( sub_reg ),
        .valid_out (  ),
        .S ( sum_m12_re ),
        .underflow (  )
    );
    sum #(
        .A_WIDTH ( A_WIDTH+H_WIDTH ),
        .B_WIDTH ( A_WIDTH+H_WIDTH+1 ),
        .SIGNED_OPERANDS ( SIGNED_RES ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) _sum_m12_im (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( cmult1_reg_m12_im ),
        .B ( cmult2_reg_m12_im ),
        .sub ( sub_reg ),
        .valid_out (  ),
        .S ( sum_m12_im ),
        .underflow (  )
    );
        
    sum #(
        .A_WIDTH ( A_WIDTH+H_WIDTH ),
        .B_WIDTH ( A_WIDTH+H_WIDTH+1 ),
        .SIGNED_OPERANDS ( SIGNED_RES ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) _sum_m21_re (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( cmult1_reg_m21_re ),
        .B ( cmult2_reg_m21_re ),
        .sub ( sub_reg ),
        .valid_out (  ),
        .S ( sum_m21_re ),
        .underflow (  )
    );
    sum #(
        .A_WIDTH ( A_WIDTH+H_WIDTH ),
        .B_WIDTH ( A_WIDTH+H_WIDTH+1 ),
        .SIGNED_OPERANDS ( SIGNED_RES ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) _sum_m21_im (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( cmult1_reg_m21_im ),
        .B ( cmult2_reg_m21_im ),
        .sub ( sub_reg ),
        .valid_out (  ),
        .S ( sum_m21_im ),
        .underflow (  )
    );
    
    sum #(
        .A_WIDTH ( A_WIDTH+H_WIDTH ),
        .B_WIDTH ( A_WIDTH+H_WIDTH+1 ),
        .SIGNED_OPERANDS ( SIGNED_RES ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) _sum_m22_re (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( cmult1_reg_m22_re ),
        .B ( cmult2_reg_m22_re ),
        .sub ( sub_reg ),
        .valid_out (  ),
        .S ( sum_m22_re ),
        .underflow (  )
    );
    sum #(
        .A_WIDTH ( A_WIDTH+H_WIDTH ),
        .B_WIDTH ( A_WIDTH+H_WIDTH+1 ),
        .SIGNED_OPERANDS ( SIGNED_RES ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) _sum_m22_im (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( cmult1_reg_m22_im ),
        .B ( cmult2_reg_m22_im ),
        .sub ( sub_reg ),
        .valid_out (  ),
        .S ( sum_m22_im ),
        .underflow (  )
    );
    
   // ============ –≈√»—“–€ Ã≈∆ƒ” 2-Ï » 3-Ï  ¿— ¿ƒ¿Ã» ============
    always @(sum_m11_re or negedge rst) begin
        if (rst) begin
            sum_reg_m11_re <= '0;
            sum_reg_m11_im <= '0;
            sum_reg_m12_re <= '0;
            sum_reg_m12_im <= '0;
            sum_reg_m21_re <= '0;
            sum_reg_m21_im <= '0;
            sum_reg_m22_re <= '0;
            sum_reg_m22_im <= '0;
        end else begin
            sum_reg_m11_re <= sum_m11_re;
            sum_reg_m11_im <= sum_m11_im;
            sum_reg_m12_re <= sum_m12_re;
            sum_reg_m12_im <= sum_m12_im;
            sum_reg_m21_re <= sum_m21_re;
            sum_reg_m21_im <= sum_m21_im;
            sum_reg_m22_re <= sum_m22_re;
            sum_reg_m22_im <= sum_m22_im;
        end
    end
    
    // ============ 3-È  ¿— ¿ƒ: ŒÍÛ„ÎÂÌËÂ ============
    
    round #(
        .IN_WIDTH ( M_WIDTH ),
        .OUT_WIDTH ( ROUNDED_WIDTH ),
        .IN_SIGNED ( SIGNED_RES )
    ) _round_m11_re (
        .clk ( clk ),
        .i_data ( sum_reg_m11_re ),
        .o_data ( round_m11_re ),
        .o_sat ( o_sat_m11_re )
    );
        
    round #(
        .IN_WIDTH ( M_WIDTH ),
        .OUT_WIDTH ( ROUNDED_WIDTH ),
        .IN_SIGNED ( SIGNED_RES )
    ) _round_m11_im (
        .clk ( clk ),
        .i_data ( sum_reg_m11_im ),
        .o_data ( round_m11_im ),
        .o_sat ( o_sat_m11_im )
    );
        
    
    round #(
        .IN_WIDTH ( M_WIDTH ),
        .OUT_WIDTH ( ROUNDED_WIDTH ),
        .IN_SIGNED ( SIGNED_RES )
    ) _round_m12_re (
        .clk ( clk ),
        .i_data ( sum_reg_m12_re ),
        .o_data ( round_m12_re ),
        .o_sat ( o_sat_m12_re )
    );
        
    round #(
        .IN_WIDTH ( M_WIDTH ),
        .OUT_WIDTH ( ROUNDED_WIDTH ),
        .IN_SIGNED ( SIGNED_RES )
    ) _round_m12_im (
        .clk ( clk ),
        .i_data ( sum_reg_m12_im ),
        .o_data ( round_m12_im ),
        .o_sat ( o_sat_m12_im )
    );
    
    

    
    round #(
        .IN_WIDTH ( M_WIDTH ),
        .OUT_WIDTH ( ROUNDED_WIDTH ),
        .IN_SIGNED ( SIGNED_RES )
    ) _round_m21_re (
        .clk ( clk ),
        .i_data ( sum_reg_m21_re ),
        .o_data ( round_m21_re ),
        .o_sat ( o_sat_m21_re )
    );
        
    round #(
        .IN_WIDTH ( M_WIDTH ),
        .OUT_WIDTH ( ROUNDED_WIDTH ),
        .IN_SIGNED ( SIGNED_RES )
    ) _round_m21_im (
        .clk ( clk ),
        .i_data ( sum_reg_m21_im ),
        .o_data ( round_m21_im ),
        .o_sat ( o_sat_m21_im )
    );
    
    
    

    round #(
        .IN_WIDTH ( M_WIDTH ),
        .OUT_WIDTH ( ROUNDED_WIDTH ),
        .IN_SIGNED ( SIGNED_RES )
    ) _round_m22_re (
        .clk ( clk ),
        .i_data ( sum_reg_m22_re ),
        .o_data ( round_m22_re ),
        .o_sat ( o_sat_m22_re )
    );
        
    round #(
        .IN_WIDTH ( M_WIDTH ),
        .OUT_WIDTH ( ROUNDED_WIDTH ),
        .IN_SIGNED ( SIGNED_RES )
    ) _round_m22_im (
        .clk ( clk ),
        .i_data ( sum_reg_m22_im ),
        .o_data ( round_m22_im ),
        .o_sat ( o_sat_m22_im )
    );
    
    always @(round_m11_im or sum_reg_m11_re or negedge rst) begin
        if (rst) begin
            m11_re <= '0;
            m11_im <= '0;
            m12_re <= '0;
            m12_im <= '0;
            m21_re <= '0;
            m21_im <= '0;
            m22_re <= '0;
            m22_im <= '0;
        end else begin
//            m11_re <= round_m11_re;
//            m11_im <= round_m11_im;
//            m12_re <= round_m12_re;
//            m12_im <= round_m12_im;
//            m21_re <= round_m21_re;
//            m21_im <= round_m21_im;
//            m22_re <= round_m22_re;
//            m22_im <= round_m22_im;
            m11_re <= sum_reg_m11_re;
            m11_im <= sum_reg_m11_im;
            m12_re <= sum_reg_m12_re;
            m12_im <= sum_reg_m12_im;
            m21_re <= sum_reg_m21_re;
            m21_im <= sum_reg_m21_im;
            m22_re <= sum_reg_m22_re;
            m22_im <= sum_reg_m22_im;

        end
    end
    
endmodule