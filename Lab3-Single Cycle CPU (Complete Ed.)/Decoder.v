`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
);
     
// I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
// Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

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

always @(*) begin 
	RegDst_o <= rfmt;
	RegWrite_o <= rfmt | addi | slti;
	Branch_o <= bieq;
	ALUSrc_o <= addi | slti;
end

// ALU_OP
always @(*) begin
	case(instr_op_i)
		6'b001000: ALU_op_o <= 3'b110;
		6'b001010: ALU_op_o <= 3'b101;
		6'b000000: ALU_op_o <= 3'b010;
		6'b000100: ALU_op_o <= 3'b001;
		default:
			ALU_op_o <= 3'b000;
	endcase
end

endmodule





                    
                    