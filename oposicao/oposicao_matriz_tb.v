`timescale 1ns / 1ps

module oposicao_matriz_tb;

    // Entradas
    reg signed [199:0] matrix_A;
    reg [1:0] matrix_size;

    // Saída
    wire signed [199:0] m_oposta_A;

    integer i;

    // Instancia o módulo
    oposicao_matriz uut (
        .matrix_A(matrix_A),
        .matrix_size(matrix_size),
        .m_oposta_A(m_oposta_A)
    );

    // Procedimento para imprimir matriz
    task print_matrix;
        input integer size;
        begin
            for (i = 0; i < size*size; i = i + 1) begin
                $write("%4d ", $signed(m_oposta_A[i*8 +: 8]));
                if ((i+1) % size == 0)
                    $write("\n");
            end
            $write("\n");
        end
    endtask

    initial begin
        $display("Iniciando testes de oposicao_matriz...\n");

        // TESTE 1: 2x2 com valores positivos e negativos
        matrix_size = 2'b00;
        matrix_A = 0;

        matrix_A[7:0]   = 8'sd10;
        matrix_A[15:8]  = -8'sd20;
        matrix_A[23:16] = 8'sd30;
        matrix_A[31:24] = -8'sd40;

        #10;
        $display("Teste 1 (2x2):");
        print_matrix(2);

        // TESTE 2: 3x3 com valores positivos
        matrix_size = 2'b01;
        matrix_A = 0;
        for (i = 0; i < 9; i = i + 1) begin
            matrix_A[i*8 +: 8] = $signed((i * 5) & 8'hFF);  // 0, 5, 10, ..., 40
        end

        #10;
        $display("Teste 2 (3x3):");
        print_matrix(3);

        // TESTE 3: 5x5 com valores negativos
        matrix_size = 2'b11;
        matrix_A = 0;
        for (i = 0; i < 25; i = i + 1) begin
            matrix_A[i*8 +: 8] = $signed(-i); // -0, -1, ..., -24
        end

        #10;
        $display("Teste 3 (5x5):");
        print_matrix(5);

        $finish;
    end

endmodule
