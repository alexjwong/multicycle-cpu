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
module ProgramCounter(PCAddress, PCWrite, PCWriteCond, PC_in, clk, reset);

	input			clk, reset;
	input			PCWrite, PCWriteCond;
	input			[31:0] PC_in;									// Predetermined PC input (output of the PCSource mux)
	
	output reg	[31:0] PCAddress;
	
	and (PCWriteCondandBranch, PCWriteCond, 1'b1);
	or (PCWriteorBranch, PCWriteCondandBranch, PCWrite);
	
	initial begin
		PCAddress = 0;
	end

	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			PCAddress = 0;
		end
		else begin
			if (PCWriteorBranch) begin
				PCAddress = PC_in;
			end
			else begin
				PCAddress = PCAddress;
			end
		end
	end

endmodule
