//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module ALU_Ctrl(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
wire op0 = (funct_i[0] | funct_i[3]) & ALUOp_i[1];
wire op1 = (~funct_i[2]) | (~ALUOp_i[1]);
wire op2 = (funct_i[1] & ALUOp_i[1])  | ALUOp_i[0];
wire op3 = 1'b0;

//Select exact operation
always @(*) begin
	// Not addi or slti, -> R-format & Beq
	if (ALUOp_i[2] == 1'b0) begin
		ALUCtrl_o[3] <= op3;
		ALUCtrl_o[2] <= op2;
		ALUCtrl_o[1] <= op1;
		ALUCtrl_o[0] <= op0;
	end
	else begin
		case(ALUOp_i)
			3'b110: ALUCtrl_o <= 4'b0010;
			3'b101: ALUCtrl_o <= 4'b0111;
			default:
				ALUCtrl_o = 4'b0000;
		endcase
	end
end

endmodule     





                    
                    