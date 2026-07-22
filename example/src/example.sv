
module example #(
    parameter int    WIDTH         = 8,
    parameter string USE_DSP_VALUE = "yes"
)(
    input  logic clk,
    input  logic rst,
    input  logic valid_in,
    input  logic signed   [WIDTH-1:0]   Re,
    input  logic signed   [WIDTH-1:0]   Im,
    output logic valid_out,
    output logic unsigned [2*WIDTH-1:0] MagSq
);

    cmodule #(
        .WIDTH ( WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) u_cmodule (
        .clk,
        .rst,
        .valid_in,
        .Re,
        .Im,
        .valid_out,
        .MagSq
    );

endmodule
