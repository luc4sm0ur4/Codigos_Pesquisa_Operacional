# Definições de parâmetros e conjuntos
param n, integer;           # Número de nós
set V := 1..n;              # Conjunto de nós
set E, within V cross V;    # Conjunto de arestas

# Variáveis
var x{(i,j) in E}, binary;  # 1 se a aresta (i,j) está no emparelhamento, 0 caso contrário

# Função objetivo: maximizar o número de arestas no emparelhamento
maximize total_matching: sum{(i,j) in E} x[i,j];

# Restrição para garantir que cada nó está em no máximo uma aresta do emparelhamento
s.t. node_constraints {v in V}:
    sum{(i,v) in E} x[i,v] + sum{(v,j) in E} x[v,j] <= 1;

solve;

# Exibir as arestas selecionadas no emparelhamento
display x;
