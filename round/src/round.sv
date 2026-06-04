`timescale 1ns / 1ps

module round #(
    parameter int IN_WIDTH  = 16,
    parameter int OUT_WIDTH = 8
) (
    input  logic clk,
    input  logic [IN_WIDTH-1:0]  i_data,
    output logic [OUT_WIDTH-1:0] o_data,
    output logic                  o_sat
);

    localparam int DROP = IN_WIDTH - OUT_WIDTH;
    
    logic [OUT_WIDTH:0] sum;
    
    assign sum = {1'b0, i_data[IN_WIDTH-1 : DROP]} + i_data[DROP-1];
    
    always_ff @(posedge clk) begin
        o_sat <= sum[OUT_WIDTH];
        o_data <= sum[OUT_WIDTH] ? {OUT_WIDTH{1'b1}} : sum[OUT_WIDTH-1:0];
    end

endmodule