# Define o modelo

# Parâmetros
param Capacidade{1..4};  # Capacidades dos 4 centros de processamento
param Custo_sh{1..4, 1..2};  # Custos de processamento por hora para cada centro e tipo de óleo
param Recuperacao{1..4, 1..2};  # Taxa de recuperação para cada centro e tipo de óleo
param Custo_materia_prima{1..2};  # Custo da matéria-prima para cada tipo de óleo
param Preco_venda{1..2};  # Preço de venda de cada tipo de óleo
param Venda_diaria_maxima{1..2};  # Quantidade máxima que pode ser vendida diariamente de cada tipo de óleo
param Horas_operacao{1..4};  # Horas de operação diárias para cada centro
param Capacidade_transporte;  # Capacidade máxima de transporte diária

# Variáveis de decisão
var x{1..2} >= 0;  # Litros de óleo processados diariamente (x[1] para óleo tipo I, x[2] para óleo tipo II)
var x_N{1..2} >= 0;  # Litros de óleo tipo I processados no fluxo normal
var x_A{1..2} >= 0;  # Litros de óleo tipo I processados no fluxo alternativo

# Coeficientes de rendimento
param a_N := 0.9 * 0.95 * 0.85 * 0.8;  # Rendimento acumulado para o óleo tipo I no fluxo normal
param a_A := 0.9 * 0.95 * 0.85 * 0.75;  # Rendimento acumulado para o óleo tipo I no fluxo alternativo
param b := 0.9 * 0.85 * 0.80;  # Rendimento acumulado para o óleo tipo II

# Função objetivo: Maximizar o lucro
maximize Lucro:
    20 * a_N * x_N[1] + 20 * a_A * x_A[1] + 18 * b * x[2]  # Receita
    - (5 * x[1] + 5 * x_A[1] + 6 * x[2])  # Despesa com matéria-prima
    - (150 * x_N[1] / Capacidade[1] + 150 * x_A[1] / Capacidade[1] + 300 * x_N[2] / Capacidade[1])  # Custos operacionais do Centro 1
    - (200 * 0.9 * x_N[1] / Capacidade[2] + 200 * 0.9 * x_A[1] / Capacidade[2] + 220 * 0.9 * 0.95 * x_N[1] / Capacidade[2])  # Custos operacionais do Centro 2
    - (250 * 0.9 * x[2] / Capacidade[3] + 250 * 0.9 * 0.95 * x_N[1] / Capacidade[3] + 250 * 0.9 * 0.95 * 0.85 * x_A[1] / Capacidade[3])  # Custos operacionais do Centro 3
    - (180 * 0.9 * 0.95 * x_N[1] / Capacidade[4] + 180 * 0.9 * 0.95 * x_A[1] / Capacidade[4] + 240 * 0.9 * 0.85 * x[2] / Capacidade[4]);  # Custos operacionais do Centro 4

# Restrições de capacidade de processamento
s.t. Capacidade1:
    x_N[1] / Capacidade[1] + x_A[1] / Capacidade[1] + x_N[2] / Capacidade[1] <= Horas_operacao[1];  # Restrição para o Centro 1
s.t. Capacidade2:
    (0.9 * x_N[1] / Capacidade[2] + 0.9 * x_A[1] / Capacidade[2] + 0.9 * 0.95 * x_N[1] / Capacidade[2]) <= Horas_operacao[2];  # Restrição para o Centro 2
s.t. Capacidade3:
    (0.9 * x[2] / Capacidade[3] + 0.9 * 0.95 * x_N[1] / Capacidade[3] + 0.9 * 0.95 * 0.85 * x_A[1] / Capacidade[3]) <= Horas_operacao[3];  # Restrição para o Centro 3
s.t. Capacidade4:
    (0.9 * 0.95 * x_N[1] / Capacidade[4] + 0.9 * 0.95 * x_A[1] / Capacidade[4] + 0.9 * 0.85 * x[2] / Capacidade[4]) <= Horas_operacao[4];  # Restrição para o Centro 4

# Restrição de transporte
s.t. Transporte:
    (0.9 * 0.95 * 0.85 * 0.8 * x_N[1] + 0.9 * 0.95 * 0.85 * 0.75 * x_A[1] + 0.9 * 0.85 * 0.80 * x[2]) <= Capacidade_transporte;  # Capacidade máxima de transporte diária

# Restrições de venda
s.t. Venda1:
    (0.9 * 0.95 * 0.85 * 0.8 * x_N[1] + 0.9 * 0.95 * 0.85 * 0.75 * x_A[1]) <= Venda_diaria_maxima[1];  # Quantidade máxima de venda diária do óleo tipo I
s.t. Venda2:
    (0.9 * 0.85 * 0.80 * x[2]) <= Venda_diaria_maxima[2];  # Quantidade máxima de venda diária do óleo tipo II

# Restrições de não negatividade
s.t. NaoNegatividade1:
    x[1] >= 0;  # Garantia de que a variável x[1] não seja negativa
s.t. NaoNegatividade2:
    x_N[1] >= 0;  # Garantia de que a variável x_N[1] não seja negativa
s.t. NaoNegatividade3:
    x_A[1] >= 0;  # Garantia de que a variável x_A[1] não seja negativa

# Resolver o modelo
solve;

# Exibir resultado
display x, x_N, x_A, Lucro;  # Exibe as variáveis de decisão e o lucro

end;
