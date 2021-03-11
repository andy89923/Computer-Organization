`timescale 1ns / 1ps

module Full_Adder(
    In_A, In_B, Carry_in, Sum, Carry_out
    );
    input In_A, In_B, Carry_in;
    output Sum, Carry_out;
    
	// implement full adder circuit, your code starts from here.
	// use half adder in this module, fulfill I/O ports connection.
    Half_Adder HAD (
        .In_A(),
        .In_B(),
        .Sum(),
        .Carry_out()
    );
    
    
endmodule
