module memory 
    #(MEM_SIZE = 512) (
    input            clk,
    input [7:0]      data_in,
    input [7:0]      address,
    input            rw_select,
    output reg [7:0] data_out
    );
    
    localparam RST = 1'b0;
    localparam START = 1'b1;
    
    reg [7:0] ram [MEM_SIZE - 1:0];
    reg [1:0] counter;
    reg state;    
    
    initial begin
        $readmemh("mem_test.dat", ram);
        state <= RST;
        counter <= 2'b00;
        data_out <= 8'h00;
    end
    
    
    always @(posedge clk) begin
        case(state)    
            RST:
            begin       
               counter <= 2'b00;
               state <= START;
            end
        
            START:
            begin           

                if (counter == 2'b11) begin
                    counter <= 2'b00;
                end else begin
                    state <= START;  
                end     

                if (rw_select == 1'b0)  begin
                    data_out <= ram[(address[6:0] * 4) + counter];
                    counter <= counter + 1; 
                end else begin
                    ram[(address[6:0] * 4) + counter] = data_in;
                    counter <= counter + 1; 
                end  

            end                  
        endcase
    end  
endmodule
