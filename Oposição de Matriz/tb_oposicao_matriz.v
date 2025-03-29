`timescale 1ns/1ps

module tb_oposicao_matriz();
    // Testbench signals
    reg clk;
    reg reset;
    reg signed [199:0] matriz_A;
    wire signed [199:0] m_oposta_A;

    // Instantiate the module under test
    oposicao_matriz uut (
        .clk(clk),
        .reset(reset),
        .matriz_A(matriz_A),
        .m_oposta_A(m_oposta_A)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    // Task to print matrix elements
    task print_matrix;
        input [199:0] matrix;
        input [(8*25)-1:0] matrix_name;
        integer j;
        begin
            $display("%s:", matrix_name);
            for (j = 0; j < 25; j = j + 1) begin
                $display("Element %2d: %4d", j, $signed(matrix[j*8 +: 8]));
            end
        end
    endtask

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        matriz_A = 200'b0;

        // Test Case 1: Positive Matrix Values
        $display("Test Case 1: Positive Values");
        for (integer i = 0; i < 25; i = i + 1) begin
            matriz_A[i*8 +: 8] = i + 1;  // Fill with positive values
        end
        
        #10;  // Wait for computation
        
        // Print original and opposite matrices
        print_matrix(matriz_A, "Original Matrix");
        print_matrix(m_oposta_A, "Opposite Matrix");

        // Test Case 2: Negative Matrix Values
        $display("\nTest Case 2: Negative Values");
        matriz_A = 200'b0;
        for (integer i = 0; i < 25; i = i + 1) begin
            matriz_A[i*8 +: 8] = -(i + 1);  // Fill with negative values
        end
        
        #10;  // Wait for computation
        
        // Print original and opposite matrices
        print_matrix(matriz_A, "Original Matrix");
        print_matrix(m_oposta_A, "Opposite Matrix");

        // Finish simulation
        #10 $finish;
    end

    // Optional: Waveform generation
    initial begin
        $dumpfile("matrix_negation_tb.vcd");
        $dumpvars(0, tb_oposicao_matriz);
    end
endmodule