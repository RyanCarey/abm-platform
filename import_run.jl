println("Loading...")

using PyCall
using Tk
@pyimport pickle
include("cell_type.jl")
include("birth_and_death.jl")
include("move.jl")
include("angle.jl")
include("initial_placement.jl")
include("diffusion.jl")
include("unpickle.jl")
include("simulator.jl")

println("Loaded")
