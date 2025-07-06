`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 12:12:42 AM
// Design Name: 
// Module Name: ALU1_control
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

module ALU1_control (input [1:0] ALUOp,
                    input [5:0] functcode,
                    input [5:0] opcode,
                    output reg [3:0] ALUcontrol);

  always @(*) begin
    case (ALUOp)
      2'b00:   ALUcontrol = 4'b0010;  // LW / SW / LUI | add
      2'b01:   ALUcontrol = 4'b0110;  // Branch equal / Branch Not Equal | subtract
      2'b10: begin  // R-Type
        case (functcode)
          6'h0: ALUcontrol = 4'b1000; // sll
          6'h2: ALUcontrol = 4'b1001; // srl
          6'h3: ALUcontrol = 4'b1010; // sra
          6'h18: ALUcontrol = 4'b1100; // mult
          6'h20:  // add
          ALUcontrol = 4'b0010;
          6'h21: //addu
          ALUcontrol = 4'b0010;
          6'h22: //sub
          ALUcontrol = 4'b0110;
          6'h23:  // subu
          ALUcontrol = 4'b0110;
          6'h24:  // and
          ALUcontrol = 4'b0000;
          6'h25:  // or
          ALUcontrol = 4'b0001;
          6'h25:  // xor
          ALUcontrol = 4'b0100;
          6'h2a:  // slt
          ALUcontrol = 4'b0111;
        endcase
      end
      2'b11: begin // I-type
        case (opcode)
          6'h8: ALUcontrol = 4'b0010;  // addi
          6'h9: ALUcontrol = 4'b0010;  // addiu
          6'hC: ALUcontrol = 4'b0000;  // andi
          6'hD: ALUcontrol = 4'b0001;  // ori
          6'hE: ALUcontrol = 4'b0100;  // xori
          6'hA: ALUcontrol = 4'b0111;  // slti
          6'h1C: ALUcontrol = functcode ? 4'b0101 : 4'b0011;
        endcase
      end
    endcase
  end

endmodule