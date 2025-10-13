`timescale 1ns/1ps

module Clarke_Transform_TB;

    // --------- DUT I/O ---------
    reg  signed [15:0] i_a, i_b, i_c;   // 3-phase Q15 currents
    wire signed [15:0] i_alpha, i_beta; // Clarke outputs

    // Instantiate the DUT
    Clarke_Transform uut (
        .i_a(i_a),
        .i_b(i_b),
        .i_c(i_c),
        .i_alpha(i_alpha),
        .i_beta(i_beta)
    );

    // --------- Simulation parameters ---------
    real freq   = 60.0;          // 60 Hz fundamental
    real Ts     = 50e-6;         // 50 µs timestep (20 kHz sample rate)
    real omega;                  // angular frequency
    real t;                      // simulation time variable

    // Temporary integer variables for clean fixed-point conversion
    integer tmp_a, tmp_b, tmp_c;

    // --------- Initialization ---------
    initial begin
        omega = 2.0 * 3.14159265 * freq;
        t = 0.0;

        // Optional VCD file for external waveform viewers
        $dumpfile("clarke.vcd");
        $dumpvars(0, Clarke_Transform_TB);

        // Generate 5 full 60 Hz cycles (~83 ms)
        repeat (1666) begin
            // 3-phase balanced sine currents (120° apart)
            tmp_a = $rtoi(32767.0 * $sin(omega * t) + 0.5);
            tmp_b = $rtoi(32767.0 * $sin(omega * t - 2.094395102) + 0.5);
            tmp_c = $rtoi(32767.0 * $sin(omega * t + 2.094395102) + 0.5);

            // Truncate to 16-bit signed Q15
            i_a = tmp_a[15:0];
            i_b = tmp_b[15:0];
            i_c = tmp_c[15:0];

            t = t + Ts;
            #50000; // 50 µs delay in ns
        end

        $finish;
    end

endmodule
