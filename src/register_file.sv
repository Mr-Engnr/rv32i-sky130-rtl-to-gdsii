// 32 x 32 register file: synchronous reset, write on falling edge
// (as in the original). Single always block drives the array.
module register_file(
    input clk, write_en, reset,
    input logic [4:0] rs1, rs2, rsd,
    input logic [31:0] data_write,
    output logic [31:0] rd1, rd2
    );

    reg [31:0] reg_mem [0:31];
    integer i;

    always @(negedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                reg_mem[i] <= 32'b0;
        end
        else if (write_en)
            reg_mem[rsd] <= data_write;
    end

    assign rd1 = reg_mem[rs1];
    assign rd2 = reg_mem[rs2];
endmodule
