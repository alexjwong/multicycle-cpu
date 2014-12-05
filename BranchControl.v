`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:45:36 12/03/2014 
// Design Name: 
// Module Name:    BranchControl 
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
module BranchControl(Branch, regA_out, regB_out, BranchType);

	parameter	word_size = 32;		// word_size default value = 32	

	input			BranchType;
	input			[word_size-1:0] regA_out, regB_out;
	output reg	Branch;
	
	always @ (BranchType) begin
		case(BranchType)		
			1: if (regA_out == regB_out) Branch = 1;		// Right now BranchType = 1 = BEQ, add more support later
			default: Branch = 0;
		endcase
	end


endmodule
