`timescale 1ns / 1ps

(* USE_DSP = "yes" *)
module sum_pipeline #(
    parameter int  A_WIDTH       = 8,
    parameter int  B_WIDTH       = 8,
    parameter string  USE_DSP_VALUE = "yes"
)(
    input  logic clk,
    input  logic rst,

    input  logic valid_in,
    input  logic signed [A_WIDTH-1:0]  A,   
    input  logic signed [B_WIDTH-1:0]  B,   
    input  logic                       sub,

    output logic valid_out,
    output logic signed [(A_WIDTH > B_WIDTH ? A_WIDTH : B_WIDTH):0] S  
);

    localparam int MAX_WIDTH = (A_WIDTH > B_WIDTH) ? A_WIDTH : B_WIDTH;

    // Stage 0
    logic signed [MAX_WIDTH:0] A_ext;
    logic signed [MAX_WIDTH:0] B_ext;
    logic signed [MAX_WIDTH:0] sum_comb;

    always_comb begin
        A_ext = {{(MAX_WIDTH - A_WIDTH + 1){A[A_WIDTH-1]}}, A};
        B_ext = {{(MAX_WIDTH - B_WIDTH + 1){B[B_WIDTH-1]}}, B};

        if (sub)
            sum_comb = A_ext - B_ext;
        else
            sum_comb = A_ext + B_ext;
    end


    // Stage 1
    always_ff @(posedge clk) begin
        if (rst) begin
            S <= '0;
            valid_out <= '0;
        end else begin
            S <= sum_comb;
            valid_out <= valid_in;  
        end
    end

endmodule