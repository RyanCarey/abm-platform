include("angle.jl")
include("await_user.jl")
using Winston
cell = [5.,3.,2.,pi,1.]
conc = repmat([1:20]',20,1)

a = round(edges(cell,36))
println(a)
println(conc)
for i in 1:size(a,1)
  println(conc[a[i,1]+1,a[i,2]]+1)
end

#x = a[:,1]
#y = a[:,2]
#p = plot(x,y)
#display(p)
#await_user(0)
