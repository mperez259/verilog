`timescale 1ns/1ps

module tb_FOC;

    reg clk;
    reg rstn;
    reg i_en;
    reg signed [15:0] a, b;

    wire o_en;
    wire signed [15:0] alpha, beta;

    FOC dut (
        .clk(clk),
        .rstn(rstn),
        .i_en(i_en),
        .a(a),
        .b(b),
        .o_en(o_en),
        .alpha(alpha),
        .beta(beta)
    );

    // -----------------------------------------
    // Clock generation
    // -----------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100 MHz
    end


    // -----------------------------------------
    // Apply sample (NEW VERSION)
    // -----------------------------------------
    task apply_sample;
        input signed [15:0] ain;
        input signed [15:0] bin;

        integer alpha_exp;
        integer beta_exp;

        begin
            // -------------------------------------------------------
            // Put a and b on the bus DURING a posedge (synchronous)
            // -------------------------------------------------------
            @(posedge clk);
            a <= ain;
            b <= bin;

            // Compute expected outputs
            alpha_exp = $rtoi(1.21875  * ain);
            beta_exp  = $rtoi(0.703125 * ain + 1.40625 * bin);

            // -------------------------------------------------------
            // HOLD i_en HIGH for 3 cycles to guarantee pipeline flow
            // -------------------------------------------------------
            @(posedge clk);
            i_en <= 1;
            @(posedge clk);
            i_en <= 1;
            @(posedge clk);
            i_en <= 1;
            @(posedge clk);
            i_en <= 0;

            // Wait full pipeline latency
            repeat(3) @(posedge clk);

            // -------------------------------------------------------
            // Print results
            // -------------------------------------------------------
            $display("----------------------------------------------");
            $display("Input:   a=%0d   b=%0d", ain, bin);
            $display("Output:  alpha=%0d   beta=%0d", alpha, beta);
            $display("Expect:  alpha=%0d   beta=%0d", alpha_exp, beta_exp);

            if (alpha == alpha_exp && beta == beta_exp)
                $display("RESULT: PASS");
            else
                $display("RESULT: MISMATCH");
        end
    endtask


    // -----------------------------------------
    // Test sequence
    // -----------------------------------------
    initial begin
        rstn = 0; 
        i_en = 0; 
        a = 0; 
        b = 0;
        #50 rstn = 1;

        apply_sample(1000,   0);
        apply_sample( 500, 300);
        apply_sample(-500, 300);
        apply_sample( 800,-200);
        apply_sample(-700,-600);
        apply_sample(16384,10000);
        apply_sample(-16000,-12000);

        #200 $finish;
    end

endmodule
