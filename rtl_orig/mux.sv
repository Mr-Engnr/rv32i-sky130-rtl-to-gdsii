module mux2X1 # (parameter width = 32)
  (
  input [width-1:0] a,b,
  input sel,
  output  reg [width-1:0] mux_out
  );
  always @ *
    begin 
        case(sel)
         1'b0: mux_out=a;
         1'b1: mux_out=b;
        endcase
    end
endmodule
