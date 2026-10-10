module pc
 (
 input logic [31:0] mux_out,
 input logic clk ,reset,
 output logic [31:0] pc_out);
 
 logic [31:0] pco;
 always@(posedge clk or posedge reset)
    begin 
      if (reset==1)
        begin 
          pco<=32'b0;
        end
      else 
        begin 
          pco<=mux_out;
        end 
    end
    
    assign pc_out=pco;
    
endmodule 


