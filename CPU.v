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
				PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, BranchType, LUI, SW,
				ALUOut, PCAddress,
				alu_src_a, alu_src_b, write_data, IMem_out, se_out, ze_out, ALU_out);

	input clk, reset;
	
	// Control Lines
	output		PCWrite, MemRead, MemWrite, IRWrite, MemtoReg,
					ALUSrcA, RegWrite, BranchType, LUI, SW;
	output		[1:0] PCSource, ALUSrcB;
	output		[3:0] ALUOp;
	
	// State
	output		[3:0] state, next_state;
	
	// Data outputs
	output		[31:0] IReg_out;
	output		[31:0] ALUOut;
	output		[31:0] PCAddress;
	output		[31:0] alu_src_a, alu_src_b, write_data, IMem_out, se_out, ze_out, ALU_out;
	
	
	// Initialize the controller and the datapath that constitute the CPU
	controller Controller(state, next_state, clk, reset,
						PCWrite, MemRead, MemWrite, IRWrite, MemtoReg,
						PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, BranchType, LUI, SW,
						IReg_out);
						
	datapath Datapath(IReg_out, PCAddress, ALUOut, clk, reset,
						PCWrite, MemRead, MemWrite, IRWrite, MemtoReg,
						PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, BranchType, LUI, SW,
						alu_src_a, alu_src_b, write_data, IMem_out, se_out, ze_out, ALU_out);


endmodule
