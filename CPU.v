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
module CPU(IReg_out, state, next_state, clk, reset,
				PCWrite, MemRead, MemWrite, IRWrite, MemtoReg,
				PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, BranchType, LUI, SWB, Branch,
				ALUOut, PCAddress,
				alu_src_a, alu_src_b, write_data, IMem_out, se_out, ze_out, ALU_out, regA_out, regB_out, PC_in, PC_source);

	input clk, reset;
	
	// Control Lines
	output		PCWrite, MemRead, MemWrite, IRWrite, MemtoReg,
					ALUSrcA, RegWrite, LUI, SWB, Branch;
	output		[1:0] PCSource, ALUSrcB;
	output		[2:0] BranchType;
	output		[3:0] ALUOp;
	
	// State
	output		[3:0] state, next_state;
	
	// Data outputs
	output		[31:0] IReg_out;
	output		[31:0] ALUOut;
	output		[31:0] PCAddress;
	output		[31:0] alu_src_a, alu_src_b, write_data, IMem_out, se_out, ze_out, ALU_out, regA_out, regB_out, PC_in;
	output		[1:0] PC_source;
	
	
	// Initialize the controller and the datapath that constitute the CPU
	controller Controller(state, next_state, clk, reset,
						PCWrite, MemRead, MemWrite, IRWrite, MemtoReg,
						PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, BranchType, LUI, SWB,
						IReg_out);
						
	datapath Datapath(IReg_out, PCAddress, ALUOut, clk, reset,
						PCWrite, MemRead, MemWrite, IRWrite, MemtoReg,
						PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, BranchType, LUI, SWB, Branch,
						alu_src_a, alu_src_b, write_data, IMem_out, se_out, ze_out, ALU_out, regA_out, regB_out, PC_in, PC_source);


endmodule
