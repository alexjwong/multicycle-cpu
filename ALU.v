`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:37:36 11/19/2014 
// Design Name: 
// Module Name:    ALU 
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
module ALU(R1, R2, R3, ALUOp);
	 
	 
	parameter	word_size = 32;		// word_size default value = 32		

	input  [word_size-1:0] R2, R3;
	input	 [3:0]			  ALUOp;
	
	output reg [word_size-1:0] R1;
	
	parameter MOV = 4'b0000;
	parameter NOT = 4'b0001;
	parameter ADD = 4'b0010;
	parameter SUB = 4'b0011;
	parameter OR = 4'b0100;
	parameter AND = 4'b0101;
	parameter XOR = 4'b0110;
	parameter SLT = 4'b0111;

	always @ (R2, R3, ALUOp)				// When any of R2, R3, ALUOp changes, R1 will change. 
		begin
			case (ALUOp)
				MOV: R1 = R2;
				NOT: R1 = ~R2;
				ADD: R1 = (R2 + R3);
				SUB: R1 = (R2 - R3);
				OR: R1 = (R2 | R3);
				AND: R1 = (R2 & R3);
				XOR: R1 = (R2 ^ R3);
				SLT: R1 = (($signed(R2) < $signed(R3))? 1:0);	
			endcase
		end
		
endmodule
