`timescale 1ns / 1ps
module round_tb;
    localparam int IN_WIDTH  = 8;
    localparam int OUT_WIDTH = 4;
    localparam int DROP      = IN_WIDTH - OUT_WIDTH;

    logic clk;
    logic [IN_WIDTH-1:0] i_data;

    logic [OUT_WIDTH-1:0] od_u;  logic os_u;   
    logic [OUT_WIDTH-1:0] od_s;  logic os_s;   

    round #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .IN_SIGNED("no"))
        dut_u (.clk, .i_data, .o_data(od_u), .o_sat(os_u));

    round #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .IN_SIGNED("yes"))
        dut_s (.clk, .i_data, .o_data(od_s), .o_sat(os_s));

    initial clk = 0;
    always #5 clk = ~clk;
    localparam signed [OUT_WIDTH:0] MAXP =  (1 <<< (OUT_WIDTH-1)) - 1;
    localparam signed [OUT_WIDTH:0] MINN = -(1 <<< (OUT_WIDTH-1));

    logic [OUT_WIDTH:0]        su_comb;
    logic signed [OUT_WIDTH:0] ss_comb;

    always_comb begin
        su_comb = {1'b0, i_data[IN_WIDTH-1:DROP]} + i_data[DROP-1];
        ss_comb = $signed(i_data[IN_WIDTH-1:DROP]) + $signed({1'b0, i_data[DROP-1]});
    end

    logic [OUT_WIDTH-1:0] exp_du, exp_ds;
    logic                 exp_su, exp_ss;
    logic [IN_WIDTH-1:0]  in_d;
    logic                 started;

    always_ff @(posedge clk) begin
        exp_su <= su_comb[OUT_WIDTH];
        exp_du <= su_comb[OUT_WIDTH] ? {OUT_WIDTH{1'b1}} : su_comb[OUT_WIDTH-1:0];

        if (ss_comb > MAXP) begin
            exp_ds <= MAXP[OUT_WIDTH-1:0]; exp_ss <= 1'b1;
        end else if (ss_comb < MINN) begin
            exp_ds <= MINN[OUT_WIDTH-1:0]; exp_ss <= 1'b1;
        end else begin
            exp_ds <= ss_comb[OUT_WIDTH-1:0]; exp_ss <= 1'b0;
        end

        in_d <= i_data;
    end

    int errors = 0;

    always @(posedge clk) begin
        #1;
        if (started) begin
            if (od_u !== exp_du || os_u !== exp_su) begin
                $error("UNS FAIL @%0t in=%b -> o_data=%b o_sat=%b (exp %b %b)",
                       $time, in_d, od_u, os_u, exp_du, exp_su);
                errors++;
            end else
                $display("UNS PASS @%0t in=%b -> o_data=%b o_sat=%b", $time, in_d, od_u, os_u);

            if (od_s !== exp_ds || os_s !== exp_ss) begin
                $error("SIG FAIL @%0t in=%b -> o_data=%b o_sat=%b (exp %b %b)",
                       $time, in_d, od_s, os_s, exp_ds, exp_ss);
                errors++;
            end else
                $display("SIG PASS @%0t in=%b -> o_data=%b o_sat=%b", $time, in_d, od_s, os_s);
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