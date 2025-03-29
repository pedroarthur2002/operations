module testbench_determinante_5x5();
    // Sinais para o módulo sob teste
    reg [199:0] matriz_entrada;
    wire [31:0] det_saida;
    
    // Matrizes de teste
    reg [7:0] matriz_teste1 [0:4][0:4];
    reg [7:0] matriz_teste2 [0:4][0:4];
    reg [7:0] matriz_teste3 [0:4][0:4];
    reg [7:0] matriz_teste4 [0:4][0:4];
    reg [7:0] matriz_teste5 [0:4][0:4];
    
    // Valores esperados
    reg [31:0] det_esperado;
    
    // Instância do módulo a ser testado
    determinante_5x5 dut (
        .matriz_5x5(matriz_entrada),
        .det(det_saida)
    );
    
    // Variáveis para iteração
    integer i, j;
    
    // Utilitário para exibir a matriz
    task exibir_matriz;
        input [7:0] mat [0:4][0:4];
        begin
            $display("Matriz de teste:");
            for (i = 0; i < 5; i = i + 1) begin
                $write("  ");
                for (j = 0; j < 5; j = j + 1)
                    $write("%4d ", $signed(mat[i][j]));
                $display("");
            end
        end
    endtask
    
    // Carrega matriz para o formato de entrada
    task carregar_matriz;
        input [7:0] mat [0:4][0:4];
        begin
            matriz_entrada = 0;
            for (i = 0; i < 5; i = i + 1)
                for (j = 0; j < 5; j = j + 1)
                    matriz_entrada[(i*40+j*8) +: 8] = mat[i][j];
        end
    endtask
    
    initial begin
        // Inicialização
        $display("Iniciando testes do módulo determinante_5x5");
        
        // ---- Teste 1: Matriz identidade (determinante = 1) ----
        $display("\n--- Teste 1: Matriz Identidade ---");
        // Inicializa matriz identidade
        for (i = 0; i < 5; i = i + 1)
            for (j = 0; j < 5; j = j + 1)
                matriz_teste1[i][j] = (i == j) ? 1 : 0;
        
        exibir_matriz(matriz_teste1);
        carregar_matriz(matriz_teste1);
        det_esperado = 1;
        
        #10; // Aguarda o cálculo
        $display("Determinante calculado: %d, Esperado: %d, %s", 
                 $signed(det_saida), $signed(det_esperado), 
                 (det_saida === det_esperado) ? "PASSOU" : "FALHOU");
        
        // ---- Teste 2: Matriz triangular (determinante = produto da diagonal) ----
        $display("\n--- Teste 2: Matriz Triangular ---");
        // Inicializa matriz triangular superior
        for (i = 0; i < 5; i = i + 1)
            for (j = 0; j < 5; j = j + 1)
                matriz_teste2[i][j] = (j >= i) ? (i+1) : 0;
        
        exibir_matriz(matriz_teste2);
        carregar_matriz(matriz_teste2);
        det_esperado = 1*2*3*4*5; // Produto da diagonal
        
        #10; // Aguarda o cálculo
        $display("Determinante calculado: %d, Esperado: %d, %s", 
                 $signed(det_saida), $signed(det_esperado), 
                 (det_saida === det_esperado) ? "PASSOU" : "FALHOU");
        
        // ---- Teste 3: Matriz com linhas iguais (determinante = 0) ----
        $display("\n--- Teste 3: Matriz com Linhas Iguais ---");
        // Inicializa matriz com duas linhas iguais
        for (i = 0; i < 5; i = i + 1)
            for (j = 0; j < 5; j = j + 1)
                matriz_teste3[i][j] = (i == j) ? 2 : 1;
        
        // Faz a linha 3 igual à linha 2
        for (j = 0; j < 5; j = j + 1)
            matriz_teste3[3][j] = matriz_teste3[2][j];
        
        exibir_matriz(matriz_teste3);
        carregar_matriz(matriz_teste3);
        det_esperado = 0; // Linhas iguais -> determinante = 0
        
        #10; // Aguarda o cálculo
        $display("Determinante calculado: %d, Esperado: %d, %s", 
                 $signed(det_saida), $signed(det_esperado), 
                 (det_saida === det_esperado) ? "PASSOU" : "FALHOU");
        
        // ---- Teste 4: Matriz com valores variados ----
        $display("\n--- Teste 4: Matriz com Valores Variados ---");
        matriz_teste4[0][0] = 2;  matriz_teste4[0][1] = 3;  matriz_teste4[0][2] = 1;  matriz_teste4[0][3] = 5;  matriz_teste4[0][4] = 6;
        matriz_teste4[1][0] = 4;  matriz_teste4[1][1] = 1;  matriz_teste4[1][2] = 0;  matriz_teste4[1][3] = 2;  matriz_teste4[1][4] = 3;
        matriz_teste4[2][0] = 2;  matriz_teste4[2][1] = 5;  matriz_teste4[2][2] = 3;  matriz_teste4[2][3] = 4;  matriz_teste4[2][4] = 1;
        matriz_teste4[3][0] = 1;  matriz_teste4[3][1] = 2;  matriz_teste4[3][2] = 4;  matriz_teste4[3][3] = 3;  matriz_teste4[3][4] = 2;
        matriz_teste4[4][0] = 5;  matriz_teste4[4][1] = 0;  matriz_teste4[4][2] = 2;  matriz_teste4[4][3] = 1;  matriz_teste4[4][4] = 3;
        
        exibir_matriz(ma