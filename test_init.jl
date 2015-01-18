include("init.jl")
include("show_cells.jl")
include("optional_arg.jl")
using Distributions 

n = int(optional_arg(1,"how many cells?"))
r = float(optional_arg(2,"what average radius?"))
x = float(optional_arg(3,"what map width?"))
y = x

println("building map")

A = init(n,x,y,r)
show_cells(A,r,x,y)
junk = readline(STDIN)
