`timescale 1ns / 1ps

module block_ram #(
    parameter AW = 11,
    parameter DW = 18
)(
    input  logic             clk,
    input  logic [AW-1:0]   addr,
    output logic [DW-1:0]   data
);

    (* ram_style = "block" *) logic [DW-1:0] mem [0:(1<<AW)-1];
    initial $readmemh("../gen/func_reverse_lut.hex", mem);
    
    always_ff @(posedge clk)
        data <= mem[addr];

endmodule
