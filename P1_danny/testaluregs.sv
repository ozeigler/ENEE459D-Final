module testaluregs();

    integer   c;
    bit       clk, enb;
    bit [2:0] alu_op;
    bit [2:0] write_addr;
    bit [7:0] write_data;
    bit [7:0] reg0, reg1, reg2;
    bit [2:0] read_addr1;
    bit [2:0] read_addr2;
    wire [7:0] data1, data2, alu_out;

    regfile rf(.clk(clk),
               .w_en(enb),
               .write_addr(write_addr),
               .write_data(write_data),
               .read_addr1(read_addr1),
               .read_addr2(read_addr2),
               .read_data1(data1),
               .read_data2(data2));

    alu al(.in_b(reg0),
           .in_c(reg1),
           .alu_op(alu_op),
           .alu_out(alu_out));

    initial begin
        clk <= 0;
        enb = 0;
        alu_op = 0;
        write_addr = 0;
        write_data = 0;
        read_addr1 = 1;
        read_addr2 = 2;

        for (c = 0; c < 1500; c = c + 1) begin
            #1 clk = ~clk;
        end
    end

    initial begin

        #20

        write_addr = 1;
        write_data = 2;
        @(negedge clk)
        enb = 1;
        @(negedge clk)
        enb = 0;

        #5

        write_addr = 2;
        write_data = 3;
        @(negedge clk)
        enb = 1;
        @(negedge clk)
        enb = 0;

        #5

        reg0 = data1;
        reg1 = data2;

// ----------------reg0 = 2 reg 1 = 3-------------------------------------------

        #5

// ----------------addition-------------------------------------------

        write_addr = 3;
        write_data = alu_out;
        @(negedge clk)
        enb = 1;
        @(negedge clk)
        enb = 0;

        #5

        read_addr1 = 3;

        #5

        reg2 = data1;

        #5

        $display("\n\n\n%01d + %01d = %01d\n", reg0, reg1, reg2);

        #5

// ----------------AND-------------------------------------------
        alu_op = 2;

        #5

        write_addr = 3;
        write_data = alu_out;
        @(negedge clk)
        enb = 1;
        @(negedge clk)
        enb = 0;

        #5

        read_addr1 = 3;

        #5

        reg2 = data1;

        #5

        $display("\n%03b and %03b = %03b\n", reg0, reg1, reg2);

        #5

// ----------------OR-------------------------------------------
        alu_op = 3;

        #5

        write_addr = 3;
        write_data = alu_out;
        @(negedge clk)
        enb = 1;
        @(negedge clk)
        enb = 0;

        #5

        read_addr1 = 3;

        #5

        reg2 = data1;

        #5

        $display("\n%03b or %03b = %03b\n\n\n", reg0, reg1, reg2);

        $finish;



    end
    
endmodule