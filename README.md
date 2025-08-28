# RISC-V Memory Architecture — Partial Write Support (VHDL)

##  Overview
This project modifies a **RISC-V** processor’s memory subsystem to correctly handle **partial stores** — **byte (SB)**, **half-word (SH)**, and **word (SW)** — with a corresponding update of the **memory controller** and a **full processor–memory simulation**.

- **ISA semantics:** RISC-V (RV32) little-endian, natural alignment assumed.
- **Partial writes:** Implemented via **byte-enable strobes** (write mask) and/or **read-modify-write** (RMW) when needed.
- **Tools:** VHDL, Quartus (Intel FPGA), ModelSim/Questa for simulation.

##  Key Features
- **Byte enables (WSTRB[3:0])** derived from address low bits for SB/SH/SW.
- **Endianness:** Little-endian data layout.
- **Misaligned access policy:** natural alignment required; **misaligned stores trap** (configurable in the controller).
- **Clean separation:** core bus ↔ memory controller ↔ RAM model/FPGA RAM.
- **Self-checking testbench** covering SB/SH/SW, aligned/edge cases, and load-after-store verification.
