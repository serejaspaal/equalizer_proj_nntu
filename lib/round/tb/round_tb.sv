`timescale 1ns / 1ps
module round_tb;
    localparam int IN_WIDTH   = 8;
    localparam int OUT_WIDTH  = 4;
    localparam int DROP       = IN_WIDTH - OUT_WIDTH;
    localparam int POINT_POS  = 4;         

    logic clk;
    logic [IN_WIDTH-1:0] i_data;
    logic [OUT_WIDTH-1:0] o_data_u;  logic o_sat_u;
    logic [OUT_WIDTH-1:0] o_data_s;  logic o_sat_s;

    round #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .IN_SIGNED("no"))
        dut_u (.clk, .i_data, .o_data(o_data_u), .o_sat(o_sat_u));
    round #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .IN_SIGNED("yes"))
        dut_s (.clk, .i_data, .o_data(o_data_s), .o_sat(o_sat_s));

    initial clk = 0;
    always #5 clk = ~clk;

    real i_data_fxp_s, i_data_fxp_u;  
    real round_fxp_s,  round_fxp_u;    

    always_comb begin
        i_data_fxp_s = $signed(i_data)   * (2.0**(-POINT_POS));
        i_data_fxp_u = $unsigned(i_data) * (2.0**(-POINT_POS));
        round_fxp_s  = $signed(o_data_s) * (2.0**(-(POINT_POS-DROP)));
        round_fxp_u  = $unsigned(o_data_u)* (2.0**(-(POINT_POS-DROP)));
    end

    localparam signed [OUT_WIDTH:0] MAXP =  (1 <<< (OUT_WIDTH-1)) - 1;
    localparam signed [OUT_WIDTH:0] MINN = -(1 <<< (OUT_WIDTH-1));

    logic [OUT_WIDTH:0]        sum_comb_u; 
    logic signed [OUT_WIDTH:0] sum_comb_s;  

    always_comb begin
        sum_comb_u = {1'b0, i_data[IN_WIDTH-1:DROP]} + i_data[DROP-1];
        sum_comb_s = $signed(i_data[IN_WIDTH-1:DROP]) + $signed({1'b0, i_data[DROP-1]});
    end

    logic [OUT_WIDTH-1:0] exp_data_u, exp_data_s;   
    logic                 exp_sat_u,  exp_sat_s;    
    logic [IN_WIDTH-1:0]  i_data_d;                 
    logic                 started;

    always_ff @(posedge clk) begin
        exp_sat_u  <= sum_comb_u[OUT_WIDTH];
        exp_data_u <= sum_comb_u[OUT_WIDTH] ? {OUT_WIDTH{1'b1}} : sum_comb_u[OUT_WIDTH-1:0];

        if (sum_comb_s > MAXP) begin
            exp_data_s <= MAXP[OUT_WIDTH-1:0]; exp_sat_s <= 1'b1;
        end else if (sum_comb_s < MINN) begin
            exp_data_s <= MINN[OUT_WIDTH-1:0]; exp_sat_s <= 1'b1;
        end else begin
            exp_data_s <= sum_comb_s[OUT_WIDTH-1:0]; exp_sat_s <= 1'b0;
        end

        i_data_d <= i_data;
    end

    int errors = 0;

    always @(posedge clk) begin
        #1;
        if (started) begin
            if (o_data_u !== exp_data_u || o_sat_u !== exp_sat_u) begin
                $error("UNS FAIL @%0t in=%b -> o_data=%b o_sat=%b (exp %b %b)",
                       $time, i_data_d, o_data_u, o_sat_u, exp_data_u, exp_sat_u);
                errors++;
            end else
                $display("UNS PASS @%0t in=%b -> o_data=%b o_sat=%b", $time, i_data_d, o_data_u, o_sat_u);

            if (o_data_s !== exp_data_s || o_sat_s !== exp_sat_s) begin
                $error("SIG FAIL @%0t in=%b -> o_data=%b o_sat=%b (exp %b %b)",
                       $time, i_data_d, o_data_s, o_sat_s, exp_data_s, exp_sat_s);
                errors++;
            end else
                $display("SIG PASS @%0t in=%b -> o_data=%b o_sat=%b", $time, i_data_d, o_data_s, o_sat_s);
        end
    end

    initial begin
        $display("=== testbench ===");
        i_data = 0; started = 0;
        @(posedge clk); i_data = 8'b1111_1111; started = 1;
        @(posedge clk); i_data = 8'b1111_0000;
        @(posedge clk); i_data = 8'b0000_1111;
        @(posedge clk); i_data = 8'b0111_1111;
        @(posedge clk); i_data = 8'b1000_0000;
        @(posedge clk); i_data = 8'b0110_1010;
        @(posedge clk); i_data = 8'b1001_0011;
        @(posedge clk);
        @(posedge clk);
        $display("=== Done: %0d error(s) ===", errors);
        if (errors == 0) $display("=== ALL TESTS PASSED ===");
        $finish;
    end
endmodule