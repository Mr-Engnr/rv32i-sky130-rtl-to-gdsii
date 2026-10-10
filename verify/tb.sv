module Wrapper_tb;
    
    reg clk, reset;
    integer i;
    
`ifdef SRC
    wire [31:0] pc_o;
    Wrapper DUT(.clk(clk), .reset(reset), .pc_out(pc_o));
`else
    Wrapper DUT(clk, reset);
`endif
    always @(posedge clk) $display("PC t=%0t pc=%0d reset=%b", $time, DUT.pc_out, reset);
        
    initial begin
        
       
        clk=0;
        reset=0;
        
        #20;
        
        reset=1;
        #10;
        
        reset=0;
        
        #750
        $display("---FINAL---"); for (i=0;i<32;i=i+1) $display("REG[%0d]=%h", i, DUT.RF.reg_mem[i]); for (i=0;i<64;i=i+1) $display("MEM[%0d]=%h", i, DUT.DM.mem[i]); $finish;
  end
    
 always
  begin
    #5;
    clk=~clk;
    end
    
    
endmodule