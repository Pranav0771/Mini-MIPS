`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 07:24:30 PM
// Design Name: 
// Module Name: Registers
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


module Register(input clk,
                 input reg_dst,
                 input [4:0] rd_reg1, 
                 input [4:0] rd_reg2,
                 input [4:0] wr_reg, input [31:0] wr_dt, input reg_wr,
                 output reg [31:0] rd_dt1, output reg [31:0] rd_dt2);
                 
  reg [31:0] reg_data [31:0];
  
  assign rd_dt1 = reg_data[rd_reg1]
  assign rd_dt2 = reg_data[rd_reg2]
  
  always @(posedge clk) begin
    if(reg_wr) begin
      if(reg_dst) begin
        reg_data[wr_reg] = wr_dt;
      end else begin
        reg_data[rd_reg2] = wr_dt;
      end
    end
  end

endmodule
