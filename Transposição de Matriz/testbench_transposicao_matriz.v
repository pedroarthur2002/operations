`timescale 1ns/1ps

module testbench_transposicao_matriz();

    // Sinais de controle
    reg clk;
    reg reset;

    // Sinais de entrada e saída
    reg signed [199:0] matriz_A;
    wire signed [199:0] m_transposta_A;

    // Variáveis para loops
    integer i;

    // Instância do módulo de transposição
    transposicao_matriz uut (
        .clk(clk),
        .reset(reset),
        .matriz_A(matriz_A),
        .m_transposta_A(m_transposta_A)
    );

    // Geração do clock
    always begin
        #5 clk = ~clk;
    end

    // Procedimento de teste
    initial begin
        // Inicialização
        clk = 0;
        reset = 1;
        matriz_A = 200'sd0;

        // Primeiro ciclo de reset
        #10 reset = 0;

        // Caso de teste com números negativos
        matriz_A = {
            -8'd1,  -8'd2,  -8'd3,  -8'd4,  -8'd5,
            -8'd6,  -8'd7,  -8'd8,  -8'd9,  -8'd10,
            -8'd11, -8'd12, -8'd13, -8'd14, -8'd15,
            -8'd16, -8'd17, -8'd18, -8'd19, -8'd20,
            -8'd21, -8'd22, -8'd23, -8'd24, -8'd25
        };

        #10; // Aguarda um ciclo de clock

        // Exibe os resultados
        $display("Matriz Original (Negativos):");
        for (i = 0; i < 5; i = i + 1) begin
            $display("%d %d %d %d %d", 
                $signed(matriz_A[(i*5*8)+:8]), 
                $signed(matriz_A[(i*5*8+8)+:8]), 
                $signed(matriz_A[(i*5*8+16)+:8]), 
                $signed(matriz_A[(i*5*8+24)+:8]), 
                $signed(matriz_A[(i*5*8+32)+:8])
            );
        end

        $display("\nMatriz Transposta (Negativos):");
        for (i = 0; i < 5; i = i + 1) begin
            $display("%d %d %d %d %d", 
                $signed(m_transposta_A[(i*5*8)+:8]), 
                $signed(m_transposta_A[(i*5*8+8)+:8]), 
                $signed(m_transposta_A[(i*5*8+16)+:8]), 
                $signed(m_transposta_A[(i*5*8+24)+:8]), 
                $signed(m_transposta_A[(i*5*8+32)+:8])
            );
        end

        // Finaliza a simulação
        #10 $finish;
    end

endmodule