// Semaforo: ROJO 10 s, VERDE 8 s, AMARILLO 3 s.
// tiempo son los segundos transcurridos en el estado actual;
// reinicia = 1 pide poner el contador de tiempo en cero al cambiar de estado.
module fsm_semaforo (
    input  wire       clk,
    input  wire       rst,
    input  wire       tick,
    input  wire [3:0] tiempo,
    output wire       reinicia,
    output wire       rojo,
    output wire       amarillo,
    output wire       verde
);
    localparam ROJO     = 2'd0;
    localparam VERDE    = 2'd1;
    localparam AMARILLO = 2'd2;

    reg [1:0] estado;
    reg       fin;

    always @(*) begin
        case (estado)
            ROJO:    fin = (tiempo == 4'd9);
            VERDE:   fin = (tiempo == 4'd7);
            default: fin = (tiempo == 4'd2);
        endcase
    end

    assign reinicia = tick & fin;

    always @(posedge clk) begin
        if (rst)
            estado <= ROJO;
        else if (reinicia) begin
            case (estado)
                ROJO:    estado <= VERDE;
                VERDE:   estado <= AMARILLO;
                default: estado <= ROJO;
            endcase
        end
    end

    assign rojo     = (estado == ROJO);
    assign verde    = (estado == VERDE);
    assign amarillo = (estado == AMARILLO);
endmodule
