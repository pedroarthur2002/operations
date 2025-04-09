module tb_ula_determinante;

    reg clk;
    reg signed [199:0] matriz;
    reg [1:0] tamanho_matriz;
    wire signed [7:0] det;
    wire overflow_flag;

    // Instanciação do DUT
    ula_determinante uut (
        .clk(clk),
        .matriz(matriz),
        .tamanho_matriz(tamanho_matriz),
        .det(det),
        .overflow_flag(overflow_flag)
    );

    initial begin
        // Gerando o sinal de clock
        clk = 0;
        forever #5 clk = ~clk;  // Geração de clock com 5 unidades de tempo
    end

    initial begin
        // Teste com matriz 2x2 com valores grandes para causar overflow
        matriz = {8'sd100, 8'sd50, 8'sd30, 8'sd60};  // Matriz 2x2: | 100  50 |
                                                           //                | 30   60 |
        tamanho_matriz = 2'b00;  // 2x2
        #10;
        
        // Exibe a matriz 2x2
        $display("Matriz 2x2:");
        $display("| %0d  %0d |", matriz[31:24], matriz[23:16]);
        $display("| %0d  %0d |", matriz[15:8], matriz[7:0]);
        
        // Exibe o resultado para a matriz 2x2
        $display("Resultado 2x2: Det: %0d, Overflow: %b", det, overflow_flag);

        // Teste com matriz 3x3
        matriz = {8'sd1, 8'sd2, 8'sd3, 8'sd4, 8'sd5, 8'sd6, 8'sd7, 8'sd8, 8'sd9};  // Matriz 3x3
        tamanho_matriz = 2'b01;  // 3x3
        #10;
        
        // Exibe a matriz 3x3
        $display("Matriz 3x3:");
        $display("| %0d  %0d  %0d |", matriz[71:64], matriz[63:56], matriz[55:48]);
        $display("| %0d  %0d  %0d |", matriz[47:40], matriz[39:32], matriz[31:24]);
        $display("| %0d  %0d  %0d |", matriz[23:16], matriz[15:8], matriz[7:0]);
        
        // Exibe o resultado para a matriz 3x3
        $display("Resultado 3x3: Det: %0d, Overflow: %b", det, overflow_flag);

        $finish;
    end

endmodule
