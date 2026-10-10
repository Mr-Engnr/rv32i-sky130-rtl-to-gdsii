module alu #(parameter width = 8) 
( 
input  [width - 1:0] a, b, 
output reg [width - 1:0] alu_out 
);

assign alu_out = a + b ;
endmodule