`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:22:08 11/21/2014 
// Design Name: 
// Module Name:    FourOneMux 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FourOneMux(out, a, b, c, d, sel);
	
	parameter	word_size = 32;
	
	input			[word_size-1:0] a,b,c,d;
	input			[1:0] sel;
	
	output reg	[word_size-1:0] out;
	
	always @ (*)
		if (sel == 2'b00)
			out <= a;
		else if (sel == 2'b01)
			out <= b;
		else if (sel == 2'b10)
			out <= c;
		else if (sel == 2'b11)
			out <= c;

endmodule
