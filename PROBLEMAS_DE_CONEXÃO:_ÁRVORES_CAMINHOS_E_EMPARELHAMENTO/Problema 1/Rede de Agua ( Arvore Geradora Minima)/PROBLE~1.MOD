param n, integer;        # Número de nós
set E, dimen 2;          # Conjunto de arestas (i, j)
param c{(i,j) in E};     # Custo das arestas

var x{(i,j) in E}, binary;  # 1 se a aresta está na árvore, 0 caso contrário
var u{1..n}, integer;       # Variável auxiliar para eliminar ciclos

# Função objetivo: minimizar o custo total
minimize total_cost: sum{(i,j) in E} c[i,j] * x[i,j];

# Restrições para garantir que não há ciclos
s.t. cycle_elimination {i in 2..n, j in 1..i-1: (i,j) in E}: u[i] - u[j] + n * x[i,j] <= n-1;
s.t. degree {i in 1..n}: sum{(i,j) in E} x[i,j] + sum{(j,i) in E} x[j,i] = 1;

solve;

# Exibir as arestas selecionadas na árvore geradora mínima
display x;
