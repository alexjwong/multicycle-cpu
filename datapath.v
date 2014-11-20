`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:22:23 11/19/2014 
// Design Name: 
// Module Name:    datapath 
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
module datapath(write_enable, clk, reset,
					PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
					PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst,
					ALUOut);
						
						
	parameter	DATA_SIZE = 32;					// Instruction and data size is 32 bits
	
	input			reset, clk;
	
	// Control Lines
	input			PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
					ALUSrcA, RegWrite, RegDst;
	input			[1:0] PCSource, ALUSrcB;
	input			[3:0] ALUOp;
	
	reg			[31:0] PC;							// Program counter
	
	wire			[31:0] instr_in;					// Instruction input
	wire			[31:0] r1, r2, IMem_out, se_out, ze_out, alu_wire_out, ALUOut;
	
	wire			[31:0] read_data_1, read_data_2, read_sel_1, read_sel_2;
	
	output		reg[31:0] ALUOut;
	
	// IorD mux
	nbit_mux #(DATA_SIZE) IorDMux(poop);
	
	// Instruction memory
	IMem IMem(PC, instr_in);
	
	// Instruction Register
	nbit_reg #(DATA_SIZE) InstrReg (instr_in, IMem_out, write_enable, reset, clk);
	
	// Data memory
	DMem DMem(WriteData, MemData, Address, MemWrite, clk);
	
	// Register file
	nbit_register_file #(DATA_SIZE) RegisterFile(WriteData, read_data_1, read_data_2, read_sel_1, read_sel_2, write_address, RegWrite, clk);
	
	// Register file WriteData mux
	
	// ALU Mux 1
	nbit_mux #(DATA_SIZE) ALUSrcA_MUX(PC, ALUSrcA);
	
	// ALU Mux 2
	nbit_mux #(DATA_SIZE) ALUSrcB_MUX(ALUSrcB);
	
	// ALU
	ALU ALU(R1, R2, R3, ALUOp);
	
	// ALU Register
	nbit_reg #(DATA_SIZE) ALUReg(nD, nQ, Write, reset, clk);
	
	// WriteBack mux
	nbit_mux #(DATA_SIZE) WBMux(ALUOut, PCSource);

	

endmodule
