module alu(
    input [7:0] in_b,
    input [7:0] in_c,
    input [2:0] alu_op,
    output [7:0] alu_out
);

localparam ADD = 3'b000, SUB = 3'b001, AND = 3'b010, OR = 3'b011, SLT = 3'b100;

reg [7:0] temp_out = 0;
assign alu_out = temp_out;

always @(*) begin
    case (alu_op)
        ADD: temp_out = in_b + in_c;
        SUB: temp_out = in_b - in_c;
        AND: temp_out = in_b & in_c;
        OR: temp_out = in_b | in_c;
        SLT: temp_out = (in_b < in_c) ? 8'h01 : 8'h00;
        default : temp_out = 8'h00;
    endcase
end

endmodule