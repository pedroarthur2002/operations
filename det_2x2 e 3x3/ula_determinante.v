module ula_determinante(
    input clk,
    input signed [199:0] matriz,
    input [1:0] tamanho_matriz, 
    output reg signed [7:0] det,
    output reg overflow_flag
);

    // Saídas intermediárias dos módulos
    wire signed [7:0] det_2x2, det_3x3;
    wire overflow_flag_2x2, overflow_flag_3x3;

    // Instanciação dos módulos para determinantes de 2x2 e 3x3
    determinante_2x2 u0 (
        .matriz_2x2(matriz[31:0]), 
        .det(det_2x2), 
        .overflow_flag(overflow_flag_2x2)
    );
    
    determinante_3x3 u1 (
        .matriz_3x3(matriz[71:0]), 
        .det(det_3x3), 
        .overflow_flag(overflow_flag_3x3)
    );

    // Multiplexação da saída correta e propagação do overflow
    always @(posedge clk) begin
        case (tamanho_matriz)
            2'b00: begin
                det <= det_2x2;
                overflow_flag <= overflow_flag_2x2;  // Propaga overflow da matriz 2x2
            end
            2'b01: begin
                det <= det_3x3;
                overflow_flag <= overflow_flag_3x3;  // Propaga overflow da matriz 3x3
            end
            default: begin
                det <= 8'b0;  // Caso inválido, pode ser tratado com valor 0
                overflow_flag <= 0;  // Flag de overflow desativada por padrão
            end
        endcase
    end

endmodule
