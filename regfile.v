module regfile(
    input clk,
    input w_en,
    input [2:0] write_addr,
    input [7:0] write_data,
    input [2:0] read_addr1,
    input [2:0] read_addr2,
    output [7:0] read_data1,
    output [7:0] read_data2
);

    reg [7:0] regs [8];

    always @(posedge clk) begin
        if (w_en)
            regs[write_addr] <= write_data; 
    end

    assign read_data1 = (read_addr1) ? regs[read_addr1] : 8'h00;
    assign read_data2 = (read_addr2) ? regs[read_addr2] : 8'h00;

endmodule