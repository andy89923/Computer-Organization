// 0816153

`timescale 1ns/1ps

module Shift_Left_Two_with_prv(
	data_i,
	prv_i, // first 4 bits
	data_o
);

input [26-1:0] data_i;
input [ 4-1:0] prv_i;

output [32-1:0] data_o;

assign data_o[31:28] = prv_i;
assign data_o[27: 2] = data_i;
assign data_o[ 1: 0] = 2'b00;

endmodule