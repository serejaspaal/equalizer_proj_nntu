`timescale 1ns / 1ps

module tb_round_array;

    parameter IN_WIDTH  = 8;
    parameter OUT_WIDTH = 4;
    
    logic clk;
    logic [IN_WIDTH-1:0]  i_data;
    logic [OUT_WIDTH-1:0] o_data;
    logic                 o_sat;
    
    round #(
        .IN_WIDTH  (IN_WIDTH),
        .OUT_WIDTH (OUT_WIDTH)
    ) uut (
        .clk    (clk),
        .i_data (i_data),
        .o_data (o_data),
        .o_sat  (o_sat)
    );
    
logic [IN_WIDTH-1:0] test_vectors [] = {
    8'b0000_0000,
    8'b0000_0001,  
    8'b0000_0111,  
    8'b0000_1000,
    8'b0000_1111,  
    8'b0001_0000,  
    8'b0001_0001,  
    8'b0001_1111, 
    8'b0010_0000,  
    8'b0111_1111,  
    8'b1000_0000, 
    8'b1000_0001, 
    8'b1000_1111, 
    8'b1111_0000,  
    8'b1111_1000,  
    8'b1111_1111
};

logic [OUT_WIDTH-1:0] expected [] = {
    4'b0000, 
    4'b0000, 
    4'b0000, 
    4'b0001,
    4'b0001, 
    4'b0001, 
    4'b0001,
    4'b0010, 
    4'b0010, 
    4'b1000,
    4'b1000,
    4'b1000,
    4'b1001,
    4'b1111,
    4'b1111,
    4'b1111
};

logic [1:0] expected_sat [] = {
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b1,
    1'b1
};
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        automatic int error_count = 0;
        
        for (int i = 0; i < test_vectors.size(); i++) begin
            i_data = test_vectors[i];
            repeat(2) @(posedge clk);
            
            if (o_data == expected[i] && o_sat == expected_sat[i]) begin
                $display("i_data=%4b.%4b -> o_data=%4b, o_sat=%1b OK", i_data[7:4], i_data[3:0], o_data, o_sat);
            end
            else begin
            $display("i_data=%4b.%4b -> o_data=%4b, o_sat=%1b ERROR! expected=%4b, %1b", i_data[7:4], i_data[3:0], o_data, o_sat, expected[i], expected_sat[i]);
                error_count++;
            end
        end
        
        $display("\n=== RESULT: number of errors %0d ===", error_count);
        if (error_count == 0) $display("=== ALL TESTS PASSED ===");
        
        $finish;
    end

endmodule