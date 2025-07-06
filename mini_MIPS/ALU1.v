`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 12:12:42 AM
// Design Name: 
// Module Name: ALU1
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


module ALU1(input clk,
            input [3:0] ALU_control,
            input [31:0] data1,
            input [31:0] read2,
            input [15:0] immediate,
            input ALUSrc,
            output reg zero,
            output reg [31:0] ALU_result);
            
  reg [31:0] data2;
  reg [4:0] shamt;
  reg [31:0] HI, LO;
  reg [63:0] mult_result;

    always @(ALUSrc, read2, immediate) begin
        if (ALUSrc == 0) begin
          data2 = read2;
        end else begin
          // SignExt[instruction[15:0]]
          if (immediate[15] == 1'b0) begin
            data2 = {16'b0, immediate};
          end else begin
            data2 = {{16{1'b1}}, immediate};
          end
        end
    end
    
  always @(data1, data2, ALU_control) begin
    case (ALU_control)
      4'b0000:  // AND
      ALU_result = data1 & data2;
      4'b0001:  // OR
      ALU_result = data1 | data2;
      4'b0010:  // ADD
      ALU_result = data1 + data2;
      4'b0110:  // SUB
      ALU_result = data1 - data2;
      4'b0111:  // SLT
      ALU_result = (data1 < data2) ? 1 : 0;
      4'b1100:  // NOR
      ALU_result = data1 | ~data2;
      4'b0100: //XOR
      ALU_result = data1 ^ data2;
      4'b1000: begin  //SLL
      shamt = immediate[10:6];
      ALU_result = data1 << shamt;
      end
      4'b1001: begin  //SRL
      shamt = immediate[10:6];
      ALU_result = data1 >> shamt;
      end
      4'b1010:  begin  //SRA
      shamt = immediate[10:6];
      ALU_result = $signed(data1) >>> shamt; 
      end
      default: ALU_result = 32'b0;
    endcase
    zero = (ALU_result == 0) ? 1'b1 : 1'b0;
  end

  always @(posedge clk) begin
    case (ALU_control)
      4'b1100: begin // MULT
      mult_result = $signed(data1) * $signed(data2);
      HI <= mult_result[63:32];
      LO <= mult_result[31:0];
      end
      4'b0011: begin // MADD
      mult_result = $signed(data1) * $signed(data2);
      {HI, LO} <= {HI, LO} + mult_result;
      end
      4'b0101: begin // MADDU
      mult_result = $unsigned(data1) * $unsigned(data2);
      {HI, LO} <= {HI, LO} + mult_result;
      end
    endcase
  end

endmodule
