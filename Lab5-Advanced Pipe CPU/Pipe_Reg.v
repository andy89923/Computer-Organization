`timescale 1ns / 1ps

module Pipe_Reg(
    clk_i,
    rst_i,
    data_i,
    dataWrite_i,
    data_o,
);
					
parameter size = 0;

input dataWrite_i;
input   clk_i;		  
input   rst_i;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else if (dataWrite_i == 1'b1)
        data_o <= data_i;
end

endmodule	