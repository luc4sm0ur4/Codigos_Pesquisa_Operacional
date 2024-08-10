# Definições de parâmetros e conjuntos
param n, integer;       # Número de nós
param s, integer;       # Nó de origem
param t, integer;       # Nó de destino
set E, dimen 2;         # Conjunto de arestas (i, j)
param c{(i,j) in E};    # Custo das arestas

# Variáveis
var x{(i,j) in E}, binary;  # 1 se a aresta está na solução, 0 caso contrário

# Função objetivo: minimizar o custo total do caminho
minimize total_cost: sum{(i,j) in E} c[i,j] * x[i,j];

# Restrições de fluxo
s.t. fluxo_origem {i in 1..n: i == s}:
    sum{(i,j) in E} x[i,j] - sum{(j,i) in E} x[j,i] = 1;

s.t. fluxo_destino {i in 1..n: i == t}:
    sum{(i,j) in E} x[i,j] - sum{(j,i) in E} x[j,i] = -1;

s.t. fluxo_intermediario {i in 1..n: i <> s and i <> t}:
    sum{(i,j) in E} x[i,j] - sum{(j,i) in E} x[j,i] = 0;

solve;

# Exibir as arestas selecionadas no caminho mais curto
display x;
