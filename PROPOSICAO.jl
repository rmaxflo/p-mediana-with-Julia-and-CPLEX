import Pkg
Pkg.add("CPLEX")

using JuMP, CPLEX
# include("dados2.jl")

# dados da intância do problema a ser solucionado.
include("dados.dat")

n = 20
m = 20

# número de mediana
p = 5 # 4 = 4525 / 5 = 4242

#criando modelo CPLEX
modelo = Model(CPLEX.Optimizer)

# Variáveis do melode matemática
@variables modelo begin
    X[i in 1:n, j in 1:m], Bin
    # Y[i in 1:n, j in 1:m], Bin
end

#função objetivo
@objective(modelo, Min, sum(X[i,j] * d[i,j] for i in 1:n for j in 1:n))

# restrições --> Sujeito a:
@constraints modelo begin
    conj1[j in 1:n], sum(X[j,j]  for j in 1:n) == p
    conj2[i in 1:n,j in 1:m], X[i,j] <= X[j, j]
    conj3[i in 1:n], sum(X[i,j] for j in 1:n) == 1
end

# Rodando o solução
optimize!(modelo)
has_values(modelo)
relative_gap(modelo)
termination_status(modelo)


#Resolução de p-median com julia e CPLEX
#Trabalho proposto na disciplina de Metaheurística e Otimização combinatória.
#Curso: Pós-graduação em Ciencia da Computação 2020.2 - UFERSA
#Discente: Robson Pires Borges
#Agredecimentos: Ramon Bessa
