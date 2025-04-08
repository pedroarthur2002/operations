`timescale 1ns / 1ps

module MatrixAdder_tb;

    // Entradas
    reg signed [199:0] matrix_A;
    reg signed [199:0] matrix_B;
    reg [1:0] matrix_size;

    // Saídas
    wire signed [199:0] result_out;
    wire overflow;

    // Instancia o módulo
    MatrixAdder uut (
        .matrix_A(matrix_A),
        .matrix_B(matrix_B),
        .matrix_size(matrix_size),
        .result_out(result_out),
        .overflow(overflow)
    );

    // Função auxiliar para extrair elementos
    function signed [7:0] get_element;
        input [199:0] vector;
        input integer index;
        begin
            get_element = vector[index*8 +: 8];
        end
    endfunction

    // Task para exibir matriz formatada
    task display_result;
        input [199:0] data;
        input [1:0] size;
        integer i, total;
        begin
            case (size)
                2'b00: total = 2;
                2'b01: total = 3;
                2'b10: total = 4;
                2'b11: total = 5;
            endcase
            $display("Resultado da Matriz:");
            for (i = 0; i < total*total; i = i + 1) begin
                $write("%4d ", get_element(data, i));
                if ((i+1) % total == 0) $write("\n");
            end
            $display("Overflow: %b\n", overflow);
        end
    endtask

    initial begin
        // TESTE 4: Soma completa 5x5 com múltiplos overflows
        matrix_size = 2'b11;
        matrix_A = 0;
        matrix_B = 0;

        // Preenche matrix_A
        matrix_A[7:0]     = -8'sd90;
        matrix_A[15:8]    = -8'sd80;
        matrix_A[23:16]   = -8'sd70;
        matrix_A[31:24]   = -8'sd60;
        matrix_A[39:32]   = -8'sd50;
        matrix_A[47:40]   = -8'sd40;
        matrix_A[55:48]   = -8'sd30;
        matrix_A[63:56]   = -8'sd20;
        matrix_A[71:64]   = -8'sd10;
        matrix_A[79:72]   = -8'sd1;
        matrix_A[87:80]   = 8'sd120;
        matrix_A[95:88]   = 8'sd110;
        matrix_A[103:96]  = 8'sd100;
        matrix_A[111:104] = 8'sd90;
        matrix_A[119:112] = 8'sd80;
        matrix_A[127:120] = 8'sd70;
        matrix_A[135:128] = 8'sd60;
        matrix_A[143:136] = 8'sd40;
        matrix_A[151:144] = 8'sd30;
        matrix_A[159:152] = 8'sd20;
        matrix_A[167:160] = 8'sd3;
        matrix_A[175:168] = 8'sd5;
        matrix_A[183:176] = 8'sd10;
        matrix_A[191:184] = 8'sd50;
        matrix_A[199:192] = 8'sd127;

        // Preenche matrix_B
        matrix_B[7:0]     = 8'sd10;
        matrix_B[15:8]    = 8'sd9;
        matrix_B[23:16]   = 8'sd8;
        matrix_B[31:24]   = 8'sd7;
        matrix_B[39:32]   = 8'sd6;
        matrix_B[47:40]   = 8'sd5;
        matrix_B[55:48]   = 8'sd4;
        matrix_B[63:56]   = 8'sd3;
        matrix_B[71:64]   = 8'sd2;
        matrix_B[79:72]   = 8'sd1;
        matrix_B[87:80]   = 8'sd10;
        matrix_B[95:88]   = 8'sd20;
        matrix_B[103:96]  = 8'sd20;
        matrix_B[111:104] = 8'sd10;
        matrix_B[119:112] = 8'sd10;
        matrix_B[127:120] = 8'sd50;
        matrix_B[135:128] = 8'sd40;
        matrix_B[143:136] = 8'sd30;
        matrix_B[151:144] = 8'sd20;
        matrix_B[159:152] = 8'sd10;
        matrix_B[167:160] = 8'sd5;
        matrix_B[175:168] = 8'sd10;
        matrix_B[183:176] = 8'sd20;
        matrix_B[191:184] = 8'sd60;
        matrix_B[199:192] = 8'sd1;

        #10;
        $display("=== TESTE 4: Soma completa 5x5 com múltiplos overflows ===");
        display_result(result_out, matrix_size);

        $finish;
    end

endmodule
