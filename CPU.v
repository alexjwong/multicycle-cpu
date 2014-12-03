`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:44:10 11/23/2014 
// Design Name: 
// Module Name:    CPU 
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
module CPU(instr_in, state, next_state, clk, reset,
				PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
				PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst,
				ALUOut, PCAddress);

	input clk, reset;
	
	// Control Lines
	output		PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
					ALUSrcA, RegWrite, RegDst;
	output		[1:0] PCSource, ALUSrcB;
	output		[3:0] ALUOp;
	
	// State
	output		[3:0] state, next_state;
	
	// Data outputs
	output		[31:0] instr_in;
	output		[31:0] ALUOut;
	output		[31:0] PCAddress;
	
	wire [31:0] IMem_reg;

	
	
	// Initialize the controller and the datapath that constitute the CPU
	controller Controller(state, next_state, clk, reset,
						PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
						PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst,
						instr_in);
						
	datapath Datapath(instr_in, IMem_reg, PCAddress, ALUOut, clk, reset,
						PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
						PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst);


endmodule
