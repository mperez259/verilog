`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: breX at Cal Poly Pomona
// Student: M.Alonzo Perez
// 
// Create Date: 10/06/2025 11:46:55 PM
// Module Name: Clarke_Park
// Project Name: sensored FOC
// Target Devices: Artix-7 100T
// Description: Clarke & Park transform for breX autonomous vehicle.
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module Clarke_Transform(
    input  signed [15:0] i_a, i_b, i_c,       // 16 bit signed phase currents (signed for neg. values)
    output reg signed [15:0] i_alpha, i_beta  // 16 bit signed 2 ph transform (clarke)
);

// constants 
localparam signed [15:0] sqrt_2thirds = 16'sh6882;   // 16 bit signed hex sqrt(2/3) ≈ 0.81649658 * 2^15(max signed 16 bit num)
localparam signed [15:0] sqrt_1sixth  = 16'sh3441;   // 16 bit signed hex sqrt(1/6) ≈ 0.40824829
localparam signed [15:0] sqrt_half    = 16'sh5A82;   // 16 bit signed hex sqrt(1/2) ≈ 0.70710678

// temp 32-bit registers to hold the multiplication of two 16 bit nums e.g. 
reg signed [31:0] temp_ia, temp_ib, temp_ic, temp_ic1, temp_ib1;

// main clarke transform
always @ (i_a or i_b or i_c)
begin
    // store temporary 32 bit values from multiplying [15:0] constant and [15:0] ph current
    temp_ia = sqrt_2thirds * i_a;
    temp_ib = sqrt_1sixth  * i_b;
    temp_ic = sqrt_1sixth  * i_c;
    
    // alpha-axis current
    // shift back to 16 bit by shifting by 15 and an extra 
    // shift by 1 to prevent overflow,
    // i_alpha/beta are now half the true value
    i_alpha = (temp_ia - temp_ib - temp_ic) >>> 16; 

    // recompute for beta axis using sqrt(1/2)
    temp_ib1 = sqrt_half * i_b;
    temp_ic1 = sqrt_half * i_c;

    // beta-axis current
    i_beta = (temp_ib1 - temp_ic1) >>> 16;
end

endmodule

