module cmult_a_real_b_coupl #(
    parameter int A_WIDTH = 8,
    parameter int B_WIDTH = 8,
    parameter string A_SIGNED = "yes",
    parameter string USE_DSP_VALUE = "yes"
)(
    input logic clk,
    input logic [A_WIDTH-1:0] a,
    input logic signed [B_WIDTH-1:0] x1,
    input logic signed [B_WIDTH-1:0] y1,
    output logic signed [A_WIDTH+B_WIDTH-1:0] out_re,
    output logic signed [A_WIDTH+B_WIDTH-1:0] out_im
    );
    
    (* use_dsp = USE_DSP_VALUE *)
    logic signed [A_WIDTH+B_WIDTH-1:0] p1;
    (* use_dsp = USE_DSP_VALUE *)
    logic signed [A_WIDTH+B_WIDTH-1:0] p2;
    generate
        if (A_SIGNED == "yes") begin : gen_s
            assign p1 = $signed(a)*x1;
            assign p2 = $signed(a)*y1;
        end else begin : gen_u
            assign p1 = $signed({1'b0, a})*x1;
            assign p2 = $signed({1'b0, a})*y1;
        end
    endgenerate
    always_ff @(posedge clk) begin
        out_re <= p1;
        out_im <= -p2;
    end
endmodule
