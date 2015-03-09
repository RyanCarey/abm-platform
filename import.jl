using Winston
using Tk
println("Loading...")
include("cell_type.jl")
include("birth_and_death.jl")
include("move.jl")
include("ellipse.jl")
include("angle.jl")
include("borders.jl")
include("init.jl")
include("show.jl")
include("pause.jl")
include("diffusion.jl")
include("cell_growth.jl")
#include("pickle.jl")
include("simulator.jl")
include("gui_diffusion.jl")
include("gui_type.jl")
include("gui_border.jl")
include("gui_ligand.jl")
#using PyCall
#@pyimport pickle
