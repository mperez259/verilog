# Clarke Transform

Implements the Clarke transformation to convert 3-phase current signals (a, b, c) 
to 2-phase stationary reference frame (α, β).
<img width="227" height="242" alt="image" src="https://github.com/user-attachments/assets/95102575-cd47-40d9-ba58-4bae009f0958" />

## Files
- `Clarke_Transform.v` — Core transformation module  
- `Clarke_Transform_TB.v` — Testbench for verification  
- `TB_Result_Clarke_Transform.png` — Simulation waveform result  

## Notes
The transform uses the power-invariant scaling (√(2/3)).
<img width="1033" height="659" alt="TB_Result_Clarke_Transform" src="https://github.com/user-attachments/assets/1d757420-8506-464f-9bed-525c9570a679" />
