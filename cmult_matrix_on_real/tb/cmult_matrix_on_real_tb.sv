`timescale 1ns / 1ps
module cmult_matrix_on_real_tb;
    parameter int DET_WIDTH = 16;
    parameter int M_WIDTH = 16;
    localparam int CMULT_WIDTH = DET_WIDTH+M_WIDTH;
    parameter int W_WIDTH = 16;
    
    localparam int DROP = DET_WIDTH + M_WIDTH - W_WIDTH;
    localparam signed [W_WIDTH:0] MAXP = (1 <<< (W_WIDTH-1)) - 1;
    localparam signed [W_WIDTH:0] MINN = -(1 <<< (W_WIDTH-1));
    
    logic clk;
    logic [DET_WIDTH-1:0] det_inv;
    
    logic signed [M_WIDTH-1:0] i_m11_re, i_m11_im;
    logic signed [M_WIDTH-1:0] i_m12_re, i_m12_im;
    logic signed [M_WIDTH-1:0] i_m21_re, i_m21_im;
    logic signed [M_WIDTH-1:0] i_m22_re, i_m22_im;
    
    logic signed [W_WIDTH-1:0] o_w11_re, o_w11_im;
    logic signed [W_WIDTH-1:0] o_w12_re, o_w12_im;
    logic signed [W_WIDTH-1:0] o_w21_re, o_w21_im;
    logic signed [W_WIDTH-1:0] o_w22_re, o_w22_im;
    
    logic o_sat_w11_re, o_sat_w11_im;
    logic o_sat_w12_re, o_sat_w12_im;
    logic o_sat_w21_re, o_sat_w21_im;
    logic o_sat_w22_re, o_sat_w22_im;
    
    cmult_matrix_on_real #(
        .DET_WIDTH(DET_WIDTH),
        .M_WIDTH(M_WIDTH),
        .W_WIDTH(W_WIDTH)
    ) dut (.*);
    
        
    initial clk = 0;
    always #5 clk = ~clk;
    
    logic signed [DET_WIDTH+M_WIDTH-1:0] ref_cmult[7:0];
    logic signed [W_WIDTH:0] ref_sum[7:0];
    logic signed [W_WIDTH-1:0] ref_data[7:0];
    logic signed [W_WIDTH-1:0] ref_data_reg[7:0];
    logic ref_sat[7:0];
    logic ref_sat_reg[7:0];
    
    always_ff @(posedge clk) begin
        ref_cmult[0] <= $signed({1'b0, det_inv}) * i_m11_re;
        ref_cmult[1] <= $signed({1'b0, det_inv}) * i_m11_im;
        ref_cmult[2] <= $signed({1'b0, det_inv}) * i_m12_re;
        ref_cmult[3] <= $signed({1'b0, det_inv}) * i_m12_im;
        ref_cmult[4] <= $signed({1'b0, det_inv}) * i_m21_re;
        ref_cmult[5] <= $signed({1'b0, det_inv}) * i_m21_im;
        ref_cmult[6] <= $signed({1'b0, det_inv}) * i_m22_re;
        ref_cmult[7] <= $signed({1'b0, det_inv}) * i_m22_im;
    end
    always_comb begin
        for (int i = 0; i < 8; i++) begin
            ref_sum[i] = $signed(ref_cmult[i][DET_WIDTH+M_WIDTH-1 : DROP]) +
                           $signed({1'b0, ref_cmult[i][DROP-1]});
        end
    end

    always_ff @(posedge clk) begin
        for (int i = 0; i < 8; i++) begin
            if (ref_sum[i] > MAXP) begin
                ref_data[i] <= MAXP[W_WIDTH-1:0];
                ref_sat[i]  <= 1'b1;
            end else if (ref_sum[i] < MINN) begin
                ref_data[i] <= MINN[W_WIDTH-1:0];
                ref_sat[i]  <= 1'b1;
            end else begin
                ref_data[i] <= ref_sum[i][W_WIDTH-1:0];
                ref_sat[i]  <= 1'b0;
            end
        end
    end
    
    always_ff @(posedge clk) begin
        ref_data_reg <= ref_data;
        ref_sat_reg  <= ref_sat;
    end
    
    int errors = 0;    
    
    task check_all(input string label);
        $display("%s: w11_re=%0d o_w11_im=%0d o_w12_re=%0d o_w12_im=%0d o_w21_re=%0d o_w21_im=%0d o_w22_re=%0d o_w22_im=%0d", label,
            o_w11_re, o_w11_im, o_w12_re, o_w12_im, o_w21_re, o_w21_im, o_w22_re, o_w22_im);
        if (o_w11_re !== ref_data_reg[0] || o_sat_w11_re !== ref_sat_reg[0]) begin
            $error("%s o_w11_re: got (%0d,%0d) exp (%0d,%0d)", label,
                   o_w11_re, o_sat_w11_re, ref_data_reg[0], ref_sat_reg[0]);
            errors++;
        end
        if (o_w11_im !== ref_data_reg[1] || o_sat_w11_im !== ref_sat_reg[1]) begin
            $error("%s w11_im: got (%0d,%0d) exp (%0d,%0d)", label,
                   o_w11_im, o_sat_w11_im, ref_data_reg[1], ref_sat_reg[1]); 
            errors++;
        end
        if (o_w12_re !== ref_data_reg[2] || o_sat_w12_re !== ref_sat_reg[2]) begin
            $error("%s o_w12_re: got (%0d,%0d) exp (%0d,%0d)", label,
                   o_w12_re, o_sat_w12_re, ref_data_reg[2], ref_sat_reg[2]); 
            errors++;
        end
        if (o_w12_im !== ref_data_reg[3] || o_sat_w12_im !== ref_sat_reg[3]) begin
            $error("%s o_w12_im: got (%0d,%0d) exp (%0d,%0d)", label,
                   o_w12_im, o_sat_w12_im, ref_data_reg[3], ref_sat_reg[3]); 
            errors++;
        end
        if (o_w21_re !== ref_data_reg[4] || o_sat_w21_re !== ref_sat_reg[4]) begin
            $error("%s o_w21_re: got (%0d,%0d) exp (%0d,%0d)", label,
                   o_w21_re, o_sat_w21_re, ref_data_reg[4], ref_sat_reg[4]); 
            errors++;
        end
        if (o_w21_im !== ref_data_reg[5] || o_sat_w21_im !== ref_sat_reg[5]) begin
            $error("%s o_w21_im: got (%0d,%0d) exp (%0d,%0d)", label,
                   o_w21_im, o_sat_w21_im, ref_data_reg[5], ref_sat_reg[5]); 
            errors++;
        end
        if (o_w22_re !== ref_data_reg[6] || o_sat_w22_re !== ref_sat_reg[6]) begin
            $error("%s o_w22_re: got (%0d,%0d) exp (%0d,%0d)", label,
                   o_w22_re, o_sat_w22_re, ref_data_reg[6], ref_sat_reg[6]); 
            errors++;
        end
        if (o_w22_im !== ref_data_reg[7] || o_sat_w22_im !== ref_sat_reg[7]) begin
            $error("%s o_w22_im: got (%0d,%0d) exp (%0d,%0d)", label,
                   o_w22_im, o_sat_w22_im, ref_data_reg[7], ref_sat_reg[7]); 
            errors++;
        end
    endtask
    
    initial begin
    @(posedge clk);
    det_inv = 0;
    i_m11_re = 0; i_m11_im = 0;
    i_m12_re = 0; i_m12_im = 0;
    i_m21_re = 0; i_m21_im = 0;
    i_m22_re = 0; i_m22_im = 0;
    @(posedge clk);
    

    det_inv = 1;
    i_m11_re = 1; i_m11_im = 1;
    i_m12_re = 1; i_m12_im = 1;
    i_m21_re = 1; i_m21_im = 1;
    i_m22_re = 1; i_m22_im = 1;
    @(posedge clk);
    

    det_inv = 1;
    i_m11_re = -1; i_m11_im = -1;
    i_m12_re = -1; i_m12_im = -1;
    i_m21_re = -1; i_m21_im = -1;
    i_m22_re = -1; i_m22_im = -1;
    @(posedge clk);
    
    

    det_inv = 256;
    i_m11_re = 32767; i_m11_im = 32767;
    i_m12_re = 32767; i_m12_im = 32767;
    i_m21_re = 32767; i_m21_im = 32767;
    i_m22_re = 32767; i_m22_im = 32767;
    @(posedge clk);
    check_all("T1 zeros");
    

    det_inv = 32768;
    i_m11_re = 256; i_m11_im = 256;
    i_m12_re = 256; i_m12_im = 256;
    i_m21_re = 256; i_m21_im = 256;
    i_m22_re = 256; i_m22_im = 256;
    @(posedge clk);
    check_all("T2 min prod");
    

    det_inv = 65535;
    i_m11_re = 32767; i_m11_im = 32767;
    i_m12_re = 32767; i_m12_im = 32767;
    i_m21_re = 32767; i_m21_im = 32767;
    i_m22_re = 32767; i_m22_im = 32767;
    @(posedge clk);
    check_all("T3 neg prod");
    

    det_inv = 65535;
    i_m11_re = -32768; i_m11_im = -32768;
    i_m12_re = -32768; i_m12_im = -32768;
    i_m21_re = -32768; i_m21_im = -32768;
    i_m22_re = -32768; i_m22_im = -32768;
    @(posedge clk);
    check_all("T4 round bit = 0");
    

    det_inv = 128;
    i_m11_re = 1; i_m11_im = -1;
    i_m12_re = 1; i_m12_im = -1;
    i_m21_re = 1; i_m21_im = -1;
    i_m22_re = 1; i_m22_im = -1;
    @(posedge clk);
    check_all("T5 round bit = 1");
    

    det_inv = 32768;
    i_m11_re = 1; i_m11_im = -1;
    i_m12_re = 1; i_m12_im = -1;
    i_m21_re = 1; i_m21_im = -1;
    i_m22_re = 1; i_m22_im = -1;
    @(posedge clk);
    check_all("T6 sat+");
    

    det_inv = 65535;
    i_m11_re = 32767; i_m11_im = -32767;
    i_m12_re = 1; i_m12_im = -1;
    i_m21_re = 0; i_m21_im = 0;
    i_m22_re = 0; i_m22_im = 0;
    @(posedge clk);
    check_all("T7 MINN");
    @(posedge clk);
    check_all("T8 det=128, m=+-1");
    @(posedge clk);
    check_all("T9 det=32768, m=+-1");
    @(posedge clk);
    check_all("T10 mixed");

    repeat (4) @(posedge clk);
    if (errors == 0) $display("ALL TESTS PASSED");
    else             $display("%0d TESTS FAILED", errors);
    $finish;
end
    
endmodule
