include("move.jl")
using Move

#used for figuring out whether mutator is faster
# and for timing move_cell_x

a = rand(10,2)
#@time propose_move_all(a,1.0)
for i in 1:50
  #@time is_overlap(a, 20, 1.0)
  @time move_any!(a, 1.0,1.0)
end
