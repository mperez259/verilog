# Field Oriented Control (FOC) in Verilog – NEXYS A7

This project implements a **Field Oriented Control (FOC)** algorithm entirely in **Verilog**, targeting the **Xilinx NEXYS A7 FPGA**.  
It demonstrates modular hardware implementation of the main mathematical transforms and control loops used in BLDC/PMSM motor drives.

---

## Overview

Field Oriented Control is a technique used to achieve efficient, dynamic control of three-phase AC motors (BLDC or PMSM).  
By transforming the 3-phase currents into a rotating reference frame, the control algorithm can regulate torque and flux independently.

This implementation focuses on **hardware-level realization** of the FOC blocks in Verilog.

---

##Project Structure

| Module | Description |
|---------|--------------|
| `clarke_transform.v` | Converts 3-phase (a, b, c) currents to α–β stationary frame. |
| `park_transform.v` | Rotates α–β frame to d–q synchronous frame using rotor angle. |
| `inverse_park.v` | Converts d–q back to α–β for inverse transformation. |
| `inverse_clarke.v` | Reconstructs 3-phase signals (a, b, c) from α–β components. |
| `pid_controller.v` | Implements proportional–integral–derivative (PID) feedback for current or speed control. |
| `top_foc.v` | Top-level integration of all modules. |

---
## Description

- Synthesizable on **Xilinx Vivado**  
- Tested for **fixed-point arithmetic precision** and pipelined for better timing  
- Compatible with **NEXYS A7 (Artix-7)** FPGA  
- Core transforms verified with MATLAB/Simulink reference models  

---

## Hardware

- **Board:** Digilent NEXYS A7 (Artix-7 FPGA)  
- **Toolchain:** Xilinx Vivado  
- **Simulation:** Vivado Simulator or ModelSim  
- **Clock:** 100 MHz system clock  

---

## Future Work

- Add SVPWM generation module  
- Integrate encoder feedback and rotor angle estimation  
- Implement sensorless FOC (PLL-based or back-EMF observer)  
- Hardware test with 3-phase inverter and BLDC motor  

---

