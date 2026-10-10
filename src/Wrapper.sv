// Single-cycle RV32I-subset core. Top module.
// pc_out is exposed so the logic is observable (otherwise synthesis
// removes the whole design, since the original top had no outputs).
module Wrapper(
    input  logic clk, reset,
    output logic [31:0] pc_out
    );
    localparam width = 32;

    // control / datapath nets (declared before use)
    logic [31:0] adder_out, alu_b_out, pc4_mux_out, inst, imme_out;
    logic [31:0] rd1, rd2, mux_out, alu_out, dmem_out, d_mux_out;
    logic [3:0]  alu_ctrl;
    logic [1:0]  alu_op;
    logic branch, mem_rd, mem2reg, mem_write, alu_scr, reg_write, Zero, pc_src;

    // PC
    pc PC(.mux_out(pc4_mux_out), .clk(clk), .reset(reset), .pc_out(pc_out));
    pc_4 PC4(pc_out, adder_out);
    alu #(.width(32)) BALU(.a(pc_out), .b(imme_out), .alu_out(alu_b_out));
    mux2X1 PC4MUX(.a(adder_out), .b(alu_b_out), .sel(pc_src), .mux_out(pc4_mux_out));
    andGate ANDG(.a(branch), .b(Zero), .c(pc_src));

    // Instruction memory
    instructionMemory IM(pc_out, inst);

    // Register file
    register_file RF(.rs1(inst[19:15]), .rs2(inst[24:20]), .rsd(inst[11:7]),
                     .data_write(d_mux_out), .rd1(rd1), .rd2(rd2),
                     .clk(clk), .write_en(reg_write), .reset(reset));
    mux2X1 #(.width(32)) MUX(.a(rd2), .b(imme_out), .sel(alu_scr), .mux_out(mux_out));
    imm_gen IG(.inst(inst), .imm_out(imme_out));

    // Control + ALU
    control_unit C(inst, branch, mem_rd, mem2reg, mem_write, alu_scr, reg_write, alu_op);
    alu_control ALUC(alu_op, inst, alu_ctrl);
    alu_unit ALUUNIT(.alu_ctrl(alu_ctrl), .data1(rd1), .data2(mux_out), .alu_out(alu_out), .Zero(Zero));

    // Data memory + writeback
    data_memory DM(.alu_out(alu_out), .data2(rd2), .mem_read(mem_rd), .mem_write(mem_write),
                   .clk(clk), .reset(reset), .dmem_out(dmem_out));
    mux2X1 DMUX(.a(alu_out), .b(dmem_out), .sel(mem2reg), .mux_out(d_mux_out));
endmodule
