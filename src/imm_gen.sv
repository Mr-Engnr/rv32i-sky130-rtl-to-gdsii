module imm_gen(
    input [31:0] inst,
    output [31:0] imm_out
    );

    wire [6:0] opcode = inst[6:0];
    reg [31:0] imm;

    always_comb begin
        case (opcode)
        7'b0010011, 7'b0000011: imm = {{20{inst[31]}}, inst[31:20]};               // I-type
        7'b0100011:             imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};   // S-type
        7'b1100011:             imm = {{19{inst[31]}}, inst[31], inst[30:25], inst[7], inst[11:8], 1'b0}; // B-type
        default:                imm = 32'b0;
        endcase
    end

    assign imm_out = imm;
endmodule
