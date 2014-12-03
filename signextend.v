`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:45:22 11/23/2014 
// Design Name: 
// Module Name:    signextend 
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
module signextend(Imm16, Imm32);
	// Accepts a 16-bit input and outputs the sign-extended 32-bit number
	
	input			[15:0] Imm16;
	output reg	[31:0] Imm32;
	
	always @ (*) begin
		if (Imm16[15] == 1'b1)
			Imm32 <= {16'b1111111111111111, Imm16};
		else if (Imm16[15] == 1'b0)
			Imm32 <= {16'b0000000000000000, Imm16};
	end

endmodule
