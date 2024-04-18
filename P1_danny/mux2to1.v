module mux2to1(
    input [7:0] a, 
    input [7:0] b,
    input sel,
    output [7:0] choice
);

assign choice = sel ? b : a;

endmodule