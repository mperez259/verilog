`timescale 1ns / 1ps

module bin2bcd(
    input  [7:0] bin,        // 8-bit binary input
    output [11:0] bcd        // 3 BCD digits (hundreds, tens, ones)
);

wire[3:0] s0, s1, s2, s3, s4, s5, s6; //connect everything
assign bcd[0]   = bin[0];
assign bcd[4:1] = s4[3:0];
assign bcd[8:5] = s6[3:0];
assign bcd[9]   = s5[3];
assign bcd[11:10] = 0;

add_3 add3_0(
.A({0,bin[7:5]}),   // concactinate with {} to add a zero to that vector for 4 inputs
.S(s0)              // 4 bit output
);

add_3 add3_1(
.A({s0[2:0], bin[4]}),
.S(s1)
);

add_3 add3_2(
.A({s1[2:0], bin[3]}),
.S(s2)
);

add_3 add3_3(
.A({s2[2:0], bin[2]}),
.S(s3)
);

add_3 add3_4(
.A({s3[2:0], bin[1]}),
.S(s4)
);

add_3 add3_5(
.A({0, s0[3], s1[3], s2[3]}),
.S(s5)
);

add_3 add3_6(
.A({s5[2:0], s3[3]}),
.S(s6)
);

endmodule
