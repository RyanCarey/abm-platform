
type Point
	x::Real
	y::Real
	Point(x, y) = new(x, y)
end

function getindex(a::Point,b::Int64)
  b==1 ? a.x : (b==2 ? a.y : BoundsError)
end

# Properties of each individual cell.
type Cell
	name::String
  	x::Real
  	y::Real
	r::Real
	angle::Real
	speed::Real
	offspring::Int
	cell_type::Int  # this is an index in the range 1 to 4, which indexes the 'categories' array of cell types
end

# Properties that define each cell category.
type Cell_type
	amount::Real
	growth_rate::Real
	div_thres::Real
	avg_speed::Real
	avg_r::Real
	conc_response::Real  	
 	conc_threshold::Real
 	death_rate::Real
 	persistence::Real
 	randomness::Real
	threshold_movement::Real
	threshold_ratio_concentration::Real
	colour::String
	left_placed::Bool
	stem_cell::Bool
	sticking::Bool
end
