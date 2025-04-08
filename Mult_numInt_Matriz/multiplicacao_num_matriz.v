// Módulo combinacional para multiplicar um número inteiro por uma matriz
module multiplicacao_num_matriz (
    input signed [199:0] matriz_A,          // Matriz A de entrada (25 elementos de 8 bits)
    input signed [7:0] num_inteiro,         // Número escalar (8 bits)
    output signed [199:0] nova_matriz_A,    // Matriz resultante da multiplicação
    output overflow_flag                    // Sinal geral de overflow
);

    wire [24:0] overflow;                   // Vetor plano de overflow para cada elemento

    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : multiplicacao
            wire signed [7:0] elemento_matriz = matriz_A[(i*8) +: 8];
            wire signed [15:0] multi_temporario = bit_mult(elemento_matriz, num_inteiro);

            // Atribui os 8 bits menos significativos para a nova matriz
            assign nova_matriz_A[(i*8) +: 8] = multi_temporario[7:0];

            // Detecta overflow: verifica se os bits mais significativos são extensões do bit de sinal
            assign overflow[i] = (multi_temporario[15:8] != {8{multi_temporario[7]}}) ? 1'b1 : 1'b0;
        end
    endgenerate

    // Sinal geral de overflow (se qualquer bit de overflow for 1)
    assign overflow_flag = |overflow;


    // Função de multiplicação simulada por deslocamento de bits
    function signed [15:0] bit_mult;
        input signed [7:0] a, b;
        begin
            bit_mult = 0;
            if (b[0]) bit_mult = bit_mult + a;
            if (b[1]) bit_mult = bit_mult + (a << 1);
            if (b[2]) bit_mult = bit_mult + (a << 2);
            if (b[3]) bit_mult = bit_mult + (a << 3);
            if (b[4]) bit_mult = bit_mult + (a << 4);
            if (b[5]) bit_mult = bit_mult + (a << 5);
            if (b[6]) bit_mult = bit_mult + (a << 6);
            if (b[7]) bit_mult = bit_mult - (a << 7);  // Ajuste para complemento de dois
        end
    endfunction

endmodule
