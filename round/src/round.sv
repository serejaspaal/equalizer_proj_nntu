`timescale 1ns / 1ps
module round #(
    parameter int    IN_WIDTH  = 8,
    parameter int    OUT_WIDTH = 4,
    parameter string IN_SIGNED = "yes"      
) (
    input  logic clk,
    input  logic [IN_WIDTH-1:0]  i_data,
    output logic [OUT_WIDTH-1:0] o_data,
    output logic                 o_sat
);
    localparam signed [OUT_WIDTH:0] MAXP =  (1 <<< (OUT_WIDTH-1)) - 1;
    localparam signed [OUT_WIDTH:0] MINN = -(1 <<< (OUT_WIDTH-1));
    localparam int DROP = IN_WIDTH - OUT_WIDTH;
     
    generate
        if (IN_SIGNED == "yes") begin
            logic signed [OUT_WIDTH:0] sum; 
                
            always_comb begin
                sum = $signed(i_data[IN_WIDTH-1 : DROP]) + $signed({1'b0, i_data[DROP-1]});
            end

            always_ff @(posedge clk) begin
                if (sum > MAXP) begin            //saturation to max
                    o_data <= MAXP[OUT_WIDTH-1:0];
                    o_sat  <= 1'b1;
                end else if (sum < MINN) begin   //saturation to min
                    o_data <= MINN[OUT_WIDTH-1:0];
                    o_sat  <= 1'b1;
                end else begin
                    o_data <= sum[OUT_WIDTH-1:0];
                    o_sat  <= 1'b0;
                end
            end
        end
        else begin
            logic [OUT_WIDTH:0] sum;

            assign sum = {1'b0, i_data[IN_WIDTH-1 : DROP]} + i_data[DROP-1];

            always_ff @(posedge clk) begin
                o_sat  <= sum[OUT_WIDTH];        
                o_data <= sum[OUT_WIDTH] ? {OUT_WIDTH{1'b1}}: sum[OUT_WIDTH-1:0];                                                          
            end
        end
    endgenerate
endmodule