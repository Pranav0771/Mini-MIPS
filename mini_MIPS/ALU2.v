`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 12:31:52 AM
// Design Name: 
// Module Name: ALU2
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


module ALU2(
    input [2:0] ALUcontrol,
    input [31:0] data1,
    input [31:0] data2,
    output reg [31:0] ALU_result,
    output reg cmp_result  // for comparisons
);
  
  wire sign1, sign2;
  wire [7:0] exp1, exp2;
  wire [23:0] frac1, frac2;

  assign sign1 = data1[31];
  assign sign2 = data2[31];
  assign exp1 = data1[30:23];
  assign exp2 = data2[30:23];
  assign frac1 = {1'b1, data1[22:0]};
  assign frac2 = {1'b1, data2[22:0]};

  always @(*) begin
    case(ALUcontrol)
      3'b010: begin // add.s
        // very basic unaligned FP add assuming same sign and exp
        if (data1 == 32'b0) begin
          ALU_result = data2;
        end else if (data2 == 32'b0) begin
          ALU_result = data1;
        end else if (exp1 == exp2 && sign1 == sign2) begin
          ALU_result[31] = sign1;
          ALU_result[30:23] = exp1;
          ALU_result[22:0] = (frac1 + frac2 - 24'h800000); // remove leading 1 again
        end else begin
          ALU_result = 32'b0;  // simplified for now
        end
        cmp_result = 1'b0;
      end
      3'b011: begin // sub.s
        if (exp1 == exp2 && sign1 != sign2) begin
          ALU_result[31] = sign1;
          ALU_result[30:23] = exp1;
          ALU_result[22:0] = (frac1 + frac2 - 24'h800000);
        end else begin
          ALU_result = 32'b0;
        end
        cmp_result = 1'b0;
      end
      3'b100: begin // mov.s
        ALU_result = data2;
        cmp_result = 1'b0;
      end
      3'b101: begin // c.eq.s
        ALU_result = 32'b0;
        cmp_result = (data1 == data2) ? 1'b1 : 1'b0;
      end
      3'b110: begin // c.lt.s
        ALU_result = 32'b0;
        cmp_result = ($signed(data1) < $signed(data2)) ? 1'b1 : 1'b0;
      end
      3'b111: begin // c.le.s
        ALU_result = 32'b0;
        cmp_result = ($signed(data1) <= $signed(data2)) ? 1'b1 : 1'b0;
      end
      default: begin
        ALU_result = 32'b0;
        cmp_result = 1'b0;
      end
    endcase
  end

endmodule
