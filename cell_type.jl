type Point
	x::Real
	y::Real
	Point(x, y) = new(x, y)
end

function getindex(a::Point,b::Int64)
  b==1 ? a.x : (b==2 ? a.y : BoundsError)
end

type Cell
	loc::Point
	r::Real
	angle::Real
	speed::Real
end
