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
	wire [31:0] IReg_out;
	wire [31:0] IMem_out;
	wire [3:0] state;
	wire [3:0] next_state;
	wire [31:0] PCAddress;
	wire PCWrite;
	wire BranchType;
	wire IorD;
	wire MemRead;
	wire MemWrite;
	wire IRWrite;
	wire MemtoReg;
	wire [1:0] PCSource;
	wire [31:0] se_out;
	wire [31:0] ze_out;
	wire [3:0] ALUOp;
	wire [1:0] ALUSrcB;
	wire ALUSrcA;
	wire [31:0] alu_src_a;
	wire [31:0] alu_src_b;
	wire [31:0] write_data;
	wire RegWrite;
	wire LUI;
	wire [31:0] ALUOut;
	wire [31:0] ALU_out;
	

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.IReg_out(IReg_out),	
		.IMem_out(IMem_out), 
		.state(state), 
		.next_state(next_state), 
		.PCAddress(PCAddress), 
		.clk(clk), 
		.reset(reset), 
		.PCWrite(PCWrite), 
		.BranchType(BranchType),
		.IorD(IorD), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.IRWrite(IRWrite), 
		.MemtoReg(MemtoReg), 
		.PCSource(PCSource), 
		.se_out(se_out), 
		.ze_out(ze_out), 
		.ALUOp(ALUOp), 
		.ALUSrcB(ALUSrcB), 
		.ALUSrcA(ALUSrcA), 
		.alu_src_a(alu_src_a),
		.alu_src_b(alu_src_b),
		.write_data(write_data),
		.ALU_out(ALU_out),
		.ALUOut(ALUOut),
		.RegWrite(RegWrite), 
		.LUI(LUI)
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

