`timescale 1ns / 1ps

module tb_cmodule;

    localparam int WIDTH = 8;

    logic clk = 0;
    logic rst;
    logic valid_in;
    logic signed [WIDTH-1:0] Re;
    logic signed [WIDTH-1:0] Im;

    logic valid_out;
    logic signed [2*WIDTH:0] MagSq;

    always #5 clk = ~clk;

    cmodule #(
        .WIDTH   (WIDTH),
        .USE_DSP ("yes")
    ) dut (
        .clk       (clk),
        .rst       (rst),
        .valid_in  (valid_in),
        .Re        (Re),
        .Im        (Im),
        .valid_out (valid_out),
        .MagSq     (MagSq)
    );

    task automatic check(
        input string test_name,
        input int    expected_mag,
        input bit    expected_valid
    );
        if (MagSq !== expected_mag || valid_out !== expected_valid) begin
            $error("[%s] FAIL: expected MagSq=%0d valid=%b, got MagSq=%0d valid=%b",
                   test_name, expected_mag, expected_valid, MagSq, valid_out);
        end else begin
            $display("[%s] PASS: MagSq=%0d, valid_out=%b", test_name, MagSq, valid_out);
        end
    endtask

    initial begin
        $display("========================================");
        $display("Тестбенч cmodule |Z|^2 (LATENCY=1)");
        $display("========================================");

        rst <= 1;
        valid_in <= 0;
        Re <= 0;
        Im <= 0;
        @(posedge clk);
        @(posedge clk);
        rst <= 0;

        Re <= 8'sd3; Im <= 8'sd4; valid_in <= 1'b1;
        @(posedge clk);

        Re <= -8'sd3; Im <= 8'sd4; valid_in <= 1'b1;
        check("3+4j", 25, 1'b1);
        @(posedge clk);

        Re <= 8'sd0; Im <= 8'sd0; valid_in <= 1'b1;
        check("-3+4j", 25, 1'b1);
        @(posedge clk);

        Re <= 8'sd127; Im <= 8'sd127; valid_in <= 1'b1;
        check("0+0j", 0, 1'b1);
        @(posedge clk);

        Re <= 8'sb10000000; Im <= 8'sb10000000; valid_in <= 1'b1;
        check("127+127j", 32258, 1'b1);
        @(posedge clk);

        Re <= 8'sd1; Im <= 8'sd1; valid_in <= 1'b1;
        check("-128-128j", 32768, 1'b1);
        @(posedge clk);


        Re <= 8'sd0; Im <= 8'sd0; valid_in <= 1'b0;
        check("1+1j", 2, 1'b1);
        @(posedge clk);

        repeat(2) @(posedge clk);
        
        $display("========================================");
        $display("Все тесты завершены");
        $display("========================================");
        $finish;
    end

    initial begin
        $dumpfile("cmodule.vcd");
        $dumpvars(0, tb_cmodule);
    end

endmodule