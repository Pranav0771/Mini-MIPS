`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 07:46:44 PM
// Design Name: 
// Module Name: update_PC
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


module update_pc (
    input [31:0] old,  // the original program addr.
    input [31:0] instruction,  // the original instruction
    // [15-0] used for sign-extention
    // [25-0] used for shift-left-2
    input Jump,
    input Jal,
    input Jr,
    input Branch,
    input Bne,
    input zero,
    input [31:0] rs_value,  // remember to wire this
    output reg [31:0] next
);

  reg [31:0] sign_ext;
  reg [31:0] old_alter;  // pc+4
  reg [31:0] jump;  // jump addr.
  reg zero_alter;
  reg [31:0] ra_reg;

  initial begin
    next = 32'b0;
  end

  always @(old) begin
    old_alter = old + 4;
  end

  always @(zero, Bne) begin
    zero_alter = zero;
    if (Bne == 1) begin
      zero_alter = !zero_alter;
    end
  end

  always @(instruction) begin
    // jump-shift-left
    jump = {4'b0, instruction[25:0], 2'b0};

    // sign-extension
    if (instruction[15] == 1'b0) begin
      sign_ext = {16'b0, instruction[15:0]};
    end else begin
      sign_ext = {{16{1'b1}}, instruction[15:0]};
    end
    sign_ext = {sign_ext[29:0], 2'b0};  // shift left
  end

  always @(instruction or old_alter or jump) begin
    jump = {old_alter[31:28], jump[27:0]};
  end

  always @(old_alter, sign_ext, jump, Branch, zero_alter, Jump) begin
    // assign next program counter value
    if(Jr == 1) begin
      next = rs_value;
    end
    if (Branch == 1 & zero_alter == 1) begin
      next = old_alter + sign_ext;
    end else begin
      next = old_alter;
    end
    if (Jump == 1) begin
      next = jump;
    end
    if(Jal == 1) begin
      ra_reg = old_alter;
      next = jump;  
    end
  end
  
//  Registers reg_file_inst (
//  .clk(clk),
//  .reg_dst(1'b1),         // for jal: write to wr_reg
//  .rd_reg1(5'd0),         // don't care for jal
//  .rd_reg2(5'd0),         // don't care for jal
//  .wr_reg(5'd31),         // $ra
//  .wr_dt(old + 4),        // PC + 4
//  .reg_wr(Jal),           // write only if jal
//  .rd_dt1(), .rd_dt2()    // not used in Next_pc
//  );

endmodule
