module alu(
    input [7:0] in_b;
    input [7:0] in_c;
    input [2:0] alu_op;
    output [7:0] alu_out
);

localparam ADD = 3'b000, SUB = 3'b001, AND = 3'b010, OR = 3'b011, SLT = 3'b100;

always @(*) begin
    case (alu_op)
        ADD: alu_out = in_b + ib_c;
        SUB: alu_out = in_b - in_c;
        AND: alu_out = in_b & in_c;
        OR: alu_out = in_b | in_c;
        SLT: alu_out = (in_b < in_c) ? 8'h01 : 8'h00;
        default : 8'hXX;
    endcase
end

endmodule