# Definições de parâmetros e conjuntos
param n, integer;              # Número de nós
set V := 1..n;                 # Conjunto de nós
set E, within {V, V};          # Conjunto de arestas (i, j)

param c{(i,j) in E};           # Custo das arestas
var x{(i,j) in E}, binary;     # 1 se a aresta está na árvore, 0 caso contrário

# Função objetivo: minimizar o custo total
minimize total_cost: sum{(i,j) in E} c[i,j] * x[i,j];

# Prevenção de ciclos (formulação de Miller-Tucker-Zemlin)
var u{V} >= 1, <= n;           # Variável auxiliar para prevenção de ciclos

# Restrições de conectividade e prevenção de ciclos
s.t. degree {i in V}:
    sum{(i,j) in E} x[i,j] + sum{(j,i) in E} x[j,i] = 1;

s.t. mccormick {i in V, j in V: i != j and (i,j) in E}:
    u[i] - u[j] + n * x[i,j] <= n - 1;

# Uma aresta para cada nó, exceto a raiz
s.t. root {i in 2..n}:
    u[i] >= 2;

solve;

# Exibir as arestas selecionadas na árvore geradora mínima
display x;

end;
