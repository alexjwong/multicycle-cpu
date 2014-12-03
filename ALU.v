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
	// The actual ALU and the ALU control are combined in this module.
	 
	parameter	word_size = 32;		// word_size default value = 32		

	input		[word_size-1:0] R2, R3;
	input		[3:0] ALUOp;
	
	output reg [word_size-1:0] R1;
	
	parameter MOV = 4'b0000;
	parameter NOT = 4'b0001;
	parameter ADD = 4'b0010;
	parameter SUB = 4'b0011;
	parameter OR = 4'b0100;
	parameter AND = 4'b0101;
	parameter XOR = 4'b0110;
	parameter SLT = 4'b0111;
	// Special operations for LI and LUI: need to MOV ALUSrcB (R3)
	parameter LI = 4'b1001;
	parameter LUI = 4'b1010;

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
				LI: R1 = R3;
				LUI: R1 = R3;
			endcase
		end
		
	/*
	always @ (R2, R3, ALUOp)				// When any of R2, R3, ALUOp changes, R1 will change. 
		begin
			case (ALUOp[5:4])
				2'b00: begin					// Jump (relative)
					if (ALUOp[3:0] == 4'b0001) begin
						R1 = R2 + ;
					end
				end
				
				2'b01: begin					// Regular ALU operations
					case (ALUOp[3:0])
						4'b0000:	R1 = R2;					// MOV
						4'b0001: R1 = ~R2;				// NOT
						4'b0010: R1 = (R2 + R3);		// ADD
						4'b0011: R1 = (R2 - R3);		// SUB
						4'b0100: R1 = (R2 | R3);		// OR
						4'b0101: R1 = (R2 & R3);		// AND
						4'b0110: R1 = (R2 ^ R3);		// XOR
						4'b0111: R1 = (($signed(R2) < $signed(R3))? 1:0);	// SLT
					endcase
				end
				
				2'b11: begin				// ALU immediate operations
					case (ALUOp[3:0])
						4'b0010:
			endcase
		end
		*/
		
endmodule
