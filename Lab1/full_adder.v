`timescale 1ns / 1ps

module Full_Adder(
    In_A, In_B, Carry_in, Sum, Carry_out
    );
    input In_A, In_B, Carry_in;
    output Sum, Carry_out;
    
	// implement full adder circuit, your code starts from here.
	// use half adder in this module, fulfill I/O ports connection.
    wire W1, W2, W3;

    Half_Adder HAD1 (
        .In_A(In_A),
        .In_B(In_B),
        .Sum(W1),
        .Carry_out(W2)
    );


    Half_Adder HAD2 (
        .In_A(W1),
        .In_B(Carry_in),
        .Sum(Sum),
        .Carry_out(W3)
    );

    or or1(Carry_out, W2, W3);
    
    
endmodule
