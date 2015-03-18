println("Loading...")

using Tk
using PyCall
@pyimport pickle
include("cell_type.jl")
include("birth_and_death.jl")
include("move.jl")
include("angle.jl")
include("initial_placement.jl")
include("diffusion.jl")
include("pickle.jl")
include("simulator.jl")

println("Loaded")
