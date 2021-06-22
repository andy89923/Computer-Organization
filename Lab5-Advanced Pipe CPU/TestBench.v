`timescale 1ns / 1ps
//Subject:     CO project 5 - Test Bench
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

`define CYCLE_TIME 10			

module TestBench;

// Internal Signals
reg         CLK;
reg         RST;
integer     count;
integer     i;
integer     handle;

// Greate tested modle  
Pipe_CPU_1 cpu(
    .clk_i(CLK),
    .rst_i(RST)
);
 
// Main function

always #(`CYCLE_TIME/2) CLK = ~CLK;	

initial begin
    CLK = 0;
    RST = 0;
    count = 0;
   
    // instruction memory
    for(i=0; i<32; i=i+1)
    begin
        cpu.IM.instruction_file[i] = 32'b0;
    end

    // Read instruction from "CO_P5_test_1.txt"  
    $readmemb("./testcase/CO_P5_test_1.txt", cpu.IM.instruction_file); 
    
    // data memory
    for(i=0; i<128; i=i+1)
    begin
        cpu.DM.Mem[i] = 8'b0;
    end
    
    #(`CYCLE_TIME)      RST = 1;
    #(`CYCLE_TIME*100)   $stop;
    //#(`CYCLE_TIME*20)	$fclose(handle); $stop;
end

//Print result to "CO_P4_Result.dat"
always@(posedge CLK) begin
    count = count + 1;

    //print result to transcript 
    $display("Register===========================================================");
    $display(" r0=%4d,  r1=%4d,  r2=%4d,  r3=%4d,  r4=%4d,  r5=%4d,  r6=%4d,  r7=%4d",
    cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], cpu.RF.Reg_File[4], 
    cpu.RF.Reg_File[5], cpu.RF.Reg_File[6], cpu.RF.Reg_File[7],
    );
    $display(" r8=%4d,  r9=%4d, r10=%4d, r11=%4d, r12=%4d, r13=%4d, r14=%4d, r15=%4d",
    cpu.RF.Reg_File[8], cpu.RF.Reg_File[9], cpu.RF.Reg_File[10], cpu.RF.Reg_File[11], cpu.RF.Reg_File[12], 
    cpu.RF.Reg_File[13], cpu.RF.Reg_File[14], cpu.RF.Reg_File[15],
    );
    $display("r16=%4d, r17=%4d, r18=%4d, r19=%4d, r20=%4d, r21=%4d, r22=%4d, r23=%4d",
    cpu.RF.Reg_File[16], cpu.RF.Reg_File[17], cpu.RF.Reg_File[18], cpu.RF.Reg_File[19], cpu.RF.Reg_File[20], 
    cpu.RF.Reg_File[21], cpu.RF.Reg_File[22], cpu.RF.Reg_File[23],
    );
    $display("r24=%4d, r25=%4d, r26=%4d, r27=%4d, r28=%4d, r29=%4d, r30=%4d, r31=%4d",
    cpu.RF.Reg_File[24], cpu.RF.Reg_File[25], cpu.RF.Reg_File[26], cpu.RF.Reg_File[27], cpu.RF.Reg_File[28], 
    cpu.RF.Reg_File[29], cpu.RF.Reg_File[30], cpu.RF.Reg_File[31],
    );

    $display("Memory===========================================================");
    $display(" m0=%4d,  m1=%4d,  m2=%4d,  m3=%4d,  m4=%4d,  m5=%4d,  m6=%4d,  m7=%4d\n m8=%4d,  m9=%4d, m10=%4d, m11=%4d, m12=%4d, m13=%4d, m14=%4d, m15=%4d\nr16=%4d, m17=%4d, m18=%4d, m19=%4d, m20=%4d, m21=%4d, m22=%4d, m23=%4d\nm24=%4d, m25=%4d, m26=%4d, m27=%4d, m28=%4d, m29=%4d, m30=%4d, m31=%4d",							 
            cpu.DM.memory[ 0], cpu.DM.memory[ 1], cpu.DM.memory[ 2], cpu.DM.memory[ 3],
            cpu.DM.memory[ 4], cpu.DM.memory[ 5], cpu.DM.memory[ 6], cpu.DM.memory[ 7],
            cpu.DM.memory[ 8], cpu.DM.memory[ 9], cpu.DM.memory[10], cpu.DM.memory[11],
            cpu.DM.memory[12], cpu.DM.memory[13], cpu.DM.memory[14], cpu.DM.memory[15],
            cpu.DM.memory[16], cpu.DM.memory[17], cpu.DM.memory[18], cpu.DM.memory[19],
            cpu.DM.memory[20], cpu.DM.memory[21], cpu.DM.memory[22], cpu.DM.memory[23],
            cpu.DM.memory[24], cpu.DM.memory[25], cpu.DM.memory[26], cpu.DM.memory[27],
            cpu.DM.memory[28], cpu.DM.memory[29], cpu.DM.memory[30], cpu.DM.memory[31]
    );

	$display("\n\n");
end

initial begin
    $dumpfile("gtkWave.vcd");
    $dumpvars;
end

endmodule