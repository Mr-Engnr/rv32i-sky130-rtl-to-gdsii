// 32 x 32 register file with x0 hardwired to zero (variant of src/register_file.sv).
// Synchronous reset and falling-edge write as before; writes to x0 are ignored
// and reads of x0 always return 0.
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
        else if (write_en && rsd != 5'd0)
            reg_mem[rsd] <= data_write;
    end

    assign rd1 = (rs1 == 5'd0) ? 32'b0 : reg_mem[rs1];
    assign rd2 = (rs2 == 5'd0) ? 32'b0 : reg_mem[rs2];
endmodule
