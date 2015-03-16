println("Loading...")

using Tk
#using PyCall
#@pyimport pickle
include("cell_type.jl")
include("birth_and_death.jl")
include("move.jl")
#include("ellipse.jl")
include("angle.jl")
#include("borders.jl")
include("initial_placement.jl")
include("diffusion.jl")
#include("cell_growth.jl")
#include("pickle.jl")
include("simulator.jl")

println("Loaded")