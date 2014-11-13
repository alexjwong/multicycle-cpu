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
						PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
						PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst,
						instr_in);
						
	input						clk, reset;
	input			[31:0]	instr_in;
	output reg	[3:0]		state, next_state;
	output reg				PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg,
								ALUSrcA, RegWrite, RegDst;
	output reg	[1:0]		PCSource, ALUSrcB;
	output reg	[3:0]		ALUOp;
	
	initial begin
		state <= 4'd0;
		next_state <= 4'd0;
	end
	
	// Trigger the next state on the uptick of clock
	always @ (posedge clk) begin
				state <= next_state;
	end
	
	always @ (reset or state or instr_in) begin
		if (reset)
				next_state = 0;
		else
			case (state)
				// State 0: Instruction fetch
				4'd0: begin
					next_state = 1;
					
					// Control outputs
					PCWrite		<= 1;
					PCWriteCond	<= 0;
					IorD			<= 0;
					MemRead		<= 0;
					MemWrite		<= 0;
					IRWrite		<= 1;
					MemtoReg		<= 0;
					PCSource		<= 2'b00;
					ALUOp			<= 2'b00;
					ALUSrcB		<= 2'b01;
					ALUSrcA		<= 0;
					RegWrite		<= 0;
					RegDst		<= 0;
				
				end
					
				// State 1: Instruction decode/register fetch
				4'd1: begin
					ALUSrcA		<= 0;
					ALUSrcB		<= 2'b11;
					ALUOp			<= 2'b00;
					
					// 000000 NOOP
					if (instr_in[31:26] == 6'b000000)
						next_state = 0;
					
					// 00 Jump
					if (instr_in[31:30] == 2'b00)
						next_state = 6;
						
					// 01 Arithmetic/Logical R-type
					else if (instr_in[31:30] == 2'b01)	//
						next_state = 4;
					
					// 10 Branch (I-type)
					else if (instr_in[31:30] == 2'b10)	// BEQ
						next_state = 5;
					
					// 11 Arithmetic/Logical I-type
					else if (instr_in[31:30] == 2'b11) begin
						if (instr_in[29] == 1'b1) // LI, LUI, LWI, SWI
							next_state = 2;
						else	// ADDI, SUBI, ORI, ANDI, XORI, SLTI
							next_state = 3;
					end
				end
				
				// State 2: Memory address computation
				4'd2: begin
					ALUSrcA		<= 1;
					ALUSrcB		<= 2'b10;
					ALUOp			<= instr_in[29:26];
				
					if ((ALUOp[3:0] == 6'b1011)||(ALUOp[3:0] == 6'b1101))				// LWI or LW
						next_state = 7; 
					else if ((ALUOp[3:0] == 6'b1100)||(ALUOp[3:0] == 6'b1110))		// SWI or SW
						next_state = 8; 
					else if ((ALUOp[3:0] == 4'b1001) || (ALUOp[3:0] == 4'b1010))	// LI or LUI
						next_state = 9;
				end
				
				// State 3: I-Type execution
				4'd3: begin
					ALUSrcA		<= 1;
					ALUSrcB		<= 2'b10;
					ALUOp			<= instr_in[29:26];
				
					next_state = 9;
				end
				
				// State 4: R-type execution
				4'd4: begin
					ALUSrcA		<= 1;
					ALUSrcB		<= 2'b00;
					ALUOp			<= instr_in[29:26];
					
					next_state = 9;
				end
				
				// State 5: Branch completion
				4'd5: begin
					ALUSrcA		<= 1;
					ALUSrcB		<= 2'b00;
					PCWriteCond	<= 1;
					PCSource		<= 2'b01;
					ALUOp			<= instr_in[29:26];
					
					next_state = 0;
				end
				
				// State 6: Jump completion
				4'd6: begin
					PCWrite		<= 1;
					PCSource		<= 2'b10;
					ALUOp			<= instr_in[29:26];
					
					next_state = 0;
				end
				
				// State 7: Memory Access (LWI, LW)
				4'd7: begin
					PCWrite		<= 1;
					PCSource		<= 2'b10;
					ALUOp			<= instr_in[29:26];
					
					next_state = 10;
				end
				
				// State 8: Memory Access (SWI, SW)
				4'd8: begin
					PCWrite		<= 1;
					PCSource		<= 2'b10;
					ALUOp			<= instr_in[29:26];
					
					next_state = 0;
				end
				
				// State 9: I and R type completion
				4'd9: begin
					RegWrite		<= 1;
					MemtoReg		<= 0;
					
					next_state = 0;
				end
				
				// State 10: Write back (LWI)
				4'd10: begin
					RegWrite		<= 1;
					MemtoReg		<= 1;
					
					next_state = 0;
				end
				
				default: next_state = state;
		endcase
	end

endmodule
