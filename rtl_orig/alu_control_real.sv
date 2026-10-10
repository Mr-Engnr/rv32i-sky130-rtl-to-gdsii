//module alu_control (
 
//input  [1:0] alu_op, 
//input  [31:0] inst, 
//output logic [3:0] alu_ctrl

 
//    );
//    wire [2:0] func3;
//    wire func7;
//    assign func7 = inst [30];
//    assign func3 = inst [14:12];
//    reg [3:0] control;
//    assign control = {func7, func3};
    
////    always_comb
////    begin
     
////    case (alu_op)
////    2'b00 : alu_ctrl = 4'b0010;
////    2'bx1 : alu_ctrl = 4'b0110;
////    2'b1x : 
////        case (control)
        
////            4'b0000 : alu_ctrl = 4'b0010;
////            4'b1000 : alu_ctrl = 4'b0110;
////            4'b0111 : alu_ctrl = 4'b0000;
////            4'b0110 : alu_ctrl = 4'b0001;
////            default : alu_ctrl = 4'b0000;
////        endcase   
         
////    endcase
    
////    end 
//  always @ *
//  begin
//    if (alu_op==2'b10 && func7==0)
//      alu_ctrl=4'b0010;
//  else if (alu_op==2'b10  && func7==1)
//     alu_ctrl=4'b0110;
//  else if (alu_op==2'b00 && func3==3'b000)
//    alu_ctrl=4'b0010;
//  else if (alu_op==2'b01 && func3==3'b000)
//      alu_ctrl=4'b0110;
//    else if (alu_op==2'b01 && func3==3'b100)
//      alu_ctrl=4'b0111;
//    end

//endmodule
      
      
      
      
      
module alu_control (
    
    input [1:0] alu_op,
    input [31:0] inst,
    output [3:0] alu_ctrl
);
    
    wire func7_30_bit;
    wire [2:0] func3;
    
    
    assign func7_30_bit = inst[30];
    assign func3 = inst[14:12];
    reg [3:0] alu_oper;
    
    
    always_comb begin
        case (alu_op)
            2'b00 : alu_oper = 4'b0010; //lw/sw (add)
            2'b01 : alu_oper = 4'b0110; //beq -> subtract
            2'b10, 2'b11 :           
                case ({func7_30_bit, func3})
                    4'b0000 : alu_oper = 4'b0010; //add
                    4'b1000 : alu_oper = 4'b0110; //sub
                    4'b0111 : alu_oper = 4'b0000; //and
                    4'b0110 : alu_oper = 4'b0001; //or
                    4'b0001 : alu_oper = 4'b0100; //SLL
                    default : alu_oper = 4'd0;
                endcase
            default : alu_oper = 4'd0;
        endcase
    end
    
    assign alu_ctrl = alu_oper;
endmodule