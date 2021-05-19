// 0816153

`timescale 1ns/1ps

module Simple_Single_CPU(
    clk_i,
	rst_i
);
		
// I/O port
input   clk_i;
input   rst_i;

// Internal Signles

wire [32-1:0] pc;
wire [32-1:0] nxt_pc0, nxt_pc1, fin_pc;
wire [32-1:0] jup_ads, pc_ch0;

// Greate componentes
ProgramCounter PC(
    .clk_i(clk_i),      
    .rst_i (rst_i),     
    .pc_in_i(fin_pc), 
	.pc_out_o(pc)
);

Adder Adder1(
    .src1_i(32'd4),     
    .src2_i(pc),     
    .sum_o(nxt_pc0)    
);

Shift_Left_Two_with_prv JumpAdd(
    .data_i(instr[25:0]),
    .prv_i(nxt_pc0[31:28]),
    .data_o(jup_ads)
);

wire [32-1:0] instr;

Instr_Memory IM(
    .pc_addr_i(pc),  
    .instr_o(instr)
);

wire [5-1:0] wrt_reg;

wire [2-1:0] RegDst;
wire RegWrite, Branch;
wire [3-1:0] aluOp;
wire aluSrc;

MUX_4to1 #(.size(5)) Mux_Write_Reg(
    .data0_i(instr[20:16]),
    .data1_i(instr[15:11]),
    .data2_i(5'b11111),
    .data3_i(5'b00000),
    .select_i(RegDst),
    .data_o(wrt_reg)
);	

wire [32-1:0] rd1, rd2;
wire [32-1:0] wrt_dat, alu_out;

Reg_File Registers(
    .clk_i(clk_i),      
    .rst_i(rst_i) ,     
    .RSaddr_i(instr[25:21]),
    .RTaddr_i(instr[20:16]),  
    .RDaddr_i(wrt_reg),  
    .RDdata_i(wrt_dat), 
    .RegWrite_i (RegWrite),
    .RSdata_o(rd1),  
    .RTdata_o(rd2)   
);

wire [2-1:0] MemToReg, Jump;
wire MemRead, MemWrite;
wire [32-1:0] read_data;

Decoder Decoder(
    .instr_op_i(instr[31:26]),
    .extra_op_i(instr[5:0]),
    .RegWrite_o(RegWrite), 
    .ALU_op_o(aluOp),   
    .ALUSrc_o(aluSrc),   
    .RegDst_o(RegDst),   
	.Branch_o(Branch),
    .MemToReg_o(MemToReg),
    .Jump_o(Jump),
    .MemRead_o(MemRead),
    .MemWrite_o(MemWrite)
);

wire [4-1:0] aluCTtoalu;

ALU_Ctrl AC(
    .funct_i(instr[5:0]),   
    .ALUOp_i(aluOp),   
    .ALUCtrl_o(aluCTtoalu) 
);

wire [32-1:0] aft_sgn;

Sign_Extend SE(
    .data_i(instr[15:0]),
    .data_o(aft_sgn)
);

wire [32-1:0] alu_src;

MUX_2to1 #(.size(32)) Mux_ALUSrc(
    .data0_i(rd2),
    .data1_i(aft_sgn),
    .select_i(aluSrc),
    .data_o(alu_src)
);
		
wire zeo;

ALU ALU(
    .src1_i(rd1),
    .src2_i(alu_src),
    .ctrl_i(aluCTtoalu),
    .result_o(alu_out),
	.zero_o(zeo)
);

MUX_4to1 #(.size(32)) Mux_Write_Dat(
    .data0_i(alu_out),
    .data1_i(read_data),
    .data2_i(nxt_pc0),
    .data3_i(0),
    .select_i(MemToReg),
    .data_o(wrt_dat)
);

Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(alu_out),
    .data_i(rd2),
    .MemRead_i(MemRead),
    .MemWrite_i(MemWrite),
    .data_o(read_data)
);

wire [32-1:0] aft_sft;

Adder Adder2(
    .src1_i(nxt_pc0),     
    .src2_i(aft_sft),     
    .sum_o(nxt_pc1)
);
		
Shift_Left_Two_32 Shifter(
    .data_i(aft_sgn),
    .data_o(aft_sft)
); 		

wire nxt_slc;

and pcSLC(nxt_slc, Branch, zeo);
	
MUX_2to1 #(.size(32)) Mux_PC_Source_1(
    .data0_i(nxt_pc0),
    .data1_i(nxt_pc1),
    .select_i(nxt_slc),
    .data_o(pc_ch0)
);

MUX_4to1 #(.size(32)) Mux_PC_Source_2(
    .data0_i(pc_ch0),
    .data1_i(jup_ads),
    .data2_i(rd1),
    .data3_i(0),
    .select_i(Jump),
    .data_o(fin_pc)
); 

endmodule