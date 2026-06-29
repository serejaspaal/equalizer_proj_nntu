`timescale 1ns / 1ps
module sum #(
    parameter  int    A_WIDTH         = 8,
    parameter  int    B_WIDTH         = 8,
    parameter  string USE_DSP_VALUE   = "yes",
    parameter  string SIGNED_OPERANDS = "yes",   
    localparam int    MAX_WIDTH       = (A_WIDTH > B_WIDTH) ? A_WIDTH : B_WIDTH
)(
    input  logic clk,
    input  logic rst,
    input  logic valid_in,
    input  logic [A_WIDTH-1:0] A,
    input  logic [B_WIDTH-1:0] B,
    input  logic               sub,
    output logic valid_out,
    output logic [MAX_WIDTH:0] S,           
    output logic               underflow     
                                             
);
    generate
        if (SIGNED_OPERANDS == "yes") begin
            (* use_dsp = USE_DSP_VALUE *) logic signed [MAX_WIDTH:0] sum_next;
            always_comb begin
                if (sub) sum_next = $signed(A) - $signed(B);
                else     sum_next = $signed(A) + $signed(B);
            end
            always_ff @(posedge clk) begin
                if (rst) begin
                    S <= '0; valid_out <= '0;
                end else begin
                    S         <= sum_next;
                    valid_out <= valid_in;
                end
            end
            assign underflow = 1'b0;
        end
        else begin
            (* use_dsp = USE_DSP_VALUE *) logic [MAX_WIDTH:0] sum_next;
            always_comb begin
                if (sub) sum_next = A - B;
                else     sum_next = A + B;
            end
            always_ff @(posedge clk) begin
                if (rst) begin
                    S <= '0; valid_out <= '0; underflow <= '0;
                end else begin
                    S         <= sum_next;
                    valid_out <= valid_in;
                    underflow <= sub && (A < B);   
                end
            end
        end
    endgenerate
endmodule