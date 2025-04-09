`timescale 1ns/1ps

module MatrixAdder_tb;

  reg signed [7:0] A[0:24];
  reg signed [7:0] B[0:24];
  reg signed [7:0] result_matrix[0:24];

  reg [1:0] matrix_size;
  reg [199:0] matrix_A, matrix_B;
  wire [199:0] result_out;
  wire overflow;

  integer i;

  MatrixAdder uut (
    .matrix_A(matrix_A),
    .matrix_B(matrix_B),
    .matrix_size(matrix_size),
    .result_out(result_out),
    .overflow(overflow)
  );

  // Task para achatar as matrizes
  task set_matrices;
    input integer size_index;
    begin
      matrix_size = size_index;
      matrix_A = 0;
      matrix_B = 0;
      for (i = 0; i < 25; i = i + 1) begin
        matrix_A[i*8 +: 8] = A[i];
        matrix_B[i*8 +: 8] = B[i];
      end
    end
  endtask

  // Task para imprimir uma matriz (usa variável global)
  task print_matrix;
    input [255:0] label;
    input integer dim;
    integer r, c;
    begin
      $display("%s:", label);
      for (r = 0; r < dim; r = r + 1) begin
        for (c = 0; c < dim; c = c + 1) begin
          $write("%4d ", result_matrix[r * dim + c]);
        end
        $write("\n");
      end
      $display("");
    end
  endtask

  // Executa um teste
  task run_test;
    input [255:0] label;
    input integer size_index;
    input integer dim;
    integer j;
    begin
      set_matrices(size_index);
      #1; // Espera propagação

      $display("=== %s ===", label);
      $display("Matriz A:");
      for (j = 0; j < dim * dim; j = j + 1)
        $write("%4d%s", A[j], ((j+1)%dim == 0) ? "\n" : " ");
      $display("");

      $display("Matriz B:");
      for (j = 0; j < dim * dim; j = j + 1)
        $write("%4d%s", B[j], ((j+1)%dim == 0) ? "\n" : " ");
      $display("");

      for (j = 0; j < dim * dim; j = j + 1)
        result_matrix[j] = result_out[j*8 +: 8];

      print_matrix("Resultado da soma", dim);
      $display("Overflow: %0d\n", overflow);
      $display("-----------------------------\n");
    end
  endtask

  initial begin
    // Limpa as matrizes
    for (i = 0; i < 25; i = i + 1) begin
      A[i] = 0;
      B[i] = 0;
    end

    // Teste 2x2 sem overflow
    A[0]=10; A[1]=20; A[2]=30; A[3]=40;
    B[0]=1;  B[1]=2;  B[2]=3;  B[3]=4;
    run_test("Teste 2x2 sem overflow", 2'b00, 2);

    // Teste 3x3 negativos
    A[0]=-1; A[1]=-2; A[2]=-3; A[3]=-4; A[4]=-5; A[5]=-6; A[6]=-7; A[7]=-8; A[8]=-9;
    B[0]=-10; B[1]=-11; B[2]=-12; B[3]=-13; B[4]=-14; B[5]=-15; B[6]=-16; B[7]=-17; B[8]=-18;
    run_test("Teste 3x3 negativos", 2'b01, 3);

    // Teste 4x4 com overflow
    A[0]=127; A[1]=120; A[2]=100; A[3]=90;
    A[4]=10; A[5]=20; A[6]=30; A[7]=40;
    A[8]=-100; A[9]=-110; A[10]=-120; A[11]=-128;
    A[12]=1; A[13]=2; A[14]=3; A[15]=4;

    B[0]=10; B[1]=10; B[2]=50; B[3]=50;
    B[4]=20; B[5]=20; B[6]=20; B[7]=20;
    B[8]=-30; B[9]=-20; B[10]=-10; B[11]=-1;
    B[12]=100; B[13]=100; B[14]=100; B[15]=100;

    run_test("Teste 4x4 com overflow", 2'b10, 4);

    // Teste 5x5 misto
    for (i = 0; i < 25; i = i + 1) begin
      A[i] = i * 5 - 60;
      B[i] = (i % 2 == 0) ? 100 : -100;
    end
    run_test("Teste 5x5 misto", 2'b11, 5);

    $finish;
  end

endmodule
