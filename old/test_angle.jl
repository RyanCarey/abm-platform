include("angle.jl")
include("init.jl")
include("cell_type.jl")
include("diffusion.jl")

X_SIZE = Y_SIZE = 10
conc_map = init_diffusion(10,10)
cells = init(10,1)

angleBRW(conc_map,cells[1],36)




