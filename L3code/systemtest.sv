module m();
    bit        clk = 0;
    bit [7:0]  in [2:0]; 
    bit        rw_select0, rw_select1, req0, req1, enable0, enable1;
    bit [7:0]  data_in0, data_in1, address0, address1, data_out;
    bit [31:0] instruction;

    system_bus mybus(.clk(clk), 
                     .req0(req0), 
                     .address0(address0), 
                     .data_in0(data_in0),
                     .rw_select0(rw_select0), 
                     .enable0(enable0),
                     .req1(req1), 
                     .address1(address1), 
                     .data_in1(data_in1),
                     .rw_select1(rw_select1), 
                     .enable1(enable1),
                     .data_out(data_out));

    initial begin
        clk <= 0;
        for (int c = 0; c < 1500; c++) begin
            #5 clk = ~clk;
        end
    end

    initial begin
        rw_select0 <= 0;
        rw_select1 <= 0;
        req0 <= 0;
        req1 <= 0;
        data_in0 <= 8'h00;
        data_in1 <= 8'h00;
        address0 <= 8'h00;
        address1 <= 8'h00;
        instruction <= 32'h00000000;
        $display("init");
    end

    initial begin

        repeat(10) begin
            #20
            {rw_select0, rw_select1} = $urandom_range(2'b00, 2'b11);
            {req0, req1} = $urandom_range(2'b00, 2'b11);
            address0 = $urandom_range(8'h00, 8'h05);
            address1 = $urandom_range(8'h00, 8'h05);

            $display("\nCPU0: request = %d, rw = %d, address = %b", req0, rw_select0, address0);
            $display("CPU1: request = %d, rw = %d, address = %b", req1, rw_select1, address1);

            if ((req0 & req1 & !mybus.flag) | (req0 & !req1)) begin

                $display("CPU0 granted");

                if (rw_select0) begin
                    data_in0 = $urandom_range(8'h00, 8'hff);
                    in[0] = $urandom_range(8'h00, 8'hff);
                    in[1] = $urandom_range(8'h00, 8'hff);
                    in[2] = $urandom_range(8'h00, 8'hff);

                    @(posedge enable0) begin
                        req0 <= 1'b0;
                        req1 <= 1'b0;
                        
                        $display("write byte 1: %h", data_in0);
   
                        @(posedge clk);
                        data_in0 = in[0];
                        $display("write byte 2: %h", data_in0);

                        @(posedge clk);
                        data_in0 = in[1];
                        $display("write byte 3: %h", data_in0);
 
                        @(posedge clk);
                        data_in0 = in[2];
                        $display("write byte 4: %h", data_in0);
                    end

                    @(negedge enable0);
                    $display("instruction %0d = %h%h%h%h\n", address0, mybus.mem.ram[address0*4], mybus.mem.ram[address0*4 + 1], mybus.mem.ram[address0*4 + 2], mybus.mem.ram[address0*4 + 3]);
                end else begin
                    @(posedge enable0) begin
                        req0 <= 1'b0;
                        req1 <= 1'b0;

                        repeat(2) @(posedge clk);
                        instruction[31:24] <= data_out;
                        $display("read byte 1");

                        @(posedge clk);
                        instruction[23:16] <= data_out;
                        $display("read byte 2");

                        @(posedge clk);
                        instruction[15:8] <= data_out;
                        $display("read byte 3");

                        @(posedge clk);
                        instruction[7:0] <= data_out;
                        $display("read byte 4");
                    end

                    @(posedge clk);
                    $display("instruction %0d = %h\n", address0, instruction);
                end

            end else if ((req0 & req1 & mybus.flag) | (!req0 & req1)) begin

                $display("CPU1 granted");

                if (rw_select1) begin
                    data_in1 = $urandom_range(8'h00, 8'hff);
                    in[0] = $urandom_range(8'h00, 8'hff);
                    in[1] = $urandom_range(8'h00, 8'hff);
                    in[2] = $urandom_range(8'h00, 8'hff);

                    @(posedge enable1) begin
                        req0 <= 1'b0;
                        req1 <= 1'b0;
                        
                        $display("write byte 1: %h", data_in1);

                        @(posedge clk);
                        data_in1 = in[0];
                        $display("write byte 2: %h", data_in1);

                        @(posedge clk);
                        data_in1 = in[1];
                        $display("write byte 3: %h", data_in1);

                        @(posedge clk);
                        data_in1 = in[2];
                        $display("write byte 4: %h", data_in1);
                    end

                    @(negedge enable1);
                    $display("instruction %0d = %h%h%h%h\n", address1, mybus.mem.ram[address1*4], mybus.mem.ram[address1*4 + 1], mybus.mem.ram[address1*4 + 2], mybus.mem.ram[address1*4 + 3]);
                end else begin
                    @(posedge enable1) begin
                        req0 <= 1'b0;
                        req1 <= 1'b0;

                        repeat(2) @(posedge clk);
                        instruction[31:24] <= data_out;
                        $display("read byte 1");

                        @(posedge clk);
                        instruction[23:16] <= data_out;
                        $display("read byte 2");

                        @(posedge clk);
                        instruction[15:8] <= data_out;
                        $display("read byte 3");

                        @(posedge clk);
                        instruction[7:0] <= data_out;
                        $display("read byte 4");
                    end

                    @(posedge clk);
                    $display("instruction %0d = %h\n", address1, instruction);
                end

            end else begin

                $display("no request from cpu's\n");

            end
        end

        rw_select0 = 1'b1;
        rw_select1 = 1'b1;
        req0 = 1'b0;
        req1 = 1'b0;
        address0 = 8'h04;
        address1 = 8'h05;

        #20

        data_in0 = 8'hBA;
        in[0] = 8'h5E;
        in[1] = 8'h00;
        in[2] = 8'h00;

        req0 = 1'b1;
        $display("Writing 0xba5e to loction 4");

        @(posedge enable0) begin
            req0 <= 1'b0;
                        
            $display("write byte 1: %h", data_in0);
   
            @(posedge clk);
            data_in0 = in[0];
            $display("write byte 2: %h", data_in0);

            @(posedge clk);
            data_in0 = in[1];
            $display("write byte 3: %h", data_in0);

            @(posedge clk);
            data_in0 = in[2];
            $display("write byte 4: %h", data_in0);
        end

        @(negedge enable0);
        $display("instruction %0d = %h%h%h%h\n", address0, mybus.mem.ram[address0*4], mybus.mem.ram[address0*4 + 1], mybus.mem.ram[address0*4 + 2], mybus.mem.ram[address0*4 + 3]);

        #20

        data_in1 = 8'hBA;
        in[0] = 8'h11;
        in[1] = 8'h00;
        in[2] = 8'h00;

        req1 = 1'b1;
        $display("Writing 0xba11 to loction 5");

        @(posedge enable1) begin
            req1 <= 1'b0;
                        
            $display("write byte 1: %h", data_in1);
   
            @(posedge clk);
            data_in1 = in[0];
            $display("write byte 2: %h", data_in1);

            @(posedge clk);
            data_in1 = in[1];
            $display("write byte 3: %h", data_in1);

            @(posedge clk);
            data_in1 = in[2];
            $display("write byte 4: %h", data_in1);
        end

        @(negedge enable1);
        $display("instruction %0d = %h%h%h%h\n", address1, mybus.mem.ram[address1*4], mybus.mem.ram[address1*4 + 1], mybus.mem.ram[address1*4 + 2], mybus.mem.ram[address1*4 + 3]);

    end
endmodule 