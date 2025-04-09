`timescale 1ns/1ps

module tb_transposicao_matriz;

    reg signed [199:0] matrix_A;
    reg [1:0] matrix_size;
    wire signed [199:0] m_transposta_A;

    integer i;

    // Instancia o módulo de transposição
    transposicao_matriz uut (
        .matrix_A(matrix_A),
        .matrix_size(matrix_size),
        .m_transposta_A(m_transposta_A)
    );

    // Procedimento para imprimir a matriz formatada
    task print_matrix;
        input [199:0] matrix;
        input integer size;
        integer row, col, idx;
        reg signed [7:0] val;
        begin
            for (row = 0; row < size; row = row + 1) begin
                $write("[ ");
                for (col = 0; col < size; col = col + 1) begin
                    idx = row * 5 + col;
                    val = matrix[idx*8 +: 8];
                    $write("%0d ", val);
                end
                $write("]\n");
            end
        end
    endtask

    initial begin
        // =========================
        // Teste 1: matriz 2x2 positiva
        // =========================
        matrix_size = 2'b00; // 2x2
        matrix_A = 0;
        matrix_A[0*8 +: 8] = 8'sd1;
        matrix_A[1*8 +: 8] = 8'sd2;
        matrix_A[2*8 +: 8] = 8'sd3;
        matrix_A[3*8 +: 8] = 8'sd4;
        #10;
        $display("Original (2x2):");
        print_matrix(matrix_A, 2);
        $display("Transposta (2x2):");
        print_matrix(m_transposta_A, 2);
        $display("------------------------");

        // =========================
        // Teste 2: matriz 3x3 crescente
        // =========================
        matrix_size = 2'b01; // 3x3
        for (i = 0; i < 9; i = i + 1) begin
            matrix_A[i*8 +: 8] = i + 1;  // 1 a 9
        end
        #10;
        $display("Original (3x3):");
        print_matrix(matrix_A, 3);
        $display("Transposta (3x3):");
        print_matrix(m_transposta_A, 3);
        $display("------------------------");

        // =========================
        // Teste 3: matriz 4x4 com negativos
        // =========================
        matrix_size = 2'b10; // 4x4
        for (i = 0; i < 16; i = i + 1) begin
            matrix_A[i*8 +: 8] = - (i + 1);  // -1 a -16
        end
        #10;
        $display("Original (4x4):");
        print_matrix(matrix_A, 4);
        $display("Transposta (4x4):");
        print_matrix(m_transposta_A, 4);
        $display("------------------------");

        // =========================
        // Teste 4: matriz 5x5 mista
        // =========================
        matrix_size = 2'b11; // 5x5
        for (i = 0; i < 25; i = i + 1) begin
            matrix_A[i*8 +: 8] = (i % 2 == 0) ? i : -i;  // alternando sinal
        end
        #10;
        $display("Original (5x5):");
        print_matrix(matrix_A, 5);
        $display("Transposta (5x5):");
        print_matrix(m_transposta_A, 5);
        $display("------------------------");

        $finish;
    end

endmodule
