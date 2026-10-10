module imm_gen(   
    input [31:0] inst,
    output [31:0] imm_out
    );
    
    reg [6:0] opcode ;
    assign opcode = inst[6:0];
    reg [31:0] imm;
    
    always_comb
        begin
        case (opcode)
        7'b0010011,7'b0000011 :
        begin
         imm[11:0]=inst[31:20];
         imm[31:12]=$signed (inst[31]);
            end
            //i type ....addi, slli + ld
        //   7'b0100011 : imm = {$signed(inst[31]), inst[31:25], inst[11:7]}; 
        //s type sw
        7'b0100011 :
        begin    
        imm[4:0]=inst[11:7];
         imm[11:5]=inst[31:25];
         imm[31:12]=$signed (inst[31]);
         end

        7'b1100011 : imm = {{19{$signed(inst[31])}}, inst[31], inst[30:25],inst[7], inst[11:8], 1'b0}; //b type beq
        default : imm = 32'b0;
        
        endcase
        end
        
        assign imm_out = imm;
endmodule
