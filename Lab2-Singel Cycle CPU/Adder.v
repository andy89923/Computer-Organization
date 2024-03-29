`timescale 1ns/1ps
module Adder(
    src1_i,
	src2_i,
	sum_o
);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
output [32-1:0]	 sum_o;

//Internal Signals
reg    [32-1:0]	 sum_o;

    
//Main function
always @(*) begin 
	sum_o = src1_i + src2_i;
end

endmodule





                    
                    