`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:25:57 11/24/2014
// Design Name:   ProgramCounter
// Module Name:   X:/EC 413/Final Project/Milestone3/pc_test.v
// Project Name:  Milestone3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ProgramCounter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pc_test;

	// Inputs
	reg PCWrite;
	reg PCWriteCond;
	reg [31:0] PC_in;
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] PCAddress;

	// Instantiate the Unit Under Test (UUT)
	ProgramCounter uut (
		.PCAddress(PCAddress), 
		.PCWrite(PCWrite), 
		.PCWriteCond(PCWriteCond), 
		.PC_in(PC_in), 
		.clk(clk), 
		.reset(reset)
	);
	
	// Initialize clock
	always #5
		clk = ~clk;

	initial begin
		// Initialize Inputs
		PCWrite = 0;
		PCWriteCond = 0;
		PC_in = 0;
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		PCWrite = 1;
		PC_in = 1;
		#100;
		
		PC_in = 2;
		#100;
		
		PC_in = 3;
		
	end
      
endmodule

