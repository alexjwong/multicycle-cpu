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
					PCWrite, MemRead, MemWrite, IRWrite, MemtoReg,
					PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, BranchType, LUI, SWB, Branch,
					alu_src_a, alu_src_b, write_data, IMem_out, se_out, ze_out, ALU_out, regA_out, regB_out, PC_in, PC_source);						// debug outputs
						
	parameter	DATA_SIZE = 32;					// Instruction and data size is 32 bits
	
	input			clk, reset;
	
	// Control Lines
	input			PCWrite, MemRead, MemWrite, IRWrite, MemtoReg,
					ALUSrcA, RegWrite, LUI, SWB;
	input			[1:0] PCSource, ALUSrcB;
	input			[2:0] BranchType;
	input			[3:0] ALUOp;
	
	// Data wires
	wire			[31:0] mdr_out, mem_data;
	output		[31:0] write_data;
	wire			[4:0] write_register;
	output			[31:0] se_out, ze_out;
	wire			[4:0] readsel1, readsel2;
	wire			[31:0] read_data_1, read_data_2;
	output			[31:0] regA_out, regB_out;
	output		[31:0] alu_src_a, alu_src_b;
	wire			[31:0] JumpOffset;
	output				Branch;
	output			[31:0] PC_in;
	output		[1:0] PC_source;
	output		[31:0] ALU_out;					// ALU output wire
	output		[31:0] ALUOut;						// ALU output register

	
	// Other
	output		[31:0] PCAddress;					// Program counter
	output		[31:0] IReg_out;					// Instruction from IReg is given to Controller
	output		[31:0] IMem_out;					// Instruction Memory out. only outputs on state 0
	
	
	
	// Program Counter
	ProgramCounter PC(PCAddress, PCWrite, BranchType, Branch, PC_in, clk, reset);
												
	// Instruction Memory
	IMem IMem(PCAddress,													// Input
					IMem_out);												// Output
	
	// Instruction Register
	nbit_reg #(DATA_SIZE) InstrReg(IMem_out,						// Input
											IReg_out,						// Output
											IRWrite,							// Enable
											reset, clk);
	
	// Data memory
	DMem DMem(regA_out,													// Input data into the memory (contents of r1)
					mem_data,												// Output data from the memory
					IReg_out[15:0],										// Address of data to be read/written (always the 16-bit imm in the instr)
					MemWrite,												// When high, causes write to take place on posedge
					clk);
	
	// Memory Data Register
	nbit_reg #(DATA_SIZE) MemoryDataRegister (mem_data,		// Input
															mdr_out,			// Output
															1'b1, reset, clk);
	
	// write_data mux
	TwoOneMux #(DATA_SIZE) MemtoRegMux(write_data,				// Output
													ALUOut,					// Input 0
													mdr_out,					// Input 1
													MemtoReg);				// Control line
													
	// read_sel_1 mux - If instr is SWI/SW or branch, read_sel_1 is R1, not R2
	TwoOneMux #(5) ReadSel1Mux(readsel1,							// Output
										IReg_out[20:16],					// Input 0
										IReg_out[25:21],					// Input 1
										SWB);									// Control line
	
	// read_sel_2 mux - If instr
	TwoOneMux #(5) ReadSel2Mux(readsel2,							// Output
										IReg_out[15:11],					// Input 0
										IReg_out[20:16],					// Input 1
										SWB);									// Control line
	
	// Register file
	nbit_register_file #(DATA_SIZE) RegisterFile(write_data,									// Input
																read_data_1, read_data_2,				// Output
																readsel1, readsel2,						// Input (readsel, r3(5)) NOTE: readsel is always R2 except for during SW
																IReg_out[25:21],							// Input: write_register: r1(5) always bits 25-21
																RegWrite, clk,
																LUI);											// LUI control for writing to reg
	
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
	TwoOneMux #(DATA_SIZE) ALUSrcA_MUX(alu_src_a,				// Output
													PCAddress,				// Input 0
													regA_out,				// Input 1
													ALUSrcA);				// Control line
	
	// ALUSrcB Mux
	FourOneMux #(DATA_SIZE) ALUSrcB_MUX(alu_src_b,				// Output
													regB_out,				// Input 00
													32'b1,					// Input 01
													se_out,					// Input 10
													ze_out,					// Input 11
													ALUSrcB);				// Control line
	
	// ALU
	ALU ALU(ALU_out, alu_src_a, alu_src_b, ALUOp);
	
	// ALU Register
	nbit_reg #(DATA_SIZE) ALUReg(ALU_out,							// Input
											ALUOut,							// Output
											1'b1, reset, clk);
	
	// Jump Address
	JumpAddress JumpSignExtend(IReg_out[25:0], JumpOffset);
	
	// Branch Control
	BranchControl #(DATA_SIZE) BranchCtrl(Branch,			// Output
														regA_out,			// Input
														regB_out,			// Input
														BranchType, clk);		// Control line	
	// Branch/PCSource Mux
	TwoOneMux #(2) BranchorPCSource(PC_source, PCSource, 2'b11, Branch); // If Branch control is true, output 2'b11 to select SE(Imm) on PCSource mux
	// If Branch control is false, just pass through PCSource
	
	// PCSource mux
	FourOneMux #(DATA_SIZE) PCSourceMux(PC_in,					// Output (to PC)
													ALU_out,					// Input 00 (ALU Wire out)
													ALUOut,					// Input 01 (ALU Reg out)
													JumpOffset + PCAddress, // Input 10 (Jump address)
													(se_out) + PCAddress,					// Input 11 (Branch Address)
													PC_source);				// Control line

endmodule
