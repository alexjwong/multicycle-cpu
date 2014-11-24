`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:32:33 11/12/2014
// Design Name:   controller
// Module Name:   X:/EC 413/Final Project/Milestone2/controller_test.v
// Project Name:  Milestone2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module controller_test;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] instr_in;

	// Outputs
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

	// Instantiate the Unit Under Test (UUT)
	controller uut (
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
		.instr_in(instr_in)
	);
	
	// Initialize clock
	always #5
		clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		instr_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		instr_in = 32'b11100100000000001111111111111110;	// LI
		#50;
		instr_in = 32'b11101000000000001111111111111111;	// LUI
		#50;
		instr_in = 32'b11101100000000000000000000000000;	// LWI
		#50;
		instr_in = 32'b11001011111000001111111111111111;	// ADDI
		#50;
		instr_in = 32'b10000011111000000000000000010000;	// Branch
		#50;
		instr_in = 32'b01001000000000000000000000000000;	// ADD
		#50;
		instr_in = 32'b00000100000000000000000000000000;	// Jump
		#50;
		instr_in = 0;	// NOOP
		
	end
      
endmodule

