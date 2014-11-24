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
module datapath(IReg_out, PCAddress, ALUOut, clk, reset,
					PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
					PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst);						
						
	parameter	DATA_SIZE = 32;					// Instruction and data size is 32 bits
	
	input			clk, reset;
	
	// Control Lines
	input			PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
					ALUSrcA, RegWrite, RegDst;
	input			[1:0] PCSource, ALUSrcB;
	input			[3:0] ALUOp;
	
	// Data wires
	wire			[31:0] IMem_out, mdr_out, write_data, ALU_out, mem_data;
	wire			[4:0] write_register;
	wire			[31:0] se_out, ze_out;
	wire			[31:0] read_data_1, read_data_2;
	wire			[31:0] regA_out, regB_out;
	wire			[31:0] alu_src_a, alu_src_b;
	wire			[31:0] zero;
	wire			[31:0] PC_in;
	output		[31:0] ALUOut;						// ALU output register

	
	
	// Other
	output		[31:0] PCAddress;					// Program counter
	output		[31:0] IReg_out;					// Instruction from IReg is given to Controller
	
	
	
	// Program Counter
	ProgramCounter PC(PCAddress, PCWrite, PCWriteCond, PC_in, clk, reset);
	
	// Instruction memory
	IMem IMem(PCAddress,													// Input
					IMem_out);												// Output
	
	// Instruction Register
	nbit_reg #(DATA_SIZE) InstrReg(IMem_out,						// Input
											IReg_out,						// Output
											1'b1, reset, clk);
	
	// Data memory
	DMem DMem(regA_out,													// Input data into the memory (contents of r1)
					mem_data,												// Output data from the memory
					IReg_out[15:0],										// Address of data to be read/written (always the 16-bit imm in the instr)
					MemWrite,												// When high, causes write to take place on posedge
					clk);
	
	// Memory Data Register
	nbit_reg #(DATA_SIZE) MemoryDataRegister (mem_data, mdr_out, 1'b1, reset, clk);
	
	// write_data mux
	TwoOneMux #(DATA_SIZE) MemtoRegMux(write_data, mdr_out, ALUOut, MemtoReg);
	
	// Register file
	nbit_register_file #(DATA_SIZE) RegisterFile(write_data,									// Input
																read_data_1, read_data_2,				// Output
																IReg_out[20:16], IReg_out[15:11],	// Input (r2(5), r3(5))
																IReg_out[25:21],							// Input: write_register: r1(5) always bits 25-21
																RegWrite, clk);
	
	// Register A
	nbit_reg #(DATA_SIZE) RegA (read_data_1,						// Input
										regA_out,							// Output
										1'b1, reset, clk);
	
	// Register B
	nbit_reg #(DATA_SIZE) RegB (read_data_2,						// Input
										regB_out,							// Output
										1'b1, reset, clk);
										
	// Sign Extend and Zero Extend
	signextend SignExtend (IReg_out[15:0], se_out);
	zeroextend ZeroExtend (IReg_out[15:0], ze_out);
	
	// ALUSrcA Mux
	TwoOneMux #(DATA_SIZE) ALUSrcA_MUX(alu_src_a, PCAddress, regA_out, ALUSrcA);
	
	// ALUSrcB Mux
	FourOneMux #(DATA_SIZE) ALUSrcB_MUX(alu_src_b, regB_out, 32'b1, se_out, ze_out, ALUSrcB);
	
	// ALU
	ALU ALU(ALU_out, alu_src_a, alu_src_b, ALUOp);
	
	// ALU Register
	nbit_reg #(DATA_SIZE) ALUReg(ALU_out,							// Input
											ALUOut,							// Output
											1'b1, reset, clk);
	
	// PCSource mux
	FourOneMux #(DATA_SIZE) WBMux(PC_in, ALU_out, ALUOut, {6'b0, IReg_out[25:0]}, 32'b0, PCSource);

	

endmodule
