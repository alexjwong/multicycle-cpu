`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:45:40 11/23/2014
// Design Name:   CPU
// Module Name:   X:/EC 413/Final Project/Milestone3/cpu_test.v
// Project Name:  Milestone3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cpu_test;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] instr_in;
	wire [3:0] state;
	wire [3:0] next_state;
	wire PCWrite;
	wire PCWriteCond;
	wire IorD;
	wire MemRead;
	wire MemWrite;
	wire IRWrite;
	wire MemtoReg;
	wire [1:0] PCSource;
	wire [3:0] ALUOp;
	wire [1:0] ALUSrcB;
	wire ALUSrcA;
	wire RegWrite;
	wire RegDst;
	wire [31:0] ALUOut;
	wire [31:0] PCAddress;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.instr_in(instr_in), 
		.state(state), 
		.next_state(next_state), 
		.clk(clk), 
		.reset(reset), 
		.PCWrite(PCWrite), 
		.PCWriteCond(PCWriteCond), 
		.IorD(IorD), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.IRWrite(IRWrite), 
		.MemtoReg(MemtoReg), 
		.PCSource(PCSource), 
		.ALUOp(ALUOp), 
		.ALUSrcB(ALUSrcB), 
		.ALUSrcA(ALUSrcA), 
		.RegWrite(RegWrite), 
		.RegDst(RegDst), 
		.ALUOut(ALUOut), 
		.PCAddress(PCAddress)
	);
	
	// Initialize clock
	always #5
		clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

