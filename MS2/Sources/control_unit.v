`timescale 1ns / 1ps
`include "defines.v"
`timescale 1ns / 1ps
`include "defines.v"

module control_unit (
    input   [4:0] opcode,  
    input  [2:0] funct3,
    output reg       regwrite,
    output reg       memread,
    output reg       memwrite,
    output reg       ALUsrc,
    output reg [1:0] ALUop,
    output reg       branch_en,
    output reg       src_a_sel,
    output reg         lbu_flag,  
    output reg         lhu_flag,
    output reg         lb_flag,  
    output reg         lh_flag,  
    output reg         sb_flag,  
    output reg         sh_flag  
);

always @(*) begin

    regwrite   = 0;
    memread    = 0;
    memwrite   = 0;
    ALUsrc     = 0;
    ALUop      = 2'b00;
    branch_en  = 0;
    src_a_sel  = 0;
    lbu_flag = 0;  
    lhu_flag = 0;
    lb_flag = 0;  
    lh_flag = 0;  
    sb_flag = 0;  
    sh_flag = 0;  
    

    case (opcode)
        `OPCODE_Arith_R: begin
            regwrite   = 1;
            ALUsrc     = 0;
            ALUop      = 2'b10;
        end

        `OPCODE_Arith_I: begin
            regwrite   = 1;
            ALUsrc     = 1;
            ALUop      = 2'b11;
        end

        `OPCODE_Load: begin
            regwrite   = 1;
            memread    = 1;
            ALUsrc     = 1;
            ALUop      = 2'b00;

            case (funct3) 
                3'b000: lb_flag = 1;
                3'b001: lh_flag = 1; 
                3'b100: lbu_flag = 1;
                3'b101: lhu_flag = 1; 
                default: ;  
            endcase
        end

        `OPCODE_Store: begin
            memwrite   = 1;
            ALUsrc     = 1;
            ALUop      = 2'b00;

            case (funct3)  
                3'b000: sb_flag = 1;  
                3'b001: sh_flag = 1;  
                default: ; 
            endcase
        end

        `OPCODE_Branch: begin
            branch_en  = 1;
            ALUsrc     = 0;
            ALUop      = 2'b01;
        end

        `OPCODE_JAL: begin
            regwrite   = 1;
            src_a_sel  = 1;
            ALUsrc     = 1;
            ALUop      = 2'b00;
        end

        `OPCODE_JALR: begin
            regwrite   = 1;
            src_a_sel  = 0;
            ALUsrc     = 1;
            ALUop      = 2'b00; 
        end

        `OPCODE_LUI: begin
            regwrite   = 1;
            ALUsrc     = 1;
            ALUop      = 2'b11; 
        end

        `OPCODE_AUIPC: begin
            regwrite   = 1;
            src_a_sel  = 1;
            ALUsrc     = 1;
            ALUop      = 2'b00;
        end

        default: begin
            regwrite   = 0;
            memread    = 0;
            memwrite   = 0;
            ALUsrc     = 0;
            ALUop      = 2'b00;
            branch_en  = 0;
            src_a_sel  = 0;
            lbu_flag = 0;  
            lhu_flag = 0;
            lb_flag = 0;  
            lh_flag = 0;  
            sb_flag = 0;  
            sh_flag = 0;  
    

        end
    endcase
end

endmodule

