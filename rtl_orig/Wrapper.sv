module Wrapper(

input logic clk,reset

    );
 //######################################PC
 
//    Program Counter
    logic [31:0] pc_out;
    pc PC(.mux_out(pc4_mux_out), .clk(clk), .reset(reset), .pc_out(pc_out));
    
    //    PC + 4 PCADDER
     logic [31:0] adder_out;
        pc_4 PC4(pc_out,adder_out);  
        
        //    BRANCH ADDER ALU
     logic [31:0] alu_b_out;
    alu #(.width(32)) BALU(.a(pc_out), .b(imme_out),.alu_out(alu_b_out));    
    
    //    PC + 4 - Multiplexers (2:1)
     logic [width-1:0] pc4_mux_out ;
    mux2X1 PC4MUX(.a(adder_out),.b(alu_b_out),.sel(pc_src),.mux_out(pc4_mux_out));
    
    //    Branch Comparator (AND Gate) 
     logic pc_src;
    andGate ANDG(.a(branch),.b(Zero),.c(pc_src));
 
    
    //#############################################################
    
//    Instruction Memory
    logic [31:0] inst;
    instructionMemory IM(pc_out, inst);
    
//###########################################Register File
    logic [31:0] data_write,rd1 , rd2;
    logic write_en;
    register_file RF(.rs1(inst[19:15]), .rs2(inst[24:20]), .rsd(inst[11:7]) ,.data_write(d_mux_out), .rd1(rd1) , .rd2(rd2) ,.clk(clk)  ,.write_en(reg_write) , .reset(reset) );
    
    //    Multiplexers (2:1)
     localparam width = 32;
     logic [width-1:0] mux_out ;
    mux2X1 #(.width(32))MUX(.a(rd2),.b(imme_out),.sel(alu_scr),.mux_out(mux_out));
    
    //~##3######################################
    
//    Immediate Generator
     logic [31:0] imme_out;
    imm_gen IG(.inst(inst), .imm_out(imme_out));
    
//######################################## ALU / Execute Unit  

    //    Control Signals
    logic branch, mem_rd, mem2reg,mem_write,alu_scr, reg_write;
    logic [1:0]alu_op;
    control_unit C(inst,branch, mem_rd, mem2reg,mem_write,alu_scr, reg_write,alu_op);
    
    //    ALU Control Unit 
    logic [3:0] alu_ctrl;
    alu_control ALUC(alu_op,inst,alu_ctrl);
    
    //ALU UNIT
    logic [31:0] alu_out;
    logic Zero;
    alu_unit ALUUNIT(.alu_ctrl(alu_ctrl),.data1(rd1),.data2(mux_out),.alu_out(alu_out), .Zero(Zero));
    
//###################################################
   
    
//    Data Memory 
     logic [31:0] dmem_out;
     logic mem_write;
    data_memory DM(.alu_out(alu_out),.data2(rd2),.mem_read(mem_rd),.mem_write(mem_write),.clk(clk),.reset(reset),.dmem_out(dmem_out));
    
 //   DATA - Multiplexers (2:1)
     logic [width-1:0] d_mux_out ;
    mux2X1 DMUX(.a(alu_out),.b(dmem_out),.sel(mem2reg),.mux_out(d_mux_out));
    
 
    

    

 
    

    
endmodule
