module transposicao_matriz( 
    input signed [199:0] matrix_A,             // Matriz original (até 5x5 de 8 bits)
    input [1:0] matrix_size,                   // Tamanho da matriz (2x2, 3x3, 4x4, 5x5)
    output reg signed [199:0] m_transposta_A   // Matriz transposta (resultado)
);

    wire [2:0] size;  // Tamanho real da matriz (2 a 5)
    assign size = (matrix_size == 2'b00) ? 2 :
                  (matrix_size == 2'b01) ? 3 :
                  (matrix_size == 2'b10) ? 4 : 5;

    integer row, col;
    integer orig_idx, transp_idx;

    always @(*) begin
        m_transposta_A = 200'd0;

        for (row = 0; row < size; row = row + 1) begin
            for (col = 0; col < size; col = col + 1) begin
                orig_idx    = row * 5 + col;    // Posição na matriz original
                transp_idx  = col * 5 + row;    // Posição transposta

                m_transposta_A[transp_idx * 8 +: 8] = matrix_A[orig_idx * 8 +: 8];
            end
        end
    end

endmodule
