`timescale 1ns / 1ps

module memory(address, data_in, clk, rw_select, data_out);
input [7:0] address;
input clk;
input rw_select; //0: Write, 1: Read
input [7:0] data_in;
output [7:0] data_out;

reg [7:0] RAM [0:511];

reg [8:0] newaddr;

localparam byte1 = 2'b00, byte2 = 2'b01, byte3 = 2'b10, byte4 = 2'b11;

reg [1:0] state = 2'b00, next_state = 2'b00;

initial begin
    $readmemh("mem_test.dat", RAM);
    newaddr = 9'b000000000;
end

assign data_out = rw_select ? RAM[newaddr] : 8'hZ;

always @(posedge clk) begin
    state <= next_state;
end

always @(state) begin
    case (state)
        byte1: next_state = rw_select ? byte2 : byte1;
        byte2: next_state = byte3;
        byte3: next_state = byte4;
        byte4: next_state = byte1;
    endcase
end

always @(posedge clk) begin
    case (state)
        byte1: begin
            newaddr = {address, 1'b0};
            if (!rw_select)
                RAM[newaddr] <= data_in;
        end
        byte2: begin
            newaddr = newaddr + 1'b1;
            if (!rw_select)
                RAM[newaddr] <= data_in;
        end
        byte3: begin
            newaddr = newaddr + 1'b1;
            if (!rw_select)
                RAM[newaddr] <= data_in;
        end
        byte4: begin
            newaddr = newaddr + 1'b1;
            if (!rw_select)
                RAM[newaddr] <= data_in;
        end
    endcase
end
    
endmodule
