//module data_memory 
//    (
//    input logic [31:0] alu_out,data2,
//    input logic mem_write,clk,reset,
//    output logic [31:0] dmem_out
//    );
    
//    reg [31:0]memory [0:256];
    
//    integer i;
    
//    always @ (posedge clk)
//    begin
//    if(reset)begin
//    for ( int i=0 ;i< 32'b1; i++) 
//            begin
//               memory[i] <= 32'b0;
//            end    
//    end
    
//    else begin
//       if (mem_write==1)
//        memory[alu_out]=data2;
//    end
//    end
//      assign dmem_out[31:0]= memory[alu_out];
////      assign dmem_out[31:8]=0;
//endmodule


module data_memory(

    input [31:0] alu_out,
    input [31:0] data2,
    input mem_read, mem_write, clk, reset,
    output reg [31:0] dmem_out
);
    
    //reg [31:0] dmemout;
    reg [31:0] mem [0:63];
    
    integer i;
    always @(posedge clk) begin
        
        if(reset) begin
            for(i = 0; i < 64; i = i+1) begin
                mem[i] <= 32'b0;
            end
        end
        else if (mem_write && !mem_read) begin
            mem[alu_out] <= data2;
        end        
    end
    
    always_comb begin
        if(mem_read && !mem_write) begin
            dmem_out = mem[alu_out];
        end    
    end
    
   // assign dmem_out = dmemout;
endmodule


