`timescale 1ns / 1ps

module determinante_tb;
    reg signed [199:0] matriz; // Matriz 5x5 codificada
    wire signed [31:0] det;    // Determinante calculado
    
    // Instancia o módulo a ser testado
    determinante uut (
        .matriz(matriz),
        .det(det)
    );

    initial begin
        // Caso de teste 1: Matriz identidade (det = 1)
        matriz = {
            8'd1, 8'd0, 8'd0, 8'd0, 8'd0,
            8'd0, 8'd1, 8'd0, 8'd0, 8'd0,
            8'd0, 8'd0, 8'd1, 8'd0, 8'd0,
            8'd0, 8'd0, 8'd0, 8'd1, 8'd0,
            8'd0, 8'd0, 8'd0, 8'd0, 8'd1
        };
        #10;
        $display("Teste 1 - Matriz Identidade: Determinante = %d", det);

        // Caso de teste 2: Matriz com linha nula (det = 0)
        matriz = {
            8'd2, 8'd3, 8'd1, 8'd5, 8'd4,
            8'd7, 8'd6, 8'd2, 8'd1, 8'd3,
            8'd4, 8'd2, 8'd8, 8'd9, 8'd6,
            8'd0, 8'd0, 8'd0, 8'd0, 8'd0, // Linha nula
            8'd5, 8'd9, 8'd3, 8'd6, 8'd7
        };
        #10;
        $display("Teste 2 - Linha Nula: Determinante = %d", det);

        // Caso de teste 3: Matriz triangular superior (produto da diagonal)
        matriz = {
            8'd2, 8'd3, 8'd4, 8'd5, 8'd6,
            8'd0, 8'd7, 8'd8, 8'd9, 8'd10,
            8'd0, 8'd0, 8'd11, 8'd12, 8'd13,
            8'd0, 8'd0, 8'd0, 8'd14, 8'd15,
            8'd0, 8'd0, 8'd0, 8'd0, 8'd16
        };
        #10;
        $display("Teste 3 - Triangular Superior: Determinante = %d", det);

        // Finaliza a simulação
        $finish;
    end
endmodule
