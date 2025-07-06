`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 12:27:27 AM
// Design Name: 
// Module Name: ALU2_control
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


module ALU2_control(
    input [1:0] ALUop,
    input [5:0] functcode,
    output reg [2:0] ALUcontrol 
    );
 
 always @(*) begin
   case(ALUop) 
     2'b00: ALUcontrol = 3'b000; //mfc1
     2'b01: ALUcontrol = 3'b001; //mtc1
     2'b10: begin
       case(functcode)
         6'h0: ALUcontrol = 3'b010; //add.s
         6'h1: ALUcontrol = 3'b011; //sub.s
         6'h6: ALUcontrol = 3'b100; //mov.s
         6'h32: ALUcontrol = 3'b101; //c.eq.s
         6'h30: ALUcontrol = 3'b110; //c.lt.s
         6'h36: ALUcontrol = 3'b111; //c.le.s
         default: ;
       endcase
     end
     default: ;
   endcase
 end
endmodule
