`timescale 1ns/1ps

module Hazard_Detection_Unit(
    PCSrc_i,
    IDEX_MemRead_i,
    IDEX_RegRt_i,
    IFID_RegRs_i,
    IFID_RegRt_i,
    PCWrite_o,
    IFIDWrite_o,
    IDEX_Flush_o
);

input PCSrc_i;
input IDEX_MemRead_i;
input [5-1:0] IDEX_RegRt_i;
input [5-1:0] IFID_RegRs_i;
input [5-1:0] IFID_RegRt_i;

output PCWrite_o;
output IFIDWrite_o;
output IDEX_Flush_o;

reg PCWrite_o;
reg IFIDWrite_o;
reg IDEX_Flush_o; // 1 -> not flush, 0 -> flush

always @(*) begin
    if (PCSrc_i || 
       (IDEX_MemRead_i && (IDEX_RegRt_i == IFID_RegRs_i || IDEX_RegRt_i == IFID_RegRs_i ))) begin
        
        PCWrite_o <= 0;
        IFIDWrite_o <= 0;
        IDEX_Flush_o <= 0;
    end
    else begin 
        PCWrite_o <= 1;
        IFIDWrite_o <= 1;
        IDEX_Flush_o <= 1;    
    end
end 

endmodule