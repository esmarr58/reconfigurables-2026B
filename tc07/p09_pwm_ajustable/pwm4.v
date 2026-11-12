// PWM de 4 bits: out = 1 durante duty de cada 16 pasos (un paso por pulso de en)
module pwm4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire [3:0] duty,
    output wire       out
);
    reg [3:0] rampa;

    always @(posedge clk) begin
        if (rst)
            rampa <= 4'd0;
        else if (en)
            rampa <= rampa + 4'd1;
    end

    assign out = (rampa < duty);
endmodule
