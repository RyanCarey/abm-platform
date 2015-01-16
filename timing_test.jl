include("propose_move.jl")
using Propose_move

#used for figuring out whether mutator is faster
# and for timing move_cell_x

a = rand(10,2)
#@time propose_move_all(a,1.0)
for i in 1:50
  #@time is_overlap(a, 20, 1.0)
  #@time move_cell_x!(a, 20, 1.0,1.0)
end
for i in 1:10
print(a)
b = is_overlap(a,1,1.0)
#b = move_any(a,1.0,1.0)
print(b)
end
