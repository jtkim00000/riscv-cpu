# Single-Cycle Datapath
This document provides an indepth explaination of the single-cycle datapath that I designed and tailored to the specific subset of 37 instructions I implemented. The first part of this document provides a high level overview of the datapath and its components. The second part of this document provides an indepth analysis of data flow for each instruction, providing an understanding for how the hardwired control unit functions. All datapath control signals are completely based on opcode, funct3, and funct7.

## Table of Contents
- [Datapath Overview](#datapath-overview)
- [Control Unit](#control-unit)

## Datapath Overview
The single-cycle datpath was designed to support the following subset of 37/40 instructions from the RV32I base ISA.

- Arithmetic/Logical: ADD, SUB, SLT, SLTU, AND, OR, XOR, SLL, SRL, SRA, ADDI, SLTI, SLTIU, ANDI, ORI, XORI, SLLI, SRLI, SRAI, LUI, AUIPC. (And by extension NOP)
- Jumps and Branches: JAL, JALR, BEQ, BNE, BLT, BLTU, BGE, BGEU
- Loads and Stores: LW, LH, LHU, LB, LBU, SW, SH, SB

FENCE, EBRAKE, and ECALL instructions were not implemented.

Below is a diagram of the datapath

![single-cycle-datapath](custom-riscv-single-cycle-datapath.png)

## Control Unit

