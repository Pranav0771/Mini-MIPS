module top_module(
    input wire clk
);

    // === Wires and Registers ===
    // Program Counter
    wire [31:0] pc_out, next_pc;

    // Instruction Fetch
    wire [31:0] instruction;

    // Control signals
    wire        RegDst, RegWrite, FPRegWrite;
    wire        MemRead, MemWrite, MemtoReg;
    wire        Jump, Jal, Jr, Branch, Bne;
    wire [3:0]  ALU1_ctrl;
    wire [2:0]  ALU2_ctrl;

    // Register file connections
    wire [4:0]  rs = instruction[25:21];
    wire [4:0]  rt = instruction[20:16];
    wire [4:0]  rd = instruction[15:11];
    wire [4:0]  wr_reg = (RegDst) ? rd : rt;
    wire [31:0] reg_rd1, reg_rd2;
    wire [31:0] write_data;

    // ALU1
    wire        ALUSrc = MemRead | MemWrite;
    wire        zero;
    wire [31:0] ALU1_result;

    // Data Memory
    wire [31:0] data_mem_out;

    // Floating-point data
    wire [31:0] flt_rd1, flt_rd2;
    wire [31:0] ALU2_result;
    wire        cmp_result;

    // === Module Instantiations ===

    // Program Counter
    PC pc_inst(
        .clk(clk),
        .nextPC(next_pc),
        .out(pc_out)
    );

    // Instruction Memory (read-only)
    memory_wrapper instr_mem(
        .a(pc_out[11:2]),
        .d(32'b0),
        .dpra(pc_out[11:2]),
        .clk(clk),
        .we(1'b0),
        .dpo(instruction)
    );

    // Control Unit
    control cu(
        .functcode(instruction[5:0]),
        .ALU1_control(ALU1_ctrl),
        .ALU2_control(ALU2_ctrl),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .FPRegWrite(FPRegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Jump(Jump),
        .Jal(Jal),
        .Jr(Jr),
        .Branch(Branch),
        .Bne(Bne)
    );

    // Integer Register File
    Register rf(
        .clk(clk),
        .reg_dst(RegDst),
        .rd_reg1(rs),
        .rd_reg2(rt),
        .wr_reg(wr_reg),
        .wr_dt(write_data),
        .reg_wr(RegWrite),
        .rd_dt1(reg_rd1),
        .rd_dt2(reg_rd2)
    );

    // Integer ALU
    ALU1 alu1(
        .clk(clk),
        .ALU_control(ALU1_ctrl),
        .data1(reg_rd1),
        .read2(reg_rd2),
        .immediate(instruction[15:0]),
        .ALUSrc(ALUSrc),
        .zero(zero),
        .ALU_result(ALU1_result)
    );

    // Data Memory (load/store)
    memory_wrapper data_mem(
        .a(ALU1_result[9:0]),
        .d(reg_rd2),
        .dpra(ALU1_result[9:0]),
        .clk(clk),
        .we(MemWrite),
        .dpo(data_mem_out)
    );

    // Write-back Mux for integer register
    assign write_data = (MemtoReg) ? data_mem_out : ALU1_result;

    // Floating-Point Register File
    floating_registers frf(
        .clk(clk),
        .flt_rd_reg1(rs),
        .flt_rd_reg2(rt),
        .flt_wr_reg(rd),
        .wr_dt(ALU2_result),
        .flt_reg_wr(FPRegWrite),
        .rd_dt1(flt_rd1),
        .rd_dt2(flt_rd2)
    );

    // Floating-Point ALU
    ALU2 fpu(
        .ALUcontrol(ALU2_ctrl),
        .data1(flt_rd1),
        .data2(flt_rd2),
        .ALU_result(ALU2_result),
        .cmp_result(cmp_result)
    );

    // PC Update Logic
    update_pc pc_upd(
        .old(pc_out),
        .instruction(instruction),
        .Jump(Jump),
        .Jal(Jal),
        .Jr(Jr),
        .Branch(Branch),
        .Bne(Bne),
        .zero(zero),
        .rs_value(reg_rd1),
        .next(next_pc)
    );

endmodule
