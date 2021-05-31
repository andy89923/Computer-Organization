`timescale 1ns / 1ps

module Pipe_CPU_1(
    clk_i,
    rst_i
);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/

wire [32-1:0] nxt_pc0, nxt_pc1, nxt_pcf, pc;
wire [32-1:0] ins;

wire [64-1:0] toIFID, otIFID;

/**** ID stage ****/

wire [32-1:0] rd1, rd2;
wire [32-1:0] ase;

wire [148-1:0] toIDEX, otIDEX;

// control signal
wire [3-1:0] ID_ALU_op;
wire ID_RegWrite, ID_ALUSrc;
wire ID_RegDst, ID_Branch;
wire ID_MemToReg, ID_MemRead, ID_MemWrite;

wire [32-1:0] ID_rd1, ID_rd2;

/**** EX stage ****/

wire [4-1 :0] alu_ctr;
wire [32-1:0] afs, al2;
wire [32-1:0] EX_BrD;

wire [107-1:0] toEXMEM, otEXMEM;

//control signal


/**** MEM stage ****/

wire [71-1:0] toMEMWB, otMEMWB;
wire [32-1:0] wrt_dat;

//control signal
wire PCSrc;


/**** WB stage ****/

//control signal
wire invMemToReg;

/****************************************
Instantiate modules
****************************************/
// Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
	.data0_i(nxt_pc0),
	.data1_i(nxt_pc1),
	.select_i(PCSrc),
	.data_o(nxt_pcf)
);

ProgramCounter PC(
    .clk_i(clk_i),      
    .rst_i (rst_i),     
    .pc_in_i(nxt_pcf) ,   
	.pc_out_o(pc) 
);

Instruction_Memory IM(
    .addr_i(pc),  
    .instr_o(ins)
);
			
Adder Add_pc(
    .src1_i(32'd4),     
    .src2_i(pc),     
    .sum_o(nxt_pc0)
);

assign toIFID[31: 0] = ins;
assign toIFID[63:32] = nxt_pc0;

Pipe_Reg #(.size(64)) IF_ID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i(toIFID),
    .data_o(otIFID)
);

// Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),      
    .rst_i(rst_i) ,     
    .RSaddr_i(otIFID[25:21]) ,  
    .RTaddr_i(otIFID[20:16]) ,  
    .RDaddr_i(otMEMWB[4:0]),  
    .RDdata_i(wrt_dat)  , 
    .RegWrite_i(otMEMWB[69]),
    .RSdata_o(rd1) ,  
    .RTdata_o(rd2)   
);

Decoder Control(
    .instr_op_i(otIFID[31:26]), 
    .RegWrite_o(ID_RegWrite), 
    .ALU_op_o(ID_ALU_op),   
    .ALUSrc_o(ID_ALUSrc),   
    .RegDst_o(ID_RegDst),   
	.Branch_o(ID_Branch),
	.MemToReg_o(ID_MemToReg),
	.MemRead_o(ID_MemRead),
	.MemWrite_o(ID_MemWrite)
);

Sign_Extend Sign_Extend(
    .data_i(otIFID[15:0]),
    .data_o(ase)
);

assign toIDEX[  4:  0] = otIFID[15:11];
assign toIDEX[  9:  5] = otIFID[20:16];
assign toIDEX[ 41: 10] = ase;
assign toIDEX[ 73: 42] = rd2;
assign toIDEX[105: 74] = rd1;
assign toIDEX[137:106] = otIFID[63:32];

assign toIDEX[138] = ID_RegWrite;
assign toIDEX[141:139] = ID_ALU_op;
assign toIDEX[142] = ID_ALUSrc;
assign toIDEX[143] = ID_RegDst;
assign toIDEX[144] = ID_Branch;
assign toIDEX[145] = ID_MemToReg;
assign toIDEX[146] = ID_MemRead;
assign toIDEX[147] = ID_MemWrite;

Pipe_Reg #(.size(148)) ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i(toIDEX),
    .data_o(otIDEX)
);

// Instantiate the components in EX stage	   
ALU ALU(
	.src1_i(otIDEX[105:74]),
    .src2_i(al2),
    .ctrl_i(alu_ctr),
    .result_o(toEXMEM[68:37]),
	.zero_o(toEXMEM[69])
);
		
ALU_Ctrl ALU_Control(
    .funct_i(otIDEX[ 15: 10]),   
    .ALUOp_i(otIDEX[141:139]),
    .ALUCtrl_o(alu_ctr) 
);

MUX_2to1 #(.size(32)) Mux1(
	.data0_i(otIDEX[73:42]),
	.data1_i(otIDEX[41:10]),
	.select_i(otIDEX[142]),
	.data_o(al2)
);
		
MUX_2to1 #(.size(5)) Mux2(
	.data0_i(otIDEX[9:5]),
	.data1_i(otIDEX[4:0]),
	.select_i(otIDEX[143]),
	.data_o(toEXMEM[4:0])
);

Shift_Left_Two_32 Shifter(
	.data_i(otIDEX[41:10]),
    .data_o(afs)
);

Adder Add_pc_branch(
    .src1_i(afs),
	.src2_i(otIFID[137:106]),
	.sum_o(toEXMEM[101:70])
);

assign toEXMEM[36:5] = otIDEX[73:42];

assign toEXMEM[102] = otIDEX[144]; // Branch
assign toEXMEM[103] = otIDEX[147]; // MemWrite
assign toEXMEM[104] = otIDEX[146]; // MemRead
assign toEXMEM[105] = otIDEX[145]; // MemToReg
assign toEXMEM[106] = otIDEX[138]; // RegWrite

Pipe_Reg #(.size(107)) EX_MEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i(toEXMEM),
    .data_o(otEXMEM)
);

// Instantiate the components in MEM stage
Data_Memory DM(
	.clk_i(clk_i),
    .addr_i(otEXMEM[68:37]),
    .data_i(otEXMEM[36: 5]),
    .MemRead_i(otEXMEM[104]),
    .MemWrite_i(otEXMEM[103]),
	.data_o(toMEMWB[68:37])
);

assign PCSrc = otEXMEM[102] & otEXMEM[69];

assign toMEMWB[69] = otEXMEM[106]; // RegWrite
assign toMEMWB[70] = otEXMEM[105]; // MemToReg

assign toMEMWB[ 4:0] = otEXMEM[4:0];
assign toMEMWB[36:5] = otEXMEM[68:37];

Pipe_Reg #(.size(71)) MEM_WB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i(toMEMWB),
    .data_o(otMEMWB)
);

// Instantiate the components in WB stage

assign invMemToReg = ~otMEMWB[70];

MUX_2to1 #(.size(32)) Mux3(
	.data0_i(otMEMWB[68:37]),
	.data1_i(otMEMWB[36:5]),
	.select_i(invMemToReg),
	.data_o(wrt_dat)
);

/****************************************
signal assignment
****************************************/

endmodule

