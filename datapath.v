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
	
	input			write_enable, reset, clk;
	
	// Control Lines
	input			PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
					ALUSrcA, RegWrite, RegDst;
	input			[1:0] PCSource, ALUSrcB;
	input			[3:0] ALUOp;
	
	
	reg			[31:0] PC;							// Program counter
	
	wire			[31:0] instr_in;					// Instruction input
	wire			[31:0] r1, r2, se_out, ze_out, ALUOut;
	
	// Data wires
	wire			[31:0] IMem_out, mdr_out, write_data, ALU_out;
	wire			[4:0] write_register;
	wire			[31:0] read_data_1, read_data_2, read_sel_1, read_sel_2;
	wire			[31:0] regA_out, regB_out;
	wire			[31:0] alu_src_a, alu_src_b;
	
	
	
	output		reg[31:0] ALUOut;
	
	// IorD mux
	nbit_mux #(DATA_SIZE) IorDMux(poop);
	
	// Instruction memory
	IMem IMem(PC, instr_in);
	
	// Instruction Register
	nbit_reg #(DATA_SIZE) InstrReg (instr_in, IMem_out, write_enable, reset, clk);
	
	// Data memory
	DMem DMem(write_data, MemData, Address, MemWrite, clk);
	
	// Memory Data Register
	nbit_reg #(DATA_SIZE) MemoryDataRegister (MemData, mdr_out, write_enable, reset, clk);
	
	// write_register mux
	TwoOneMux #(DATA_SIZE) RegDstMux(WriteRegister, IMem_out[25:21], IMem_out[20:16], RegDst);
	
	// write_data mux
	TwoOneMux #(DATA_SIZE) MemtoRegMux(write_data, mdr_out, ALUOut, MemtoReg);
	
	// Register file
	nbit_register_file #(DATA_SIZE) RegisterFile(write_data, read_data_1, read_data_2, read_sel_1, read_sel_2, write_address, RegWrite, clk);
	
	// Register A
	nbit_reg #(DATA_SIZE) RegA (read_data_1,						// Input
										regA_out,							// Output
										write_enable, reset, clk);
	
	// Register B
	nbit_reg #(DATA_SIZE) RegB (read_data_2,						// Input
										regB_out,							// Output
										write_enable, reset, clk);
		
	// ALU Mux 1
	TwoOneMux #(DATA_SIZE) ALUSrcA_MUX(alu_src_a, PC, regA_out, ALUSrcA);
	
	// ALU Mux 2
	FourOneMux #(DATA_SIZE) ALUSrcB_MUX(alu_src_b, regB_out, 32'b1, se_out, ze_out, ALUSrcB);
	
	// ALU
	ALU ALU(R1, R2, R3, ALUOp);
	
	// ALU Register
	nbit_reg #(DATA_SIZE) ALUReg(nD, nQ, Write, reset, clk);
	
	// WriteBack mux
	nbit_mux #(DATA_SIZE) WBMux(ALUOut, PCSource);

	

endmodule
