module Wrapper_tb;
    
    reg clk, reset;
    
    Wrapper DUT(clk, reset);
        
    initial begin
        
       
        clk=0;
        reset=0;
        
        #20;
        
        reset=1;
        #10;
        
        reset=0;
        
        #750
        $stop;
  end
    
 always
  begin
    #5;
    clk=~clk;
    end
    
    
endmodule