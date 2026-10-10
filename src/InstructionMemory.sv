// Synthesizable ROM (64 words), word-indexed by pc[7:2].
// Contents are the values from the original initial block.
module instructionMemory
  (
  input logic [31:0] pc_out,
  output logic [31:0] inst
  );
  always_comb begin
    case (pc_out[7:2])
      6'd0: inst = 32'h00000293; // pc=0
      6'd1: inst = 32'h01900313; // pc=4
      6'd2: inst = 32'h0062a023; // pc=8
      6'd3: inst = 32'h00c00313; // pc=12
      6'd4: inst = 32'h0062a223; // pc=16
      6'd5: inst = 32'h03000313; // pc=20
      6'd6: inst = 32'h0062a423; // pc=24
      6'd7: inst = 32'h00700313; // pc=28
      6'd8: inst = 32'h0062a623; // pc=32
      6'd9: inst = 32'h01f00313; // pc=36
      6'd10: inst = 32'h0062a823; // pc=40
      6'd11: inst = 32'h00000393; // pc=44
      6'd12: inst = 32'h00000e13; // pc=48
      6'd13: inst = 32'h00500e93; // pc=52
      6'd14: inst = 32'h01de0e63; // pc=56
      6'd15: inst = 32'h002e1f13; // pc=60
      6'd16: inst = 32'h01e28fb3; // pc=64
      6'd17: inst = 32'h000fa303; // pc=68
      6'd18: inst = 32'h006383b3; // pc=72
      6'd19: inst = 32'h001e0e13; // pc=76
      6'd20: inst = 32'hfe0004e3; // pc=80
      6'd21: inst = 32'h00a00893; // pc=84
      6'd22: inst = 32'h00000073; // pc=88
      default: inst = 32'h00000000;
    endcase
  end
endmodule
