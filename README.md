# IITK MINI-MIPS

## Overview

This project implements a MIPS-like processor architecture using Verilog. The design follows the **standard MIPS ISA**, allowing compatibility with standard MIPS compilers and toolchains for generating machine code. The processor supports both **integer and floating-point operations**, with dedicated register files and ALUs for each.

## Key Features

- **Standard MIPS ISA**: Fully compatible with standard MIPS compilers for machine code generation.
- **Integer and Floating-Point Support**:
  - Integer operations handled by `Register` and `ALU` modules.
  - IEEE-754 single-precision floating-point operations handled by `floating_registers` and `ALU2` modules.
- **Control Units**:
  - Separate control logic for integer (`control_unit`) and floating-point (`control_unit_fp`) instructions.
  - Decodes instructions and generates appropriate control signals (RegWrite, ALUSrc, MemRead, Jump, etc.).
- **Modular Design**:
  - `PC`: Program Counter module.
  - `update_pc`: Computes the next PC based on jump, branch, jr, jal, etc.
  - `memory_wrapper`: Dual-port memory interface for instruction and data memory access using Xilinx `dist_mem_gen`.
- **Register File Logic**:
  - Separate integer and floating-point register files for clean datapath separation.
- **Instruction and Data Memory**:
  - Handled through a unified wrapper module.

## Files

- `top_module.v`: Top-level processor module integrating all components.
- `Register.v`, `floating_registers.v`: Register files for integer and floating-point operations.
- `ALU.v`, `ALU2.v`: Arithmetic Logic Units for integer and floating-point computations.
- `PC.v`, `update_pc.v`: Program counter and control flow logic.
- `control_unit.v`, `control_unit_fp.v`: Control units for instruction decoding.
- `memory_wrapper.v`: Memory module using Xilinx IP (`dist_mem_gen`) for both instruction and data access.

## How to Use

1. Generate MIPS machine code (`.hex` or `.bin`) using any standard MIPS compiler (e.g., GCC with `-mips32`).
2. Load the machine code into instruction memory with the help of C code via Xilinx and run the code with a clock(loop).
3. Obtain the required outputs using the pynq board on the terminal.

## Notes

- This is a **single-cycle** processor working for only certain set of MIPS instructions as mentioned in assignment.
