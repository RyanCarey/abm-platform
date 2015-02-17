using Tk
using Winston
include("init.jl")

X_SIZE = 10
Y_SIZE = 12
BORDER_SHAPE = "Rectangle"

global categories = [Cell_type(0.5,.001,.1,1,1,1,"r",true,true),
                     Cell_type(0.5,.001,.1,1,1,1,"r",true,true),
                     Cell_type(0.5,.001,.1,1,1,1,"r",true,true),
                     Cell_type(0.5,.001,.1,1,1,1,"r",true,true)]

alive_cells = init(10,1,categories)

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
