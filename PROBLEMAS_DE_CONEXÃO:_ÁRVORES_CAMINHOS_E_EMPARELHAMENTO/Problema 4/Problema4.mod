# Definições de parâmetros e conjuntos
param n, integer;        # Número de nós
param s, integer;        # Nó de origem
param t, integer;        # Nó de destino
set V := 1..n;           # Conjunto de nós
set E, within V cross V; # Conjunto de arestas
param capacity{(i,j) in E}; # Capacidade das arestas
param cost{(i,j) in E};  # Custo das arestas

# Variáveis
var x{(i,j) in E} >= 0, <= capacity[i,j]; # Variáveis de fluxo nas arestas

# Função objetivo: minimizar o custo total do caminho de s a t
minimize total_cost: sum{(i,j) in E} cost[i,j] * x[i,j];

# Restrições de capacidade e conservação de fluxo
s.t. capacity_constraints {(i,j) in E}: x[i,j] <= capacity[i,j];
s.t. flow_conservation {v in V diff {s,t}}:
    sum{(i,v) in E} x[i,v] - sum{(v,j) in E} x[v,j] = 0;

# Restrição de fluxo para garantir que o fluxo de s a t é 1
s.t. source_constraint:
    sum{(i,s) in E} x[i,s] - sum{(s,j) in E} x[s,j] = -1;

s.t. sink_constraint:
    sum{(i,t) in E} x[i,t] - sum{(t,j) in E} x[t,j] = 1;

solve;

# Exibir o fluxo e o custo total
display x, total_cost;
