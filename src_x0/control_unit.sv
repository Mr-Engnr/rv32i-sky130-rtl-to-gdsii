module control_unit
(
input [31:0] inst,
output reg branch, mem_rd, mem2reg, mem_write, alu_scr, reg_write,
output reg [1:0] alu_op
);

wire [6:0] opcode;
assign opcode = inst[6:0];

always_comb begin
    // defaults (also the "default" case of the original)
    alu_scr = 0; mem2reg = 0; reg_write = 0; mem_rd = 0;
    mem_write = 0; branch = 0; alu_op = 2'b11;
    case (opcode)
    7'b0110011: begin // R-type
        reg_write = 1; alu_op = 2'b10;
    end
    7'b0010011: begin // addi / slli
        alu_scr = 1; reg_write = 1; alu_op = 2'b10;
    end
    7'b0000011: begin // lw
        alu_scr = 1; mem2reg = 1; reg_write = 1; mem_rd = 1; alu_op = 2'b00;
    end
    7'b0100011: begin // sw (mem2reg was don't-care)
        alu_scr = 1; mem_write = 1; alu_op = 2'b00;
    end
    7'b1100011: begin // branch
        branch = 1; alu_op = 2'b01;
    end
    default: ;
    endcase
end
endmodule
