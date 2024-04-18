module mux4to1(
    input [7:0] a, 
    input [7:0] b,
    input [7:0] c, 
    input [7:0] d,
    input [1:0] sel,
    output [7:0] choice
);

    always @(*) begin
        case (sel)
            2'b00: choice = a;
            2'b01: choice = b;
            2'b10: choice = c;
            2'b11: choice = d;
            default: choice = 8'hXX;
        endcase
    end

endmodule