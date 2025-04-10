`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 10:49:19 AM
// Design Name: 
// Module Name: ALUcntrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ALUcntrl( input [1:0] ALUOp, [2:0] funct3, [6:0] funct7, output reg [3:0] ALUSel);

always @(*) begin
    case (ALUOp)
        2'b00: ALUSel = `ALU_ADD; // Load/store
        2'b01: ALUSel = `ALU_SUB; // Branch (subtraction)
        2'b10: begin // R-type
            case (funct3)
                `F3_ADD:  ALUSel = (funct7 == 1'b0) ? `ALU_ADD  : `ALU_SUB;
                `F3_SLL:  ALUSel = `ALU_SLL;
                `F3_SLT:  ALUSel = `ALU_SLT;
                `F3_SLTU: ALUSel = `ALU_SLTU;
                `F3_XOR:  ALUSel = `ALU_XOR;
                `F3_SRL:  ALUSel = (funct7 == 1'b0) ? `ALU_SRL  : `ALU_SRA;
                `F3_OR:   ALUSel = `ALU_OR;
                `F3_AND:  ALUSel = `ALU_AND;
                default:  ALUSel = `ALU_ADD; // fallback
            endcase
        end
        2'b11: begin // I-type
            case (funct3)
                `F3_ADD:  ALUSel = `ALU_ADD;  // ADDI
                `F3_SLL:  ALUSel = `ALU_SLL;  // SLLI
                `F3_SLT:  ALUSel = `ALU_SLT;  // SLTI
                `F3_SLTU: ALUSel = `ALU_SLTU; // SLTIU
                `F3_XOR:  ALUSel = `ALU_XOR;  // XORI
                `F3_SRL:  ALUSel = (funct7 == 1'b0) ? `ALU_SRL  : `ALU_SRA; // SRLI/SRAI
                `F3_OR:   ALUSel = `ALU_OR;   // ORI
                `F3_AND:  ALUSel = `ALU_AND;  // ANDI
                default:  ALUSel = `ALU_ADD;
            endcase
        end
        default: ALUSel = `ALU_ADD;
    endcase
end

endmodule