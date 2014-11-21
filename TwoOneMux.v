`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:51:36 11/21/2014 
// Design Name: 
// Module Name:    TwoOneMux 
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
module TwoOneMux(out, a, b, sel);

	parameter	word_size = 32;
	
	input			[word_size-1:0] a,b;
	input			sel;
	
	output reg	[word_size-1:0] out;
	
	always @ (*)
        if (sel == 1'b0)
            out <= a;
        else if (sel == 1'b1)
            out <= b;


endmodule
