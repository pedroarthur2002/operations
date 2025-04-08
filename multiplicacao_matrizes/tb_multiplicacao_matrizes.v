`timescale 1ns / 1ps

module tb_multiplicacao_matrizes;

    reg signed [199:0] A, B;       // Entradas: matrizes A e B linearizadas
    wire [199:0] C;                // Saída: matriz resultante C
    wire overflow_flag;            // Sinal de overflow

    // Instanciação do módulo a ser testado
    multiplicacao_matrizes uut (
        .A(A),
        .B(B),
        .C(C),
        .overflow_flag(overflow_flag)
    );

    integer i, j;
    reg signed [7:0] matA [0:24];  // Matriz A em forma linearizada
    reg signed [7:0] matB [0:24];  // Matriz B em forma linearizada

    initial begin
        // Inicializa A como matriz identidade 5x5 linearizada
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                if (i == j)
                    matA[i*5 + j] = 1;
                else
                    matA[i*5 + j] = 0;
            end
        end

        // Inicializa B com valores simples (B[i][j] = i + j)
        for (i = 0; i < 5; i = i + 1)
            for (j = 0; j < 5; j = j + 1)
                matB[i*5 + j] = i + j;

        // Converte matA para vetor A (200 bits)
        A = 0;
        for (i = 0; i < 25; i = i + 1)
            A[i*8 +: 8] = matA[i];

        // Converte matB para vetor B (200 bits)
        B = 0;
        for (i = 0; i < 25; i = i + 1)
            B[i*8 +: 8] = matB[i];

        #10;

        // Exibe resultado
        $display("Resultado C = A * B:");
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1)
                $write("%4d ", $signed(C[(i*40)+(j*8) +: 8]));
            $write("\n");
        end

        if (overflow_flag)
            $display("Overflow detectado!");
        else
            $display("Nenhum overflow detectado.");

        $finish;
    end

endmodule
