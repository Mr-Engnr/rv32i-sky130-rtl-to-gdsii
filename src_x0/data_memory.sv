// 64 x 32 flop array. Index is alu_out[5:0], matching the original
// behaviour where the (byte) ALU result indexed the 64-entry array directly.
module data_memory(
    input [31:0] alu_out,
    input [31:0] data2,
    input mem_read, mem_write, clk, reset,
    output reg [31:0] dmem_out
);
    reg [31:0] mem [0:63];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 64; i = i + 1)
                mem[i] <= 32'b0;
        end
        else if (mem_write && !mem_read) begin
            mem[alu_out[5:0]] <= data2;
        end
    end

    always_comb begin
        if (mem_read && !mem_write)
            dmem_out = mem[alu_out[5:0]];
        else
            dmem_out = 32'b0;
    end
endmodule
