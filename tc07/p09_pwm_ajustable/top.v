// PWM de 16 niveles: cada pulsacion de btn_mas sube un nivel el brillo
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire       btn_mas,
    output wire       led_pwm,
    output wire [6:0] seg
);
    wire       tick_pwm;
    wire       p_mas;
    wire [3:0] duty;

    divisor_frec #(.N(1000)) u_div (
        .clk  (clk),
        .rst  (rst),
        .tick (tick_pwm)
    );

    detector_subida u_flanco (
        .clk   (clk),
        .rst   (rst),
        .in    (btn_mas),
        .pulso (p_mas)
    );

    contador4 u_duty (
        .clk (clk),
        .rst (rst),
        .en  (p_mas),
        .q   (duty)
    );

    pwm4 u_pwm (
        .clk  (clk),
        .rst  (rst),
        .en   (tick_pwm),
        .duty (duty),
        .out  (led_pwm)
    );

    deco_7seg u_deco (
        .dato (duty),
        .seg  (seg)
    );
endmodule
