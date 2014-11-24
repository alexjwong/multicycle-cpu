`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:53:10 11/23/2014 
// Design Name: 
// Module Name:    zeroextend 
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
module zeroextend(Imm16, Imm32);

	input			[15:0] Imm16;
	output reg	[31:0] Imm32;
	
	always @ (*)
        Imm32 = {16'b0000000000000000, Imm16};

endmodule
