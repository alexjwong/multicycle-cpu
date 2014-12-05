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
module BranchControl(Branch, regA_out, regB_out, BranchType, clk);

	parameter	word_size = 32;		// word_size default value = 32	

	input			clk;
	input			[2:0] BranchType;
	input			[word_size-1:0] regA_out, regB_out;
	// output reg [1:0] PC_source;
	output reg Branch;
	
	/*
	always @ (posedge clk) begin
		if (BranchType == 2'b01) begin
			if (regA_out == regB_out) begin
				PC_source = 2'b11;
			end
		end
		else if (BranchType == 2'b10) begin
			if (regA_out != regB_out) begin
				PC_source = 2'b11;
			end
		end
		else if (BranchType == 2'b11) begin
			if (regA_out <= regB_out) begin
				PC_source = 2'b11;
			end
		end
		else begin 
			PC_source = PCSource;
		end
	end
	*/
	
	always @ (BranchType) begin
		case(BranchType)
			3'b001: if (regA_out == regB_out) Branch = 1; // 1 = BEQ
			3'b010: if (regA_out != regB_out) Branch = 1; // 2 = BNE
			3'b011: if (regA_out < regB_out) Branch = 1;	// 3 = BLT
			3'b100: if (regA_out <= regB_out) Branch = 1; // 4 = BLE
			default: Branch = 0;
		endcase
	end
	
endmodule
