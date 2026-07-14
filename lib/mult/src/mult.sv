`timescale 1ns / 1ps


module mult #(
    parameter A_WIDTH = 8,
    parameter B_WIDTH = 8,
    parameter USE_DSP_VALUE = 1'b1,
    parameter SIGNED_OPERANDS = 1'b1
)(
    input  logic clk,
    input  logic [A_WIDTH-1:0] a,
    input  logic [B_WIDTH-1:0] b,
    output logic [A_WIDTH+B_WIDTH-1:0] result
);
    
    generate
        if (SIGNED_OPERANDS) begin : gen_signed
            if (USE_DSP_VALUE) begin : gen_use_dsp_yes
                (* use_dsp = "yes" *)
                logic signed [A_WIDTH+B_WIDTH-1:0] result_next;
                assign result_next = $signed(a) * $signed(b);
                always_ff @(posedge clk) begin
                    result <= result_next;
                end
            end else begin : gen_use_dsp_no
                (* use_dsp = "no" *)
                logic signed [A_WIDTH+B_WIDTH-1:0] result_next;
                assign result_next = $signed(a) * $signed(b);
                always_ff @(posedge clk) begin
                    result <= result_next;
                end
            end
            
        end
        else begin : gen_unsigned
            if (USE_DSP_VALUE) begin : gen_use_dsp_yes
                (* use_dsp = "yes" *)
                logic [A_WIDTH+B_WIDTH-1:0] result_next;
                assign result_next = a * b;
                always_ff @(posedge clk) begin
                    result <= result_next;
                end
            end else begin : gen_use_dsp_no
                (* use_dsp = "no" *)
                logic [A_WIDTH+B_WIDTH-1:0] result_next;
                assign result_next = a * b;
                always_ff @(posedge clk) begin
                    result <= result_next;
                end
            end
        end
    endgenerate
endmodule

