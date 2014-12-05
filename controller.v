`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:52 11/12/2014 
// Design Name: 
// Module Name:    controller 
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
module controller(state, next_state, clk, reset,
						PCWrite, MemRead, MemWrite, IRWrite, MemtoReg,
						PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, BranchType, LUI, SWB,
						instr_in);
						
						// PCWriteCond not used
						// RegDst not used - reg destination is always the first reg in the instruction
						
	input						clk, reset;
	input			[31:0]	instr_in;
	output reg	[3:0]		state, next_state;
	output reg				PCWrite, MemRead, MemWrite, IRWrite, MemtoReg,
								ALUSrcA, RegWrite, LUI, SWB;
	output reg	[1:0]		PCSource, ALUSrcB;
	output reg  [2:0]    BranchType;
	output reg	[3:0]		ALUOp;
	
	initial begin
		state <= 4'd0;
		next_state <= 4'd0;
	end
	
	// Trigger the next state on the uptick of clock
	always @ (posedge clk) begin
				state <= next_state;
	end
	
	// *** Its important to remember that changes take place AFTER the state changes.
	
	always @ (reset or state or instr_in) begin
		if (reset)
				next_state = 0;
		else
			case (state)
				// State 0: Instruction fetch
				4'd0: begin
					next_state = 1;
					
					// Control outputs
					PCWrite		<= 1;			// *PC gets incremented after State 0 from PCSource set at earlier state
					MemRead		<= 0;			
					MemWrite		<= 0;			// Only fetch instruction from IMem after state 0 - this is the IReg enable
					IRWrite		<= 1;
					MemtoReg		<= 0;
					PCSource		<= 2'b00;	// PCSource is default to ALU wire out
					ALUOp			<= 4'b0010;	// State 0: use ADD to add 1 to current PC
					ALUSrcB		<= 2'b01;	// +1
					ALUSrcA		<= 0;			// Current PC
					RegWrite		<= 0;
					BranchType	<= 3'b000;
					LUI			<= 0;
					SWB			<= 0;
					
					// PC GETS INCREMENTED AFTER STATE 0!! ALWAYS!!
				
				end
					
				// State 1: Instruction decode/register fetch
				4'd1: begin
					PCWrite		<= 0;			// Not writing to PC here
					ALUSrcA		<= 0;
					ALUSrcB		<= 2'b11;
					ALUOp			<= 4'b0000;
					IRWrite		<= 0;
					
					// 000000 NOOP
					if (instr_in[31:26] == 6'b000000)
						next_state = 0;
					
					// 00 Jump
					else if (instr_in[31:30] == 2'b00)
						next_state = 6;
						
					// 01 Arithmetic/Logical R-type
					else if (instr_in[31:30] == 2'b01)	// MOV, ADD, SUB, OR, AND, XOR, SLT
						next_state = 4;
						
					// 10 Branch (I-type)
					else if (instr_in[31:30] == 2'b10) begin	// BEQ
						next_state = 5;
						SWB		  = 1;						// Raise the StoreWord/Branch flag for read selects into the reg file
						
					end
						
					// 11 Arithmetic/Logical I-type
					else if (instr_in[31:30] == 2'b11) begin
						if (instr_in[29:26] == 4'b1001) // LI
							next_state = 11;
						else if (instr_in[29:26] == 4'b1010)	// LUI
							next_state = 12;
						else if ((instr_in[29:26] == 4'b1011) || (instr_in[29:26] == 4'b1100))	// LWI, SWI, LW, SW
							next_state = 2;
						else	// ADDI, SUBI, ORI, ANDI, XORI, SLTI
							next_state = 3;
					end
				end
				
				// State 2: Memory address computation (LWI, SWI prep)
				4'd2: begin
					ALUSrcA		<= 1;
					ALUSrcB		<= 2'b10;
					ALUOp			<= 4'b0010;				// ALU add
					
					if ((instr_in[29:26] == 4'b1011) || (instr_in[29:26] == 4'b1101))				// LWI or LW
						next_state = 7; 
					else if ((instr_in[29:26] == 4'b1100) || (instr_in[29:26] == 4'b1110)) begin	// SWI or SW
						next_state = 8; 
						SWB			= 1;						// Raise SWB flag to read from R1
					end

				end
				
				// State 3: I-Type execution
				4'd3: begin
					ALUSrcA		<= 1;						// regA_out
					ALUSrcB		<= 2'b10;				// IReg_out[15:0] - immediate
					ALUOp			<= instr_in[29:26];	// ALU op determined by [29:26]
				
					next_state = 9;
				end
				
				// State 4: R-type execution
				4'd4: begin
					ALUSrcA		<= 1;						// regA_out
					ALUSrcB		<= 2'b00;				// regB_out
					ALUOp			<= instr_in[29:26];	// ALU op determined by [29:26]
					
					next_state = 9;
				end
				
				// State 5: Branch completion
				4'd5: begin
					PCWrite		<= 1;						// Write after this state
					// BranchControl controls Branch logic and PCSource
					if (instr_in[29:26] == 4'b0000)
						BranchType	<= 3'b001;					// BEQ
					else if (instr_in[29:26] == 4'b0001)
						BranchType	<= 3'b010;					// BNE
					else if (instr_in[29:26] == 4'b0010)
						BranchType	<= 3'b011;					// BLT
					else if (instr_in[29:26] == 4'b0011)
						BranchType	<= 3'b100;					// BLE

					next_state = 0;
				end
				
				// State 6: Jump completion
				4'd6: begin
					PCWrite		<= 1;						// Writing to PC the jump address (imm)
					PCSource		<= 2'b10;				// PCSource: Jump Address
					// Don't need ALU
					
					next_state = 0;
				end
				
				// State 7: Memory Access (LWI, LW)
				4'd7: begin
					MemRead		<= 1;						// R1 <- M[ZE(Imm)] (LWI)
					
					next_state = 10;
				end
				
				// State 8: Memory Access (SWI, SW)
				4'd8: begin
					MemWrite		<= 1;						// Writing to memory
					
					next_state = 0;
				end
				
				// State 9: I and R type completion
				4'd9: begin
					RegWrite		<= 1;						// Enable writing to a Reg
					MemtoReg		<= 0;						// Write contents of ALURegister to a Register
					
					next_state = 0;
				end
				
				// State 10: Write back (LWI)
				4'd10: begin
					RegWrite		<= 1;
					MemtoReg		<= 1;
					
					next_state = 0;
				end
				
				// State 11: LI
				4'd11: begin
					// ALUSrcA - don't care, we are only moving ALUSrcB
					ALUSrcB		<= 2'b11;				// ALUSrcB is the Zero extended immediate
					ALUOp			<= instr_in[29:26];	// ALU has special instructions for LI and LUI.
					
					next_state = 13;
				end
				
				// State 12: LUI
				4'd12: begin
					// ALUSrcA - don't care, we are only moving ALUSrcB
					ALUSrcB		<= 2'b11;				// ALUSrcB is the Zero extended immediate
					ALUOp			<= instr_in[29:26];	// ALU has special instructions for LI and LUI.
					LUI			<= 1;

					next_state = 13;
				end
				
				// State 13: LI and LUI completion
				4'd13: begin
					RegWrite		<= 1;					// Enable writing to a Reg
					MemtoReg		<= 0;					// MemtoReg remains 0 for Write ALUOut to reg (the immediate)
					
					next_state = 0;
				end
					
				default: next_state = state;
		endcase
	end

endmodule
