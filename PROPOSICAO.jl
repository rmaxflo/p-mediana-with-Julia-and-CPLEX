# import Pkg
# Pkg.add("CPLEX")

using JuMP, CPLEX
include("dados.jl")
# println(teste)

n = length(d)
m = length(d)
p = 5

modelo = Model(CPLEX.Optimizer)

# Variáveis
@variables modelo begin
    X[i in 1:n,j in 1:m] >=0
    Y[i in 1:n,j in 1:m], Bin
end
#função objetivo
@objective(modelo, Min, sum(X[i,j] * Y[i,j] for i in 1:n for j in 1:m))

# restrições --> Sujeito a:
@constraints modelo begin
    conj1[j in 1:m], sum(X[i,j] for i in 1:n) == i
    conj2[i in 1:m], sum(X[i,j] for i in 1:n) == 1
    conj3[i in 1:m], sum(X[i,j] for i in 1:n) == 1
end

# Rodando o solução
optimize!(modelo)
has_values(modelo)
termination_status(modelo)
