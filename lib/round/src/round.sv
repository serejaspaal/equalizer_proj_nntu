`timescale 1ns / 1ps
module round #(
    parameter int IN_WIDTH   = 8,
    parameter int OUT_WIDTH  = 4,
    parameter int IN_SIGNED  = 1,
    parameter int CLIP_WIDTH = 0
) (
    input  logic clk,
    input  logic [IN_WIDTH-1:0]  i_data,
    output logic [OUT_WIDTH-1:0] o_data,
    output logic                 o_sat
);

    localparam int DROP       = IN_WIDTH - OUT_WIDTH - CLIP_WIDTH;
    localparam int SUM_WIDTH  = OUT_WIDTH + CLIP_WIDTH + 1;

    localparam signed [SUM_WIDTH-1:0] MAXP =  (1 <<< (OUT_WIDTH-1)) - 1;
    localparam signed [SUM_WIDTH-1:0] MINN = -(1 <<< (OUT_WIDTH-1));
    localparam        [SUM_WIDTH-1:0] MAXU =  (1 <<< OUT_WIDTH) - 1;

    generate
        if (DROP == 0) begin
            always_ff @(posedge clk) begin
                o_data <= i_data[IN_WIDTH-1 : CLIP_WIDTH];
                o_sat  <= 1'b0;
            end
        end else if (IN_SIGNED) begin
            logic signed [SUM_WIDTH-1:0] sum;

            always_comb begin
                sum = $signed(i_data[IN_WIDTH-1 : DROP]) + $signed({1'b0, i_data[DROP-1]});
            end

            always_ff @(posedge clk) begin
                if (sum > MAXP) begin
                    o_data <= MAXP[OUT_WIDTH-1:0];
                    o_sat  <= 1'b1;
                end else if (sum < MINN) begin
                    o_data <= MINN[OUT_WIDTH-1:0];
                    o_sat  <= 1'b1;
                end else begin
                    o_data <= sum[OUT_WIDTH-1:0];
                    o_sat  <= 1'b0;
                end
            end
        end else begin
            logic [SUM_WIDTH-1:0] sum;

            always_comb begin
                sum = {1'b0, i_data[IN_WIDTH-1 : DROP]} + i_data[DROP-1];
            end

            always_ff @(posedge clk) begin
                if (sum > MAXU) begin
                    o_data <= MAXU[OUT_WIDTH-1:0];
                    o_sat  <= 1'b1;
                end else begin
                    o_data <= sum[OUT_WIDTH-1:0];
                    o_sat  <= 1'b0;
                end
            end
        end
    endgenerate
endmodule