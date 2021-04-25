`timescale 1ns/1ps

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;


wire [32-1:0] r; // result of each ALU
wire [32-1:0] c; // carry out of each ALU
wire a_inv, b_inv;
wire ovr;

assign a_inv = ALU_control[3];
assign b_inv = ALU_control[2];

wire les;
wire zeo;

assign zeo = 1'b0;

always@( posedge clk or negedge rst_n ) begin
	if(rst_n == 1'b1) begin
        zero = !(
            r[00] | r[01] | r[02] | r[03] | r[04] | r[05] | r[06] | r[07] |
            r[08] | r[09] | r[10] | r[11] | r[12] | r[13] | r[14] | r[15] |
            r[16] | r[17] | r[18] | r[19] | r[20] | r[21] | r[22] | r[23] |
            r[24] | r[25] | r[26] | r[27] | r[28] | r[29] | r[30] | r[31]
        );
        result = r;
        cout = c[31];
        overflow = ovr;
	end
end

alu_top M00(src1[0], src2[0], les, a_inv, b_inv, b_inv, ALU_control[1:0], r[0], c[0]);
alu_top M01(src1[1], src2[1], zeo, a_inv, b_inv, c[0], ALU_control[1:0], r[1], c[1]);
alu_top M02(src1[2], src2[2], zeo, a_inv, b_inv, c[1], ALU_control[1:0], r[2], c[2]);
alu_top M03(src1[3], src2[3], zeo, a_inv, b_inv, c[2], ALU_control[1:0], r[3], c[3]);
alu_top M04(src1[4], src2[4], zeo, a_inv, b_inv, c[3], ALU_control[1:0], r[4], c[4]);

alu_top M05(src1[5], src2[5], zeo, a_inv, b_inv, c[4], ALU_control[1:0], r[5], c[5]);
alu_top M06(src1[6], src2[6], zeo, a_inv, b_inv, c[5], ALU_control[1:0], r[6], c[6]);
alu_top M07(src1[7], src2[7], zeo, a_inv, b_inv, c[6], ALU_control[1:0], r[7], c[7]);
alu_top M08(src1[8], src2[8], zeo, a_inv, b_inv, c[7], ALU_control[1:0], r[8], c[8]);
alu_top M09(src1[9], src2[9], zeo, a_inv, b_inv, c[8], ALU_control[1:0], r[9], c[9]);

alu_top M10(src1[10], src2[10], zeo, a_inv, b_inv, c[9], ALU_control[1:0], r[10], c[10]);
alu_top M11(src1[11], src2[11], zeo, a_inv, b_inv, c[10], ALU_control[1:0], r[11], c[11]);
alu_top M12(src1[12], src2[12], zeo, a_inv, b_inv, c[11], ALU_control[1:0], r[12], c[12]);
alu_top M13(src1[13], src2[13], zeo, a_inv, b_inv, c[12], ALU_control[1:0], r[13], c[13]);
alu_top M14(src1[14], src2[14], zeo, a_inv, b_inv, c[13], ALU_control[1:0], r[14], c[14]);

alu_top M15(src1[15], src2[15], zeo, a_inv, b_inv, c[14], ALU_control[1:0], r[15], c[15]);
alu_top M16(src1[16], src2[16], zeo, a_inv, b_inv, c[15], ALU_control[1:0], r[16], c[16]);
alu_top M17(src1[17], src2[17], zeo, a_inv, b_inv, c[16], ALU_control[1:0], r[17], c[17]);
alu_top M18(src1[18], src2[18], zeo, a_inv, b_inv, c[17], ALU_control[1:0], r[18], c[18]);
alu_top M19(src1[19], src2[19], zeo, a_inv, b_inv, c[18], ALU_control[1:0], r[19], c[19]);

alu_top M20(src1[20], src2[20], zeo, a_inv, b_inv, c[19], ALU_control[1:0], r[20], c[20]);
alu_top M21(src1[21], src2[21], zeo, a_inv, b_inv, c[20], ALU_control[1:0], r[21], c[21]);
alu_top M22(src1[22], src2[22], zeo, a_inv, b_inv, c[21], ALU_control[1:0], r[22], c[22]);
alu_top M23(src1[23], src2[23], zeo, a_inv, b_inv, c[22], ALU_control[1:0], r[23], c[23]);
alu_top M24(src1[24], src2[24], zeo, a_inv, b_inv, c[23], ALU_control[1:0], r[24], c[24]);

alu_top M25(src1[25], src2[25], zeo, a_inv, b_inv, c[24], ALU_control[1:0], r[25], c[25]);
alu_top M26(src1[26], src2[26], zeo, a_inv, b_inv, c[25], ALU_control[1:0], r[26], c[26]);
alu_top M27(src1[27], src2[27], zeo, a_inv, b_inv, c[26], ALU_control[1:0], r[27], c[27]);
alu_top M28(src1[28], src2[28], zeo, a_inv, b_inv, c[27], ALU_control[1:0], r[28], c[28]);
alu_top M29(src1[29], src2[29], zeo, a_inv, b_inv, c[28], ALU_control[1:0], r[29], c[29]);

alu_top M30(src1[30], src2[30], zeo, a_inv, b_inv, c[29], ALU_control[1:0], r[30], c[30]);

alu_las M31(src1[31], src2[31], zeo, a_inv, b_inv, c[30], ALU_control[1:0], r[31], c[31], les, ovr);

endmodule
