`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 10:30:30 AM
// Design Name: 
// Module Name: RegFile
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



module RegFile #(parameter N = 32)( input RegWrite, [4:0]ReadReg1, [4:0]ReadReg2, 
[4:0]WriteReg,input clk,rst,input [N-1:0]WriteData, output [N-1:0]ReadData1, [N-1:0]ReadData2);

reg [N-1:0]Reg[31:0];
integer j;
assign ReadData1 =Reg[ReadReg1];
assign ReadData2 =Reg[ReadReg2];

initial begin
Reg[0]=32'b0;
end

always @(posedge clk or posedge rst) begin

if(rst)begin
for(j = 0; j < 32; j = j+1) begin
 Reg[j]=0;
end
end
else begin
if(RegWrite && WriteReg!=0) Reg[WriteReg]= WriteData;
end
end

endmodule
