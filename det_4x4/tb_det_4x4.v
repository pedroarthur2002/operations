`timescale 1ns/1ps

module tb_det_4x4;

    reg clk;
    reg [127:0] A;
    wire signed [7:0] det;
    wire overflow_flag;

    integer cycles;

    // Instância do módulo a ser testado
    det_4x4 uut (
        .clk(clk),
        .A(A),
        .det(det),
        .overflow_flag(overflow_flag)
    );

    // Clock de 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Lógica de teste
    initial begin
        cycles = 0;

        // Matriz: identidade -> determinante = 1
        A = {
            8'd1, 8'd0, 8'd0, 8'd0,
            8'd0, 8'd1, 8'd0, 8'd0,
            8'd0, 8'd0, 8'd1, 8'd0,
            8'd0, 8'd0, 8'd0, 8'd1
        };

        // Espera alguns ciclos para estabilizar
        repeat (10) begin
            @(posedge clk);
            cycles = cycles + 1;
        end

        $display("Matriz identidade:");
        $display("Ciclos de clock: %0d", cycles);
        $display("Determinante: %0d", det);
        $display("Overflow: %b", overflow_flag);
        $display("-----------------------------");

        // Teste 2: Matriz com overflow esperado
        cycles = 0;
        A = {
            8'd10, 8'd20, 8'd30, 8'd40,
            8'd50, 8'd60, 8'd70, 8'd80,
            8'd90, 8'd100, 8'd110, 8'd120,
            8'd130, 8'd140, 8'd150, 8'd160
        };

        repeat (10) begin
            @(posedge clk);
            cycles = cycles + 1;
        end

        $display("Matriz com valores grandes:");
        $display("Ciclos de clock: %0d", cycles);
        $display("Determinante: %0d", det);
        $display("Overflow: %b", overflow_flag);
        $display("-----------------------------");

        $finish;
    end

endmodule
