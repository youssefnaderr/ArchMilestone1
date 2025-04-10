`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 09:48:29 AM
// Design Name: 
// Module Name: Register
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


module Register#(parameter N = 32 )( input clk,rst, input [N-1:0] d, output [N-1:0] q);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            DFF dff_inst (.clk(clk), .rst(rst), .d(d[i]),.q(q[i]));
        end
    endgenerate
endmodule
