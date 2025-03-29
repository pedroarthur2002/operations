module tb_multiplicacao_num_matriz;

    // Entradas
    reg clk;
    reg rst;
    reg signed [199:0] matriz_A;
    reg signed [7:0] num_inteiro;

    // Saida
    wire signed [199:0] nova_matriz_A;

    // Instancia do modulo que esta sendo testado
    multiplicacao_num_matriz uut (
        .clk(clk),
        .rst(rst),
        .matriz_A(matriz_A),
        .num_inteiro(num_inteiro),
        .nova_matriz_A(nova_matriz_A)
    );

    // Geracao de clock
    always begin
        #5 clk = ~clk; // Gera um clock com periodo de 10 unidades de tempo
    end

    // Sequencia de estimulos
    initial begin
        // Inicializa os sinais
        clk = 0;
        rst = 0;
        matriz_A = 200'sd0;
        num_inteiro = 8'sd0;

        // Ativa o reset
        rst = 1;
        #10 rst = 0; // Desativa o reset apos 10 unidades de tempo

        // Teste 1: Multiplicacao com numero positivo
        matriz_A = 200'sd100; // Preenche a matriz com 25 elementos de valor 100
        num_inteiro = 8'sd2; // Multiplicar por 2
        #10; // Espera 10 unidades de tempo
        exibir_matriz(nova_matriz_A);

        // Teste 2: Multiplicacao com numero negativo
        matriz_A = 200'sd50; // Preenche a matriz com 25 elementos de valor 50
        num_inteiro = -8'sd3; // Multiplicar por -3
        #10; // Espera 10 unidades de tempo
        exibir_matriz(nova_matriz_A);

        // Teste 3: Reset apos operacao
        rst = 1;
        #10 rst = 0; // Desativa o reset apos 10 unidades de tempo

        // Teste 4: Outro valor de multiplicacao
        matriz_A = 200'sd10; // Preenche a matriz com 25 elementos de valor 10
        num_inteiro = 8'sd5; // Multiplicar por 5
        #10; // Espera 10 unidades de tempo
        exibir_matriz(nova_matriz_A);

        // Teste final: Verifica a saida final apos multiplas operacoes
        matriz_A = 200'sd0; // Testa a matriz zerada
        num_inteiro = 8'sd1; // Multiplicacao por 1
        #10;
        exibir_matriz(nova_matriz_A);

        $finish; // Finaliza a simulacao
    end

    // Funcao para exibir a matriz em formato 5x5
    task exibir_matriz;
        input signed [199:0] matriz;
        integer i, j;
        reg signed [7:0] elemento;
        begin
            $display("Tempo: %0t | Matriz resultante:", $time);
            for (i = 0; i < 5; i = i + 1) begin
                for (j = 0; j < 5; j = j + 1) begin
                    elemento = matriz[(i * 5 + j) * 8 +: 8]; // Extrai cada elemento da matriz
                    $write("%d ", elemento);
                end
                $write("\n");
            end
            $display("-----------------------------");
        end
    endtask

endmodule
