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
module CPU(clk, reset);

	input clk, reset;
	
	// Control Lines
	wire			PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
					ALUSrcA, RegWrite, RegDst;
	wire			[1:0] PCSource, ALUSrcB;
	wire			[3:0] ALUOp;
	
	// State
	wire			state, next_state;

	controller Controller(state, next_state, clk, reset,
						PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
						PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst,
						instr_in);
						
	datapath Datapath(clk, reset,
					PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
					PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst,
					ALUOut);


endmodule
