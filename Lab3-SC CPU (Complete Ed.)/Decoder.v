// 0816153

`timescale 1ns/1ps
module Decoder(
    instr_op_i,
    extra_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemToReg_o,
	Jump_o,
	MemRead_o,
	MemWrite_o
);
     
// I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] extra_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output [2-1:0] RegDst_o;
output         Branch_o;

output [2-1:0] MemToReg_o;
output [2-1:0] Jump_o;
output MemRead_o;
output MemWrite_o;

 
// Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [2-1:0] RegDst_o;
reg            Branch_o;

reg [2-1:0] MemToReg_o;
reg [2-1:0] Jump_o;
reg MemRead_o;
reg MemWrite_o;

// Parameter

// R-format 000,000
wire rfmt = (~instr_op_i[5]) & (~instr_op_i[4]) & (~instr_op_i[3]) &
			(~instr_op_i[2]) & (~instr_op_i[1]) & (~instr_op_i[0]);

// Addi 001,000
wire addi = (~instr_op_i[5]) & (~instr_op_i[4]) & ( instr_op_i[3]) &
			(~instr_op_i[2]) & (~instr_op_i[1]) & (~instr_op_i[0]);

// slti 001,010
wire slti = (~instr_op_i[5]) & (~instr_op_i[4]) & ( instr_op_i[3]) &
			(~instr_op_i[2]) & ( instr_op_i[1]) & (~instr_op_i[0]);

// beq 000,100
wire bieq = (~instr_op_i[5]) & (~instr_op_i[4]) & (~instr_op_i[3]) &
			( instr_op_i[2]) & (~instr_op_i[1]) & (~instr_op_i[0]);

// lw 100,011
wire lowd = ( instr_op_i[5]) & (~instr_op_i[4]) & (~instr_op_i[3]) &
			(~instr_op_i[2]) & ( instr_op_i[1]) & ( instr_op_i[0]);

// sw 101,011
wire stwd = ( instr_op_i[5]) & (~instr_op_i[4]) & ( instr_op_i[3]) &
			(~instr_op_i[2]) & ( instr_op_i[1]) & ( instr_op_i[0]);

// jump 000,010
wire jump = (~instr_op_i[5]) & (~instr_op_i[4]) & (~instr_op_i[3]) &
			(~instr_op_i[2]) & ( instr_op_i[1]) & (~instr_op_i[0]);

// jal  000,011
wire jpal = (~instr_op_i[5]) & (~instr_op_i[4]) & (~instr_op_i[3]) &
			(~instr_op_i[2]) & ( instr_op_i[1]) & ( instr_op_i[0]);

// jr   extra instra 001,000
wire jprt = (~extra_op_i[5]) & (~extra_op_i[4]) & ( extra_op_i[3]) &
			(~extra_op_i[2]) & (~extra_op_i[1]) & (~extra_op_i[0]);


always @(*) begin 
	RegDst_o[0] <= rfmt;
	RegDst_o[1] <= jpal;

	RegWrite_o <= rfmt | addi | slti | lowd | jpal;
	Branch_o <= bieq;
	ALUSrc_o <= addi | slti | lowd | stwd;
	
	MemToReg_o[0] <= lowd;
	MemToReg_o[1] <= jpal;
	MemRead_o <= lowd;
	MemWrite_o <= stwd;

	Jump_o[0] <= jump | jpal;
	Jump_o[1] <= (jprt & rfmt);
end

// ALU_OP
always @(*) begin
	case(instr_op_i)
		6'b001000: ALU_op_o <= 3'b110; // addi
		6'b001010: ALU_op_o <= 3'b101; // slti
		6'b000000: ALU_op_o <= 3'b010; // r-format
		6'b000100: ALU_op_o <= 3'b001; // beq
		default:
			ALU_op_o <= 3'b000; // lw & sw
	endcase
end

endmodule            