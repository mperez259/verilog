# Park Transform

Implements the Park transformation to convert stationary frame signals (α, β) 
into the rotating reference frame (d, q) using the electrical rotor angle θ.

## Overview
The Park Transform projects the stationary 2-phase components obtained from the Clarke Transform 
onto a rotating reference frame that synchronizes with the rotor flux vector.  
This simplifies torque and flux control in Field-Oriented Control (FOC) systems by transforming
time-varying AC quantities into DC-like components.

---

## Mathematical Representation
<img width="293" height="95" alt="image" src="https://github.com/user-attachments/assets/d63c4785-a3d0-43b7-890b-6956840f76cb" />


This implementation uses the **power-invariant form**, maintaining equal power in both the stationary and rotating frames.

---

## Files
- [Park_Transform.v](Park_Transform.v) — Core transformation module  
- [Park_Transform_TB.v](Park_Transform_TB.v) — Testbench for verification  
- [TB_Results_Park_Transform.png](TB_Results_Park_Transform.png) — Simulation waveform result  

---

## Simulation Parameters
- Input frequency: 60 Hz  
- Sampling period: 50 µs  
- Q15 fixed-point arithmetic (1 → 32767)  
- Rotation speed: corresponds to electrical angle θ = ω·t  
- Test input: sinusoidal α-β waveforms generated from Clarke output  

---

## Notes
The Park Transform converts the orthogonal α-β components into DC quantities (d, q) 
in the rotating frame when θ follows the rotor flux vector.  
Ideally, **i_d** remains constant (flux-producing) and **i_q** represents torque-producing current.

---

## Simulation Results
![Park Transform Output](TB_Results_Park_Transform.png)
