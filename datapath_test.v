`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:13:04 11/24/2014
// Design Name:   datapath
// Module Name:   X:/EC 413/Final Project/Milestone3/datapath_test.v
// Project Name:  Milestone3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: datapath
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module datapath_test;

	// Inputs
	reg clk;
	reg reset;
	reg PCWrite;
	reg PCWriteCond;
	reg IorD;
	reg MemRead;
	reg MemWrite;
	reg IRWrite;
	reg MemtoReg;
	reg [1:0] PCSource;
	reg [3:0] ALUOp;
	reg [1:0] ALUSrcB;
	reg ALUSrcA;
	reg RegWrite;
	reg RegDst;

	// Outputs
	wire [31:0] IReg_out;
	wire [31:0] IMem_out;
	wire [31:0] PCAddress;
	wire [31:0] ALUOut;

	// Instantiate the Unit Under Test (UUT)
	datapath uut (
		.IReg_out(IReg_out), 
		.IMem_out(IMem_out), 
		.PCAddress(PCAddress), 
		.ALUOut(ALUOut), 
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
		.RegDst(RegDst)
	);
	
	// Initialize clock
	always #5
		clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		PCWrite = 0;
		PCWriteCond = 0;
		IorD = 0;
		MemRead = 0;
		MemWrite = 0;
		IRWrite = 0;
		MemtoReg = 0;
		PCSource = 0;
		ALUOp = 0;
		ALUSrcB = 0;
		ALUSrcA = 0;
		RegWrite = 0;
		RegDst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

