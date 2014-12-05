`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:19:07 12/05/2014 
// Design Name: 
// Module Name:    JumpAddress 
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
module JumpAddress(Imm25, Imm32);
	// Accepts a 26-bit input and outputs the sign-extended 32-bit number
	
	input			[25:0] Imm25;
	output reg	[31:0] Imm32;
	
	
	always @ (*) begin
		if (Imm25[25] == 1'b1)
			Imm32 <= {16'b111111, Imm25};
		else if (Imm25[15] == 1'b0)
			Imm32 <= {16'b000000, Imm25};
	end

endmodule
