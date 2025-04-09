`timescale 1ns/1ps

module MatrixSubtractor_tb;

  reg signed [7:0] A[0:24];
  reg signed [7:0] B[0:24];
  reg signed [7:0] result_matrix[0:24];

  reg [1:0] matrix_size;
  reg [199:0] matrix_A, matrix_B;
  wire [199:0] result_out;
  wire overflow;

  integer i;

  MatrixSubtractor uut (
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

  // Task para imprimir uma matriz
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

  task run_test;
    input [255:0] label;
    input integer size_index;
    input integer dim;
    integer j;
    begin
      set_matrices(size_index);
      #1;

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

      print_matrix("Resultado da subtracao", dim);
      $display("Overflow: %0d\n", overflow);
      $display("-----------------------------\n");
    end
  endtask

  initial begin
    for (i = 0; i < 25; i = i + 1) begin
      A[i] = 0;
      B[i] = 0;
    end

    // Teste 2x2 sem overflow
    A[0]=20; A[1]=30; A[2]=40; A[3]=50;
    B[0]=10; B[1]=10; B[2]=10; B[3]=10;
    run_test("Teste 2x2 sem overflow", 2'b00, 2);

    // Teste 3x3 com negativos sem overflow
    A[0]=-10; A[1]=-20; A[2]=-30; A[3]=-40; A[4]=-50; A[5]=-60; A[6]=-70; A[7]=-80; A[8]=-90;
    B[0]=-1;  B[1]=-2;  B[2]=-3;  B[3]=-4;  B[4]=-5;  B[5]=-6;  B[6]=-7;  B[7]=-8;  B[8]=-9;
    run_test("Teste 3x3 negativos sem overflow", 2'b01, 3);

    // Teste 4x4 com overflow (ex: -128 - 127 = -255 → overflow)
    A[0]=-128; A[1]=100; A[2]=50; A[3]=20;
    A[4]=30; A[5]=40; A[6]=50; A[7]=60;
    A[8]=70; A[9]=80; A[10]=90; A[11]=100;
    A[12]=127; A[13]=127; A[14]=127; A[15]=127;

    B[0]=127; B[1]=-100; B[2]=-50; B[3]=-20;
    B[4]=30;  B[5]=40;  B[6]=50;  B[7]=60;
    B[8]=70;  B[9]=80;  B[10]=90; B[11]=100;
    B[12]=-1; B[13]=-2; B[14]=-3; B[15]=-4;

    run_test("Teste 4x4 com overflow", 2'b10, 4);

    // Teste 5x5 mistura
    for (i = 0; i < 25; i = i + 1) begin
      A[i] = i * 4 - 50;
      B[i] = (i % 2 == 0) ? -100 : 100;
    end
    run_test("Teste 5x5 com mistura de sinais", 2'b11, 5);

    $finish;
  end

endmodule
