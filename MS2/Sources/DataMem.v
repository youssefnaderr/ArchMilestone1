`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 12:10:28 PM
// Design Name: 
// Module Name: DataMem
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


module DataMem(input clk, input MemRead, input MemWrite, input lh, input lb, input lhu, input lbu, input sh, input sb,
input [5:0] addr, input [31:0] data_in, output [31:0] data_out);

reg [31:0] mem [0:63];
reg [31:0]temp_data_out;

  always @(*) begin
    if (MemRead) begin
        if (lbu) begin 
            temp_data_out = {24'b0, mem[addr][7:0]}; 
        end else if (lhu) begin 
            temp_data_out = {16'b0, mem[addr][15:0]}; 
        end else begin 
            temp_data_out = mem[addr]; 
        end
    end
end

    
assign data_out = temp_data_out;


  always @(*) begin
        if (MemWrite) begin
            if (sb) begin 
                mem[addr][7:0] <= data_in[7:0]; 
            end else if (sh) begin 
                mem[addr][15:0] <= data_in[15:0]; 
            end else begin 
                mem[addr] <= data_in; 
            end
        end
    end
 
 
initial begin
mem[0]=32'd12345678;
mem[1]=32'd9;
mem[2]=32'd25;
end
endmodule

