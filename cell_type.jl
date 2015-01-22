type Point
	x::Real
	y::Real
	Point(x, y) = new(x, y)
end

type Cell
	loc::Point
	r::Real
	angle::Real
	speed::Real
end
