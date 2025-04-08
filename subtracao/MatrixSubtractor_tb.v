`timescale 1ns / 1ps

module MatrixSubtractor_tb;

    // Entradas
    reg signed [199:0] matrix_A;
    reg signed [199:0] matrix_B;
    reg [1:0] matrix_size;

    // Saídas
    wire signed [199:0] result_out;
    wire overflow;

    integer i;

    // Instancia o módulo
    MatrixSubtractor uut (
        .matrix_A(matrix_A),
        .matrix_B(matrix_B),
        .matrix_size(matrix_size),
        .result_out(result_out),
        .overflow(overflow)
    );

    // Procedimento de teste
    initial begin
        $display("Iniciando testes de MatrixSubtractor...");

        // TESTE 1: 2x2 sem overflow
        matrix_size = 2'b00;
        matrix_A = 0;
        matrix_B = 0;

        matrix_A[7:0]   = 10;
        matrix_A[15:8]  = 20;
        matrix_A[23:16] = 30;
        matrix_A[31:24] = 40;

        matrix_B[7:0]   = 5;
        matrix_B[15:8]  = 10;
        matrix_B[23:16] = 15;
        matrix_B[31:24] = 20;

        #10;
        $display("Teste 1 (2x2 sem overflow):");
        for (i = 0; i < 4; i = i + 1) begin
            $display("Result[%0d] = %0d", i, result_out[i*8 +: 8]);
        end
        $display("Overflow = %b\n", overflow);

        // TESTE 2: 3x3 com overflow (-128 - 1 = -129)
        matrix_size = 2'b01;
        matrix_A = 0;
        matrix_B = 0;

        matrix_A[7:0]   = -128;   // A[0]
        matrix_B[7:0]   = 1;      // B[0] → overflow esperado

        matrix_A[15:8]  = 100;
        matrix_B[15:8]  = 10;

        matrix_A[23:16] = 50;
        matrix_B[23:16] = 20;

        matrix_A[31:24] = 30;
        matrix_B[31:24] = 10;

        matrix_A[39:32] = 20;
        matrix_B[39:32] = 5;

        matrix_A[47:40] = 10;
        matrix_B[47:40] = 2;

        matrix_A[55:48] = 5;
        matrix_B[55:48] = 1;

        matrix_A[63:56] = 0;
        matrix_B[63:56] = -5;

        matrix_A[71:64] = -10;
        matrix_B[71:64] = -20;

        #10;
        $display("Teste 2 (3x3 com overflow esperado):");
        for (i = 0; i < 9; i = i + 1) begin
            $display("Result[%0d] = %0d", i, result_out[i*8 +: 8]);
        end
        $display("Overflow = %b\n", overflow);

        // TESTE 3: 5x5 sem overflow (A[i] = i+10, B[i] = i)
        matrix_size = 2'b11;
        matrix_A = 0;
        matrix_B = 0;

        for (i = 0; i < 25; i = i + 1) begin
            matrix_A[i*8 +: 8] = i + 10;
            matrix_B[i*8 +: 8] = i;
        end

        #10;
        $display("Teste 3 (5x5 sem overflow):");
        for (i = 0; i < 25; i = i + 1) begin
            $display("Result[%0d] = %0d", i, result_out[i*8 +: 8]);
        end
        $display("Overflow = %b\n", overflow);

        $finish;
    end
endmodule
