include("init.jl")
include("show_cells.jl")
using Init,Show_cells

x = y = 10
r = 1.0

A = init(10,x,y,r)
show_cells(A,x,y,r)
