`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 04:33:24 PM
// Design Name: 
// Module Name: Branchcntrl
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


module Branchcntrl(input [2:0] funct3, input z, c, v, s, output reg Branch);

always @(*) begin
    case (funct3)
        `BR_BEQ:   Branch = z;         
        `BR_BNE:   Branch = ~z;        
        `BR_BLT:   Branch = (s != v);  
        `BR_BGE:   Branch = (s == v);  
        `BR_BLTU:  Branch = ~c;       
        `BR_BGEU:  Branch = c;       
        default:   Branch = 1'b0;   
    endcase
end

endmodule

