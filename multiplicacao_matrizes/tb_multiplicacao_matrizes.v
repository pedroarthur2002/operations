// Testbench para o módulo multiplicacao_matrizes
`timescale 1ns / 1ps

module tb_multiplicacao_matrizes;

    reg signed [199:0] A, B;
    reg [1:0] matrix_size;
    wire [199:0] C;
    wire overflow_flag;

    // Instância do módulo sob teste
    multiplicacao_matrizes uut (
        .A(A),
        .B(B),
        .matrix_size(matrix_size),
        .C(C),
        .overflow_flag(overflow_flag)
    );

    // Função auxiliar para "empacotar" os dados da matriz
    function [199:0] pack_matrix;
        input signed [7:0] m0, m1, m2, m3, m4,
                           m5, m6, m7, m8, m9,
                           m10, m11, m12, m13, m14,
                           m15, m16, m17, m18, m19,
                           m20, m21, m22, m23, m24;
        begin
            pack_matrix = {m24, m23, m22, m21, m20,
                            m19, m18, m17, m16, m15,
                            m14, m13, m12, m11, m10,
                            m9,  m8,  m7,  m6,  m5,
                            m4,  m3,  m2,  m1,  m0};
        end
    endfunction

    initial begin
        $display("Teste 2x2");
        matrix_size = 2'b00;
        A = pack_matrix(1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        B = pack_matrix(5, 6, 7, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        #10;
        $display("C: %p, Overflow: %b", C, overflow_flag);

        $display("\nTeste 3x3");
        matrix_size = 2'b01;
        A = pack_matrix(1, 2, 3,
                       4, 5, 6,
                       7, 8, 9,
                       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        B = pack_matrix(9, 8, 7,
                       6, 5, 4,
                       3, 2, 1,
                       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        #10;
        $display("C: %p, Overflow: %b", C, overflow_flag);

        $display("\nTeste 4x4 com negativos e possível overflow");
        matrix_size = 2'b10;
        A = pack_matrix(-1, -2, -3, -4,
                        -5, -6, -7, -8,
                        -9, -10, -11, -12,
                        -13, -14, -15, -16,
                         0, 0, 0, 0, 0, 0, 0, 0, 0);
        B = pack_matrix(1, 2, 3, 4,
                        5, 6, 7, 8,
                        9, 10, 11, 12,
                        13, 14, 15, 16,
                         0, 0, 0, 0, 0, 0, 0, 0, 0);
        #10;
        $display("C: %p, Overflow: %b", C, overflow_flag);

        $display("\nTeste 5x5 com valores altos");
        matrix_size = 2'b11;
        A = pack_matrix(10, 20, 30, 40, 50,
                        60, 70, 80, 90, 100,
                        110, 120, -128, -64, -32,
                        -16, -8, -4, -2, -1,
                        1, 2, 3, 4, 5);
        B = pack_matrix(1, 1, 1, 1, 1,
                        1, 1, 1, 1, 1,
                        1, 1, 1, 1, 1,
                        1, 1, 1, 1, 1,
                        1, 1, 1, 1, 1);
        #10;
        $display("C: %p, Overflow: %b", C, overflow_flag);

        $finish;
    end
endmodule