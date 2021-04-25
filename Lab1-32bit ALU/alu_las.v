module alu_las(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cayot,      //1 bit carry out(output)
               set,         //1 bit sign bit(set)
               ovr         //1 bit overflow
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        set;
output        ovr;
output        cayot;

reg           result;

reg ovr, cayot;

wire src1_temp, src2_temp, cout;

assign src1_temp = src1 ^ A_invert;
assign src2_temp = src2 ^ B_invert;
assign set = sum;

Full_Adder FA(src1_temp, src2_temp, cin, sum, cout);

always@( * ) begin
     case(operation)
          2'b00: result = src1_temp & src2_temp; // 00 -> And
          2'b01: result = src1_temp | src2_temp; // 01 -> Or
          2'b10: result = sum;                   // 10 -> Add
          2'b11: result = less;
     endcase
end

// Overflow Detection
always@( * ) begin
     case(operation)
          2'b10: ovr = cin ^ cout; // Add
          2'b01: ovr = 1'b0;
          2'b00: ovr = 1'b0;
          2'b11: ovr = 1'b0;
     endcase
end

// carry Out
always @(*) begin
     case(operation)
          2'b10: cayot = cout; // Add
          2'b01: cayot = 1'b0;
          2'b00: cayot = 1'b0;
          2'b11: cayot = 1'b0;
     endcase
end

endmodule
