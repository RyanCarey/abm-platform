include("move.jl")
include("angle.jl")



a = 10*rand(10,2)
b = rand(10,1)
X = [a b]
is_overlap(X, 1,1.0)
