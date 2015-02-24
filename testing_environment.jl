using Tk
using Winston
include("init.jl")
include("cell_type.jl")

X_SIZE = 10
Y_SIZE = 12
BORDER_SHAPE = "Rectangle"

global categories = [Cell_type(0.5,.001,.1,1,1,1,.5,"r",true,true),
                     Cell_type(0.5,.001,.1,1,1,1,.5,"r",true,true),
                     Cell_type(0.0,.001,.1,1,1,1,.5,"r",true,true),
                     Cell_type(0.0,.001,.1,1,1,1,.5,"r",true,true)]

global border_settings = ["r","r","r","r"]

alive_cells = init(2,categories)

#=
type Cell_type
	amount::Real	
	growth_rate::Real
	div_thres::Real
	avg_speed::Real
	avg_r::Real
	conc_response::Real
	colour::String
	left_placed::Bool
	stem_cell::Bool	
  =#
