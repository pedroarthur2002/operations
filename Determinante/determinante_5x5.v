module determinante_5x5(
    input signed [199:0] matriz_5x5, // Matriz 5x5, cada elemento tem 8 bits
    output reg signed [31:0] det
);
    reg signed [7:0] matriz_A [4:0][4:0]; // Matriz 5x5
    integer i, j, k, pivot, contador_troca;
    reg signed [7:0] fator;
    reg signed [7:0] temp;

    always @(*) begin
        // Inicializa a matriz interna a partir da entrada
        for (i = 0; i < 5; i = i + 1)
            for (j = 0; j < 5; j = j + 1)
                matriz_A[i][j] = matriz_5x5[(i * 40 + j * 8) +: 8]; // Corrigido acesso

        // Inicializa o determinante e o contador de trocas
        det = 1;
        contador_troca = 0;

        // Eliminação de Gauss para obter matriz triangular superior
        for (k = 0; k < 5; k = k + 1) begin
            // Encontra o maior elemento na coluna para pivotamento parcial
            pivot = k;
            for (i = k + 1; i < 5; i = i + 1)
                if (matriz_A[i][k] > matriz_A[pivot][k])
                    pivot = i;

            // Se o maior valor for 0, o determinante é 0
            if (matriz_A[pivot][k] == 0) begin
                det = 0;
            end

            // Troca de linhas se necessário
            if (pivot != k) begin
                for (j = 0; j < 5; j = j + 1) begin
                    temp = matriz_A[k][j];
                    matriz_A[k][j] = matriz_A[pivot][j];
                    matriz_A[pivot][j] = temp;
                end
                contador_troca = contador_troca + 1;
            end

            // Aplica eliminação de Gauss
            for (i = k + 1; i < 5; i = i + 1) begin
                fator = matriz_A[i][k] / matriz_A[k][k];
                for (j = k; j < 5; j = j + 1)
                    matriz_A[i][j] = matriz_A[i][j] - fator * matriz_A[k][j];
            end
        end

        // O determinante é o produto da diagonal principal
        for (i = 0; i < 5; i = i + 1)
            det = det * matriz_A[i][i];

        // Ajuste para trocas de linha (trocas ímpares invertem o sinal)
        if (contador_troca % 2 == 1)
            det = -det;
    end
endmodule
