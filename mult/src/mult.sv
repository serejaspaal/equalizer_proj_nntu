`timescale 1ns / 1ps


module mult #(
    parameter A_WIDTH = 8,
    parameter B_WIDTH = 8,
    parameter string USE_DSP_VALUE = "yes",
    parameter string SIGNED_OPERANDS = "yes"
)(
    input  logic clk,
    input  logic [A_WIDTH-1:0] a,
    input  logic [B_WIDTH-1:0] b,
    output logic [A_WIDTH+B_WIDTH-1:0] result
);

    generate
        if (SIGNED_OPERANDS == "yes") begin
            (* use_dsp = USE_DSP_VALUE *)
            logic signed [A_WIDTH+B_WIDTH-1:0] result_next;
            assign result_next = $signed(a) * $signed(b);
            always_ff @(posedge clk) begin
                result <= result_next;
            end
        end
        else begin
            (* use_dsp = USE_DSP_VALUE *)
            logic [A_WIDTH+B_WIDTH-1:0] result_next;
            assign result_next = a * b;
            always_ff @(posedge clk) begin
                result <= result_next;
            end
        end
    endgenerate

endmodule

