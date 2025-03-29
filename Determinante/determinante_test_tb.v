`timescale 1ns / 1ps

module determinante_tb;
    reg signed [199:0] matriz;
    reg [1:0] sinalizador;
    wire signed [31:0] det;
    
    determinante uut (
        .matriz(matriz),
        .sinalizador(sinalizador),
        .det(det)
    );
    
    initial begin
        $monitor("Sinalizador = %b, Determinante = %d", sinalizador, det);
        
        // Teste 2x2 - Esperado: 5
        sinalizador = 2'b00;
        matriz = {8'd2, 8'd3, 8'd1, 8'd4};
        #10;
        
        // Teste 3x3 - Esperado: -27
        sinalizador = 2'b01;
        matriz = {8'd2, -8'd3, 8'd1, 8'd4, 8'd5, 8'd6, 8'd7, 8'd8, 8'd9};
        #10;
        
        // Teste 4x4 - Esperado: 16
        sinalizador = 2'b10;
        matriz = {8'd1, 8'd2, 8'd3, 8'd4,
                  8'd2, 8'd4, 8'd6, 8'd8,
                  8'd3, 8'd1, 8'd5, 8'd7,
                  8'd4, 8'd3, 8'd8, 8'd2};
        #10;
        
        // Teste 5x5 - Esperado: 44
        sinalizador = 2'b11;
        matriz = {8'd1, 8'd2, 8'd3, 8'd4, 8'd5,
                  8'd0, 8'd1, 8'd4, 8'd7, 8'd8,
                  8'd5, 8'd6, 8'd7, 8'd8, 8'd9,
                  8'd1, 8'd3, 8'd5, 8'd7, 8'd9,
                  8'd2, 8'd4, 8'd6, 8'd8, 8'd10};
        #10;
        
        $finish;
    end
endmodule
