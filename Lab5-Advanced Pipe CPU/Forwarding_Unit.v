`timescale 1ns/1ps

module Forwarding_Unit(
	RegRs_i,
	RegRt_i,
	EXMEM_RegDes_i,
	MEMWB_RegDes_i,
	EXMEM_WriteBack_i,
	MEMWB_WriteBack_i,
	Mux_Src1_o,
	Mux_Src2_o
);

input [5-1:0] RegRs_i;
input [5-1:0] RegRt_i;
input [5-1:0] EXMEM_RegDes_i;
input [5-1:0] MEMWB_RegDes_i;
input EXMEM_WriteBack_i;
input MEMWB_WriteBack_i;

output [2-1:0] Mux_Src1_o;
output [2-1:0] Mux_Src2_o;

reg [2-1:0] Mux_Src1_o;
reg [2-1:0] Mux_Src2_o;

always @(*) begin
	if (EXMEM_WriteBack_i && EXMEM_RegDes_i != 5'd0 && EXMEM_RegDes_i == RegRs_i) begin
		Mux_Src1_o <= 2'b10;
	end
	else if (MEMWB_WriteBack_i && MEMWB_RegDes_i != 5'd0 && MEMWB_RegDes_i == RegRs_i) begin
		Mux_Src1_o <= 2'b01;
	end 
	else begin
		Mux_Src1_o <= 2'b00;	
	end
end

always @(*) begin 
	if (EXMEM_WriteBack_i && EXMEM_RegDes_i != 5'd0 && EXMEM_RegDes_i == RegRt_i) begin 
		Mux_Src2_o <= 2'b10;
	end 
	else if (MEMWB_WriteBack_i && MEMWB_RegDes_i != 5'd0 && MEMWB_RegDes_i == RegRt_i) begin
		Mux_Src2_o <= 2'b01;
	end
	else begin
		Mux_Src2_o <= 2'b00;	
	end

end

endmodule