`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:50:17 11/23/2014 
// Design Name: 
// Module Name:    ProgramCounter 
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
module ProgramCounter(PCAddress, PCWrite, BranchType, Branch, PC_in, clk, reset);

	input			clk, reset;
	input			PCWrite, BranchType, Branch;
	input			[31:0] PC_in;									// Predetermined PC input (output of the PCSource mux)
	
	output reg	[31:0] PCAddress;
	
	// If branch is false, we don't want to write the PC (PCWrite enabled on branch for when Branch is true)
	
	initial begin
		PCAddress = 0;
	end

	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			PCAddress = 0;
		end
		else begin
			if (BranchType) begin		// A branch instruction asserted
				if (Branch) begin			// Branch Condition found true
					PCAddress = PC_in;	// Allow PC to be incremented by PC_in
				end
			end
			else if (BranchType == 0) begin		// If No branch instruction
				if (PCWrite) begin					// Behave normally (check PCWrite)
					PCAddress = PC_in;
				end
			end
			else begin
				PCAddress = PCAddress;
			end
		end
	end

endmodule
