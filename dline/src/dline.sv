`timescale 1ns / 1ps


module dline #(
    parameter DATA_WIDTH = 4,
    parameter DELAY = 3
)(
    input  logic i_clk,
    input  logic [DATA_WIDTH-1:0] i_data,
    output logic [DATA_WIDTH-1:0] o_data
);
    
    generate
        case (DELAY)
            0: begin : without_delay
                assign o_data = i_data;
            end
            1: begin : one_clk_delay
                always_ff @(posedge i_clk)
                    o_data <= i_data;
            end
            default: begin : custom_delay
                logic [DATA_WIDTH-1:0] delay_pipe [0:DELAY-1];
                always_ff @(posedge i_clk) begin
                    delay_pipe[0] <= i_data;
                    delay_pipe[1:DELAY-1] <= delay_pipe[0:DELAY-2];
                end
                assign o_data = delay_pipe[DELAY-1];
            end
        endcase
    endgenerate
    
    
endmodule

