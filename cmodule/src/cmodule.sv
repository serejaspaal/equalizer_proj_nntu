`timescale 1ns / 1ps

(* USE_DSP = "yes" *)             
module cmodule #(
    parameter int    WIDTH   = 8,
    parameter string USE_DSP = "yes"   
)(
    input  logic clk,
    input  logic rst,
    input  logic valid_in,
    input  logic signed [WIDTH-1:0] Re,
    input  logic signed [WIDTH-1:0] Im,
    output logic valid_out,
    output logic signed [2*WIDTH:0] MagSq
);


    // Stage 0
    logic signed [2*WIDTH:0] mag_sq_comb;

    always_comb begin
        mag_sq_comb = (2*WIDTH+1)'(Re * Re) + (2*WIDTH+1)'(Im * Im);
    end


    // Stage 1
    always_ff @(posedge clk) begin
        if (rst) begin
            MagSq     <= '0;
            valid_out <= '0;
        end else begin
            MagSq     <= mag_sq_comb;
            valid_out <= valid_in;
        end
    end

endmodule