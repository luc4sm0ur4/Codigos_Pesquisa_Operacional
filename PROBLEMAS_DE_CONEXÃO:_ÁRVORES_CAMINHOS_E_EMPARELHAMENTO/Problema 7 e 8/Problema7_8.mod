# Definições de parâmetros e conjuntos
param n, integer;           # Número de nós
param m, integer;           # Número de arestas
set V := 1..n;              # Conjunto de nós
set E, within V cross V;    # Conjunto de arestas
param d{(i,j) in E};        # Distância entre nós i e j
param t{V};                 # Tempo de serviço em cada nó

# Variáveis
var x{(i,j) in E}, binary;  # 1 se a aresta (i,j) está no caminho, 0 caso contrário
var T;                      # Tempo total de conclusão

# Função objetivo: minimizar o tempo total de conclusão
minimize total_time: T;

# Restrições para garantir que cada nó seja visitado uma vez
s.t. visit_each_node {i in V}:
    sum{(i,j) in E} x[i,j] = 1;

# Restrições para garantir a conectividade e tempo total de conclusão
s.t. completion {i in V}:
    T >= t[i] + sum{(i,j) in E} d[i,j] * x[i,j];

solve;

# Exibir as arestas selecionadas e o tempo total de conclusão
display x, T;

end;
