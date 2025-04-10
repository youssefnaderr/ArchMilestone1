`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/06/2025 02:31:30 PM
// Design Name:
// Module Name: shifter
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

module Shifter (
    input  wire [31:0] a,         // Value to shift
    input  wire [4:0]  shamt,     // Shift amount
    input  wire [1:0]  type,      
    output reg  [31:0] r          // Result
);



always @(*) begin
    case (type)
        01: r = a << shamt;               // Shift Left Logical
        00: r = a >> shamt;               // Shift Right Logical
        10: r = $signed(a) >>> shamt;     // Shift Right Arithmetic
        default:    r = 32'b0;                    // Safe fallback
    endcase
end

endmodule
