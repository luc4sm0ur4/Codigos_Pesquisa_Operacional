# Definições de parâmetros e conjuntos
param n, integer;       # Número de nós (pontos de recarga)
param k, integer;       # Número de carros
set N, default {1..n};  # Conjunto de nós
set K, default {1..k};  # Conjunto de carros
set E, within N cross N; # Conjunto de arestas (i, j)
param c{(i,j) in E};    # Custo das arestas

# Variáveis
var x{(i,j) in E, car in K}, binary;  # 1 se a aresta está no caminho do carro, 0 caso contrário
var u{N}, integer;  # Variável auxiliar para eliminar ciclos

# Função objetivo: minimizar o custo total dos caminhos dos carros
minimize total_cost: sum{(i,j) in E, car in K} c[i,j] * x[i,j,car];

# Restrições de fluxo
s.t. fluxo_origem {car in K, i in N: i == 1}:
    sum{(i,j) in E} x[i,j,car] - sum{(j,i) in E} x[j,i,car] = 1;

s.t. fluxo_destino {car in K, i in N: i == n}:
    sum{(i,j) in E} x[i,j,car] - sum{(j,i) in E} x[j,i,car] = -1;

s.t. fluxo_intermediario {car in K, i in N: i <> 1 and i <> n}:
    sum{(i,j) in E} x[i,j,car] - sum{(j,i) in E} x[j,i,car] = 0;

# Restrições para garantir que não há ciclos
s.t. cycle_elimination {i in N, j in N: i <> j and (i,j) in E}:
    u[i] - u[j] + n * sum{car in K} x[i,j,car] <= n-1;

solve;

# Exibir as arestas selecionadas nos caminhos dos carros
display x;
