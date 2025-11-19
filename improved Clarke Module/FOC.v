`timescale 1ns / 1ps

module FOC (
    input  wire clk,
    input  wire rstn,
    input  wire i_en,
    input  wire signed [15:0] a,
    input  wire signed [15:0] b,
    output reg  o_en,
    output reg  signed [15:0] alpha,
    output reg  signed [15:0] beta
);

    //----------------------------------------------------
    // Enable pipeline (3 cycles)
    //----------------------------------------------------
    reg en_s1, en_s2, en_s3;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            en_s1 <= 0;
            en_s2 <= 0;
            en_s3 <= 0;
        end else begin
            en_s1 <= i_en;
            en_s2 <= en_s1;
            en_s3 <= en_s2;
        end
    end

    //----------------------------------------------------
    // Stage 1 - snapshot inputs + compute alpha(a)
    //----------------------------------------------------
    reg signed [15:0] a_s1, b_s1;
    reg signed [15:0] alpha_s1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            a_s1     <= 0;
            b_s1     <= 0;
            alpha_s1 <= 0;
        end
        else if (en_s1) begin
            // latch inputs
            a_s1 <= a;
            b_s1 <= b;

            // alpha = 1.21875*a = 2a - a/2 - a/4 - a/32
            alpha_s1 <= (a <<< 1) - (a >>> 1) - (a >>> 2) - (a >>> 5);
        end
    end

    //----------------------------------------------------
    // Stage 2 - delay alpha + compute beta(a)
    //----------------------------------------------------
    reg signed [15:0] a_s2, b_s2;
    reg signed [15:0] alpha_s2, beta_s2;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            a_s2     <= 0;
            b_s2     <= 0;
            alpha_s2 <= 0;
            beta_s2  <= 0;
        end
        else if (en_s2) begin
            a_s2     <= a_s1;
            b_s2     <= b_s1;

            alpha_s2 <= alpha_s1;

            // beta(a) = 0.703125*a = a - a/4 - a/32 - a/64
            beta_s2 <= a_s1 - (a_s1 >>> 2) - (a_s1 >>> 5) - (a_s1 >>> 6);
        end
    end

    //----------------------------------------------------
    // Stage 3 - delay alpha again + compute beta(b)
    //----------------------------------------------------
    reg signed [15:0] alpha_s3, beta_s3;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            alpha_s3 <= 0;
            beta_s3  <= 0;
        end
        else if (en_s3) begin
            alpha_s3 <= alpha_s2;

            // beta(b) = 1.40625*b = b + b/4 + b/8 + b/32
            beta_s3 <= b_s2 + (b_s2 >>> 2) + (b_s2 >>> 3) + (b_s2 >>> 5);
        end
    end

    //----------------------------------------------------
    // Final output
    //----------------------------------------------------
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            alpha <= 0;
            beta  <= 0;
            o_en  <= 0;
        end
        else begin
            o_en  <= en_s3;
            alpha <= alpha_s3;
            beta  <= beta_s2 + beta_s3;
        end
    end

endmodule
