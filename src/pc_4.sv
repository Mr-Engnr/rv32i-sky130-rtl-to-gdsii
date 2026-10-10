module pc_4
  (
  input [31:0] pc_out,
  output reg [31:0] adder_out
);
//  always @ (pc_out)
//  begin  
    assign adder_out= pc_out+4;
//  end
endmodule