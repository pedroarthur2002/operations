`timescale 1ns/1ps

module multiplicacao_num_matriz_tb;

    reg signed [199:0] matriz_A;
    reg signed [7:0] num_inteiro;
    reg [1:0] matrix_size;
    wire signed [199:0] nova_matriz_A;
    wire overflow_flag;

    // Instancia o módulo de multiplicação
    multiplicacao_num_matriz uut (
        .matriz_A(matriz_A),
        .num_inteiro(num_inteiro),
        .matrix_size(matrix_size),
        .nova_matriz_A(nova_matriz_A),
        .overflow_flag(overflow_flag)
    );

    integer i;
    reg signed [7:0] A[0:24];
    reg signed [7:0] res[0:24];

    // Procedimento inicial
    initial begin
        // ========== TESTE 1: 2x2 ==========
        matrix_size = 2'b00;
        num_inteiro = 3;

        A[0] = 1; A[1] = 2; A[2] = 3; A[3] = 4;
        for (i = 4; i < 25; i = i + 1) A[i] = 0;

        matriz_A = 0;
        for (i = 0; i < 25; i = i + 1)
            matriz_A[i*8 +: 8] = A[i];

        #10;
        $display("\n==== Teste 1: 2x2 ====");
        $display("Escalar = %0d", num_inteiro);
        print_matrix(nova_matriz_A, 2);
        $display("Overflow = %b", overflow_flag);

        // ========== TESTE 2: 3x3 ==========
        matrix_size = 2'b01;
        num_inteiro = -2;

        A[0] = 5; A[1] = -10; A[2] = 3;
        A[3] = -4; A[4] = 6; A[5] = -1;
        A[6] = 8; A[7] = -7; A[8] = 2;
        for (i = 9; i < 25; i = i + 1) A[i] = 0;

        matriz_A = 0;
        for (i = 0; i < 25; i = i + 1)
            matriz_A[i*8 +: 8] = A[i];

        #10;
        $display("\n==== Teste 2: 3x3 ====");
        $display("Escalar = %0d", num_inteiro);
        print_matrix(nova_matriz_A, 3);
        $display("Overflow = %b", overflow_flag);

        // ========== TESTE 3: 4x4 com overflow ==========
        matrix_size = 2'b10;
        num_inteiro = 20;

        for (i = 0; i < 16; i = i + 1) A[i] = (i % 2 == 0) ? 8'd7 : -8'd7;
        for (i = 16; i < 25; i = i + 1) A[i] = 0;

        matriz_A = 0;
        for (i = 0; i < 25; i = i + 1)
            matriz_A[i*8 +: 8] = A[i];

        #10;
        $display("\n==== Teste 3: 4x4 (com overflow) ====");
        $display("Escalar = %0d", num_inteiro);
        print_matrix(nova_matriz_A, 4);
        $display("Overflow = %b", overflow_flag);

        // ========== TESTE 4: 5x5 ==========
        matrix_size = 2'b11;
        num_inteiro = 1;

        for (i = 0; i < 25; i = i + 1) A[i] = i - 12;

        matriz_A = 0;
        for (i = 0; i < 25; i = i + 1)
            matriz_A[i*8 +: 8] = A[i];

        #10;
        $display("\n==== Teste 4: 5x5 ====");
        $display("Escalar = %0d", num_inteiro);
        print_matrix(nova_matriz_A, 5);
        $display("Overflow = %b", overflow_flag);

        $finish;
    end

    // Procedimento para imprimir matriz formatada
    task print_matrix;
        input [199:0] flat;
        input integer size;
        integer i, j;
        reg signed [7:0] val;
        begin
            for (i = 0; i < size; i = i + 1) begin
                for (j = 0; j < size; j = j + 1) begin
                    val = flat[(i*size + j)*8 +: 8];
                    $write("%4d ", val);
                end
                $write("\n");
            end
        end
    endtask

endmodule
