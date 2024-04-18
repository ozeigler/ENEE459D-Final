module system_bus
    #(MEM_SIZE = 512) (
    input clk,
    input req0,
    input [7:0] address0,
    input [7:0] data_in0,
    input rw_select0,
    output reg       enable0,
    input req1,
    input [7:0] address1,
    input [7:0] data_in1,
    input rw_select1,
    output reg       enable1,
    output [7:0] data_out
    );
    
    localparam IDLE = 2'b00;
    localparam CPU0 = 2'b01;
    localparam CPU1 = 2'b10; 
    
    reg       rw_select, flag;
    reg [2:0] state, counter; 
      
    reg [7:0] data_in, address;
    
    memory mem(.clk       (clk),
               .data_in   (data_in),
               .address   (address),
               .rw_select (rw_select),
               .data_out  (data_out));
    
    initial begin
        flag <= 1'b0;
        state <= IDLE;
        counter <= 3'b000;
        data_in <= 8'h00;
        address <= 8'b00;
        rw_select <= 0;
        enable0 <= 1'b0;
        enable1 <= 1'b0;
    end
    
    always @(posedge clk) begin
        
        if (counter == 3'b000 && mem.counter == 2'b00) begin

            @(mem.counter == 2'b11);
            
            if (!req0 && !req1) begin
                state <= IDLE;
            end else if (req0 && !req1) begin
                state <= CPU0;
                counter <= counter + 1;
            end else if (!req0 && req1) begin
                state <= CPU1;
                counter <= counter + 1;
            end else begin
                if (flag == 1'b0) begin
                    state <= CPU0;
                end else begin
                    state <= CPU1;
                end
                flag <= !flag;
                counter <= counter + 1;
            end
                
        end else if (counter == 3'b100) begin
            state <= IDLE;
            counter <= 3'b000;
        end else begin
            state <= state;
            counter <= counter + 1;
        end       
    end
    
    always @(posedge clk) begin
        case (state)
        
            IDLE:
            begin
                data_in <= 8'h00;
                rw_select <= 1'b0;
                address <= 8'h00;
                
                enable0 <= 1'b0;
                enable1 <= 1'b0;
            end
            
            CPU0:
            begin            
                data_in <= data_in0;
                rw_select <= rw_select0;
                address <= address0;
                
                enable0 <= 1'b1;
                enable1 <= 1'b0;  
            end
            
            CPU1:
            begin
                data_in <= data_in1;
                rw_select <= rw_select1;
                address <= address1;
                
                enable0 <= 1'b0;
                enable1 <= 1'b1;  
            end
        endcase
    end
endmodule
