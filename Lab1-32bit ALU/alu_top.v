module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;

wire src1_temp, src2_temp;

assign src1_temp = src1 ^ A_invert;
assign src2_temp = src2 ^ B_invert;

Full_Adder FA(src1_temp, src2_temp, cin, sum, cout);

always@( * ) begin
     case(operation)
          2'b00: result = src1_temp & src2_temp; // 00 -> And
          2'b01: result = src1_temp | src2_temp; // 01 -> Or
          2'b10: result = sum;                   // 10 -> Add
          2'b11: result = less;
     endcase
end

endmodule
