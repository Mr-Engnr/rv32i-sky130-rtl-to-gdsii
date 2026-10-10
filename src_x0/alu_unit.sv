module alu_unit(
input [3:0] alu_ctrl,
input [31:0] data1,data2,
output reg [31:0] alu_out,
output Zero
);

assign Zero = (alu_out==0); 

    always @(alu_ctrl or data1 or data2)
        case (alu_ctrl)
        0: alu_out = data1 & data2;
        1: alu_out = data1 | data2;
        2: alu_out = data1 + data2;
        4: alu_out = data1 << data2[4:0];
        6: alu_out = data1 - data2;
//        7: alu_out = (data1 < data2 )? 0:1;
//        8: alu_out = (data1 > data2 )? 0:1;
//        12: alu_out = ~(data1 | data2); 
        default: alu_out = 0;
       
        endcase
endmodule


