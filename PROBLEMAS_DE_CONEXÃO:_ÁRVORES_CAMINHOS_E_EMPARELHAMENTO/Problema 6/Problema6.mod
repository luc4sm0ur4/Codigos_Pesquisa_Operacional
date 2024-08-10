# Definições de parâmetros e conjuntos
param n, integer;           # Número de nós
param m, integer;           # Número de arestas
set V := 1..n;              # Conjunto de nós
set E, within V cross V;    # Conjunto de arestas
param cost{(i,j) in E};     # Custo das arestas

# Variáveis
var x{(i,j) in E}, binary;  # 1 se a aresta está na árvore, 0 caso contrário
var u{V}, integer;          # Variável auxiliar para eliminar ciclos

# Função objetivo: minimizar o custo total das arestas na árvore
minimize total_cost: sum{(i,j) in E} cost[i,j] * x[i,j];

# Restrições de grau
s.t. degree {i in V}: sum{(i,j) in E} x[i,j] + sum{(j,i) in E} x[j,i] <= 1;

# Restrições de conectividade para eliminar ciclos
s.t. cycle_elimination {i in V, j in V: i <> j and (i,j) in E}:
    u[i] - u[j] + n * x[i,j] <= n - 1;

solve;

# Exibir as arestas selecionadas na árvore geradora mínima
display x;
