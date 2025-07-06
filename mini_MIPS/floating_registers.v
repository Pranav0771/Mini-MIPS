`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 11:06:38 PM
// Design Name: 
// Module Name: floating_registers
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


module floating_registers(input clk,
                         input [4:0] flt_rd_reg1, 
                         input [4:0] flt_rd_reg2,
                         input [4:0] flt_wr_reg, input [31:0] wr_dt,
                         input flt_reg_wr,
                         output reg [31:0] rd_dt1, output reg [31:0] rd_dt2);
                 
  reg [31:0] flt_reg_data [31:0];
  
  assign rd_dt1 = flt_reg_data[flt_rd_reg1];
  assign rd_dt2 = flt_reg_data[flt_rd_reg2];
  
  always @(posedge clk) begin
    if(flt_reg_wr) begin
        flt_reg_data[flt_wr_reg] = wr_dt;
    end
  end

endmodule
