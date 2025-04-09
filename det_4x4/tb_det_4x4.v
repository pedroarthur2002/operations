`timescale 1ns / 1ps

module tb_det_4x4;

    reg clk;
    reg [127:0] A;
    wire signed [7:0] det;
    wire overflow_flag;

    // Instancia o módulo sob teste
    det_4x4 uut (
        .clk(clk),
        .A(A),
        .det(det),
        .overflow_flag(overflow_flag)
    );

    // Geração de clock (10ns de período)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Matriz usada nos testes
    reg signed [7:0] mat [0:15];

    // Função para empacotar a matriz em 128 bits
    function [127:0] pack_matrix;
        input dummy;  // parâmetro obrigatório para compatibilidade com Verilog-2001
        integer i;
        begin
            pack_matrix = 128'b0;
            for (i = 0; i < 16; i = i + 1) begin
                pack_matrix = pack_matrix | ({{120{1'b0}}, mat[i]} << ((15 - i) * 8));
            end
        end
    endfunction

    // Sequência de testes
    initial begin
        // Teste 1: matriz identidade 4x4
        mat[ 0] = 1; mat[ 1] = 0; mat[ 2] = 0; mat[ 3] = 0;
        mat[ 4] = 0; mat[ 5] = 1; mat[ 6] = 0; mat[ 7] = 0;
        mat[ 8] = 0; mat[ 9] = 0; mat[10] = 1; mat[11] = 0;
        mat[12] = 0; mat[13] = 0; mat[14] = 0; mat[15] = 1;

        A = pack_matrix(0);
        @(posedge clk); #1;
        $display("Identidade: det = %0d, overflow = %b", det, overflow_flag);

        // Teste 2: matriz com linhas iguais (det = 0)
        mat[ 0] = 1; mat[ 1] = 2; mat[ 2] = 3; mat[ 3] = 4;
        mat[ 4] = 5; mat[ 5] = 6; mat[ 6] = 7; mat[ 7] = 8;
        mat[ 8] = 1; mat[ 9] = 2; mat[10] = 3; mat[11] = 4;
        mat[12] = 9; mat[13] = 10; mat[14] = 11; mat[15] = 12;

        A = pack_matrix(0);
        @(posedge clk); #1;
        $display("Linhas iguais: det = %0d, overflow = %b", det, overflow_flag);

        // Teste 3: matriz com valores grandes (overflow esperado)
        mat[ 0] = 10;  mat[ 1] = 20;  mat[ 2] = 30;  mat[ 3] = 40;
        mat[ 4] = 50;  mat[ 5] = 60;  mat[ 6] = 70;  mat[ 7] = 80;
        mat[ 8] = 90;  mat[ 9] = -100; mat[10] = -110; mat[11] = -120;
        mat[12] = 100; mat[13] = 110; mat[14] = 120;  mat[15] = 127;

        A = pack_matrix(0);
        @(posedge clk); #1;
        $display("Overflow esperado: det = %0d, overflow = %b", det, overflow_flag);

        $finish;
    end

endmodule
