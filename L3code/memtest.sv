module m();
    bit        clk = 0;
    bit        rw_select = 0;
    bit [7:0]  data_in, address, data_out;
    bit [31:0] instruction;

    memory myl(.clk(clk), .data_in(data_in), .address(address), .rw_select(rw_select), .data_out(data_out));

    initial begin
        clk <= 0;
        for (int c = 0; c < 100; c++) begin
            #5 clk = ~clk;
        end
    end

    initial begin
        #10
        data_in = 8'hff;
        address = 8'b00;
        #15
        rw_select = 1;
        repeat(6) @(posedge clk);
        rw_select = 0;
        data_in = 8'h00;
        //repeat(6) @(posedge clk);

        for (bit [7:0] i = 0; i < 32; i++) begin
            @(posedge clk)
            address = i;
            @(posedge clk)
            instruction[31:24] = data_out;
            @(posedge clk)
            instruction[23:16] = data_out;
            @(posedge clk)
            instruction[15:8] = data_out;
            @(posedge clk)
            instruction[7:0] = data_out;
            $display("Intruction %2h = %8h", i, instruction);
        end
    end
endmodule 