`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 11:09:29 AM
// Design Name: 
// Module Name: control
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


module control(
    input [5:0] functcode,       // Function code from instruction
    output reg [3:0] ALU1_control, // Control signal for ALU1 (integer ALU)
    output reg [2:0] ALU2_control, // Control signal for ALU2 (floating-point ALU)
    output reg RegDst,           // Register Destination signal
    output reg RegWrite,         // Register Write signal
    output reg FPRegWrite,       // Floating-point Register Write signal
    output reg MemRead,          // Memory Read signal
    output reg MemWrite,         // Memory Write signal
    output reg MemtoReg,         // Memory to Register signal
    output reg Jump,             // Jump signal
    output reg Jal,              // Jump and Link signal
    output reg Jr,               // Jump Register signal
    output reg Branch,           // Branch signal
    output reg Bne               // Branch Not Equal signal
);

always @(*) begin
    // Default values for all control signals
    ALU1_control = 4'b0000;
    ALU2_control = 3'b000;
    RegDst = 1'b0;
    RegWrite = 1'b0;
    FPRegWrite = 1'b0;
    MemRead = 1'b0;
    MemWrite = 1'b0;
    MemtoReg = 1'b0;
    Jump = 1'b0;
    Jal = 1'b0;
    Jr = 1'b0;
    Branch = 1'b0;
    Bne = 1'b0;

    // Control logic based on functcode
    case (functcode)
        6'h20: begin // add
            ALU1_control = 4'b0010;
            RegDst = 1'b1;
            RegWrite = 1'b1;
        end
        6'h22: begin // sub
            ALU1_control = 4'b0110;
            RegDst = 1'b1;
            RegWrite = 1'b1;
        end
        6'h24: begin // and
            ALU1_control = 4'b0000;
            RegDst = 1'b1;
            RegWrite = 1'b1;
        end
        6'h25: begin // or
            ALU1_control = 4'b0001;
            RegDst = 1'b1;
            RegWrite = 1'b1;
        end
        6'h2a: begin // slt
            ALU1_control = 4'b0111;
            RegDst = 1'b1;
            RegWrite = 1'b1;
        end
        6'h0: begin // sll
            ALU1_control = 4'b1000;
            RegDst = 1'b1;
            RegWrite = 1'b1;
        end
        6'h2: begin // srl
            ALU1_control = 4'b1001;
            RegDst = 1'b1;
            RegWrite = 1'b1;
        end
        6'h18: begin // mult
            ALU1_control = 4'b1100;
        end
        6'h0: begin // jr
            Jr = 1'b1;
        end
        6'h8: begin // addi
            ALU1_control = 4'b0010;
            RegWrite = 1'b1;
        end
        6'h32: begin // c.eq.s (floating-point)
            ALU2_control = 3'b101;
            FPRegWrite = 1'b1;
        end
        6'h30: begin // c.lt.s (floating-point)
            ALU2_control = 3'b110;
            FPRegWrite = 1'b1;
        end
        6'h36: begin // c.le.s (floating-point)
            ALU2_control = 3'b111;
            FPRegWrite = 1'b1;
        end
        6'h6: begin // mov.s (floating-point)
            ALU2_control = 3'b100;
            FPRegWrite = 1'b1;
        end
        6'h0: begin // add.s (floating-point)
            ALU2_control = 3'b010;
            FPRegWrite = 1'b1;
        end
        6'h1: begin // sub.s (floating-point)
            ALU2_control = 3'b011;
            FPRegWrite = 1'b1;
        end
        default: begin
            // Default case to handle unsupported functcodes
        end
    endcase
end

endmodule