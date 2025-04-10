`timescale 1ns / 1ps
`include "defines.v"

module Datapath(input clk, rst);

    // Instruction & PC Wires
    wire [31:0] instruction, pc, pc_next, pcadder, pc_branch_adder;

    // Control Signals
    wire branch, branch_en, memread, memtowrite, lb, lh, lbu, lhu, sb, sh;
    wire ALUsrc, regtowrite, src_a_sel;
    wire [1:0] ALUop;
    wire [3:0] ALUSel;

    // ALU and Operand Wires
    wire [31:0] ReadData1, ReadData2, alu_out;
    wire [31:0] gen_out, alu_mux1, alu_mux2;
    wire Z, C, V, S;

    // Memory and Write-back
    wire [31:0] mem_data, write_data;
    reg  [1:0]  wb_sel;

    // Program Counter
    Register progcount (.clk(clk), .rst(rst), .d(pc_next), .q(pc));

    assign pcadder = pc + 4;
    assign pc_branch_adder = pc + (gen_out);

    assign pc_next = (instruction[6:2] == `OPCODE_JALR) ? ((ReadData1 + gen_out) & 32'hFFFF_FFFE) :
                     (instruction[6:2] == `OPCODE_JAL)  ? pc + gen_out :
                      (instruction[6:2] == 5'b11100 || instruction[6:2] ==  5'b00011) ? pc :
                     ((branch && branch_en) ? pc_branch_adder : pcadder);

    // Instruction Memory
    InstMem inst (
        .addr(pc[7:2]),
        .data_out(instruction)
    );

    // Control Unit
    control_unit ctrl (
        .opcode(instruction[6:2]),
        .funct3(instruction[14:12]),
        .regwrite(regtowrite),
        .memread(memread),
        .memwrite(memtowrite),
        .ALUsrc(ALUsrc),
        .ALUop(ALUop),
        .branch_en(branch_en),
        .src_a_sel(src_a_sel),
        .lb_flag(lb),  
        .lh_flag(lh), 
        .lbu_flag(lbu),  
        .lhu_flag(lhu),  
        .sb_flag(sb),  
        .sh_flag(sh) 
    );

    // Register File
    RegFile regs (
        .RegWrite(regtowrite),
        .ReadReg1(instruction[19:15]),
        .ReadReg2(instruction[24:20]),
        .WriteReg(instruction[11:7]),
        .clk(clk),
        .rst(rst), 
        .WriteData(write_data),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // Immediate Generator
    ImmGen imm (
        .Imm(gen_out),
        .IR(instruction)
    );

    // ALU Control
    ALUcntrl ALUc (
        .ALUOp(ALUop),
        .funct3(instruction[14:12]),
        .funct7(instruction[30]),
        .ALUSel(ALUSel)
    );
    
        // ALU Input Selection
    assign alu_mux1 = (src_a_sel) ? pc : ReadData1; 
    assign alu_mux2 = (ALUsrc) ? gen_out : ReadData2;

    // ALU
    ALU alu (
        .a(alu_mux1),
        .b(alu_mux2),
        .shamt(alu_mux2[4:0]),
        .r(alu_out),
        .cf(C),
        .zf(Z),
        .vf(V),
        .sf(S),
        .alufn(ALUSel)
    );

    // Branch Logic
    Branchcntrl brnch (
        .funct3(instruction[14:12]),
        .z(Z),
        .c(C),
        .v(V),
        .s(S),
        .Branch(branch)
    );

    // Data Memory
    DataMem data (
        .clk(clk),
        .MemRead(memread),
        .MemWrite(memtowrite),
        .lh(lh), 
        .lb(lb),
        .lhu(lhu), 
        .lbu(lbu), 
        .sh(sh), 
        .sb(sb),
        .addr(alu_out[7:2]),
        .data_in(ReadData2),
        .data_out(mem_data)
    );

    // Write-Back Source Selection
    always @(*) begin
        case (instruction[6:2])
            `OPCODE_Arith_R,
            `OPCODE_Arith_I: wb_sel = 2'b00; 
            `OPCODE_Load:    wb_sel = 2'b01; 
            `OPCODE_JAL,
            `OPCODE_JALR:    wb_sel = 2'b10; 
            default:         wb_sel = 2'b00;
        endcase
    end

    assign write_data = (wb_sel == 2'b00) ? alu_out :
                        (wb_sel == 2'b01) ? mem_data :
                        (wb_sel == 2'b10) ? pcadder :
                        (wb_sel == 2'b11) ? gen_out : 32'd0;

endmodule

