# Added a name and state component to the Cell type.
# Name is initialised as the index number of the cell whilst state is either "Alive" or "Dead"

type Point
	x::Real
	y::Real
	Point(x, y) = new(x, y)
end

function getindex(a::Point,b::Int64)
  b==1 ? a.x : (b==2 ? a.y : BoundsError)
end

type Cell
	name::String
	loc::Point
	r::Real
	angle::Real
	speed::Real
	state::String
	offspring::Int
	category::String
end
