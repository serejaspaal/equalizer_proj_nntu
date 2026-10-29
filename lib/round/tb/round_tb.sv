`timescale 1ns / 1ps

module round_tb;
    localparam int IN_WIDTH   = 8;
    localparam int OUT_WIDTH  = 4;
    localparam int CLIP_WIDTH = 2;
    localparam int DROP       = IN_WIDTH - OUT_WIDTH - CLIP_WIDTH;
    localparam int POINT_POS  = 4;

    import "DPI-C" function void round(
        input  longint i_data,
        input  int     in_width,
        input  int     out_width,
        input  int     in_signed,
        input  int     clip_width,
        output longint o_data,
        output int     o_sat
    );

    logic clk;
    logic [IN_WIDTH-1:0]  i_data;
    logic [OUT_WIDTH-1:0] o_data_u;  logic o_sat_u;
    logic [OUT_WIDTH-1:0] o_data_s;  logic o_sat_s;
    logic [IN_WIDTH-1:0]  o_data_p;  logic o_sat_p;

    logic [OUT_WIDTH-1:0] exp_data_u, exp_data_s;
    logic                 exp_sat_u,  exp_sat_s;
    logic [IN_WIDTH-1:0]  exp_data_p;
    logic                 exp_sat_p;

    int errors = 0;
    int test_number = 0;

    round #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(IN_WIDTH), .IN_SIGNED(0), .CLIP_WIDTH(0))
        dut_p (.clk, .i_data, .o_data(o_data_p), .o_sat(o_sat_p));

    round #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .IN_SIGNED(0), .CLIP_WIDTH(CLIP_WIDTH))
        dut_u (.clk, .i_data, .o_data(o_data_u), .o_sat(o_sat_u));

    round #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .IN_SIGNED(1), .CLIP_WIDTH(CLIP_WIDTH))
        dut_s (.clk, .i_data, .o_data(o_data_s), .o_sat(o_sat_s));

    initial clk = 0;
    always #5 clk = ~clk;

    real i_data_fxp_s, i_data_fxp_u, i_data_fxp_p;
    real round_fxp_s,  round_fxp_u,  round_fxp_p;

    always_comb begin
        i_data_fxp_s = $signed(i_data)   * (2.0**(-POINT_POS));
        i_data_fxp_u = $unsigned(i_data) * (2.0**(-POINT_POS));
        round_fxp_s  = $signed(o_data_s)   * (2.0**(-(POINT_POS - DROP)));
        round_fxp_u  = $unsigned(o_data_u) * (2.0**(-(POINT_POS - DROP)));
    end

    always_ff @(posedge clk) begin
        i_data_fxp_p <= $unsigned(i_data)   * (2.0**(-POINT_POS));
        round_fxp_p  <= $unsigned(o_data_p) * (2.0**(-POINT_POS));
    end

    task automatic test(
        input int test_num,
        input logic [IN_WIDTH-1:0] val
    );
        longint c_data_u, c_data_s, c_data_p;
        int     c_sat_u,  c_sat_s,  c_sat_p;

        @(posedge clk);
        test_number = test_num;
        i_data = val;

        round(longint'($unsigned(val)), IN_WIDTH, OUT_WIDTH, 0, CLIP_WIDTH, c_data_u, c_sat_u);
        round(longint'($signed(val)),   IN_WIDTH, OUT_WIDTH, 1, CLIP_WIDTH, c_data_s, c_sat_s);
        round(longint'($unsigned(val)), IN_WIDTH, IN_WIDTH,  0, 0,          c_data_p, c_sat_p);

        exp_data_u = c_data_u[OUT_WIDTH-1:0];
        exp_sat_u  = c_sat_u[0];

        exp_data_s = c_data_s[OUT_WIDTH-1:0];
        exp_sat_s  = c_sat_s[0];

        exp_data_p = c_data_p[IN_WIDTH-1:0];
        exp_sat_p  = c_sat_p[0];

        repeat(2) @(posedge clk);
        #1;

        if (o_data_u !== exp_data_u || o_sat_u !== exp_sat_u) begin
            $error("UNS FAIL [Test %0d] in=%b -> o_data=%b o_sat=%b (exp %b %b)",
                   test_num, val, o_data_u, o_sat_u, exp_data_u, exp_sat_u);
            errors++;
        end else begin
            $display("UNS PASS [Test %0d] in=%b -> o_data=%b o_sat=%b",
                     test_num, val, o_data_u, o_sat_u);
        end

        if (o_data_s !== exp_data_s || o_sat_s !== exp_sat_s) begin
            $error("SIG FAIL [Test %0d] in=%b -> o_data=%b o_sat=%b (exp %b %b)",
                   test_num, val, o_data_s, o_sat_s, exp_data_s, exp_sat_s);
            errors++;
        end else begin
            $display("SIG PASS [Test %0d] in=%b -> o_data=%b o_sat=%b",
                     test_num, val, o_data_s, o_sat_s);
        end

        if (o_data_p !== exp_data_p || o_sat_p !== exp_sat_p) begin
            $error("PASS FAIL [Test %0d] in=%b -> o_data=%b o_sat=%b (exp %b %b)",
                   test_num, val, o_data_p, o_sat_p, exp_data_p, exp_sat_p);
            errors++;
        end else begin
            $display("PASS PASS [Test %0d] in=%b -> o_data=%b o_sat=%b",
                     test_num, val, o_data_p, o_sat_p);
        end
    endtask

    initial begin
        $display("=== Testbench: IN=%0d OUT=%0d CLIP=%0d DROP=%0d ===",
                 IN_WIDTH, OUT_WIDTH, CLIP_WIDTH, DROP);
        errors = 0;
        i_data = '0;

        test(0, 8'b1111_1111);
        test(1, 8'b1111_0000);
        test(2, 8'b0000_1111);
        test(3, 8'b0111_1111);
        test(4, 8'b1000_0000);
        test(5, 8'b0110_1010);
        test(6, 8'b1001_0011);

        for (int i = 0; i < (1 << IN_WIDTH); i++) begin
            test(i + 7, i[IN_WIDTH-1:0]);
        end

        repeat (2) @(posedge clk);
        $display("=== Done: %0d error(s) ===", errors);
        if (errors == 0) begin
            $display("=== ALL TESTS PASSED ===");
        end else begin
            $fatal(1, "=== TEST FAILED WITH %0d ERROR(S) ===", errors);
        end
        $finish;
    end
endmodule