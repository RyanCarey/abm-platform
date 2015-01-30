include("move.jl")

#used for figuring out whether mutator is faster
# and for timing move_cell_x

a = rand(5,5)
for i in 1:3
  move_cell_x!(a,2,1.)
  println(a)
end
