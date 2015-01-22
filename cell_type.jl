type Cell
	name::String
	loc::Point
	radius::Real
	angle::Real
	speed::Real
 
	#Cell(loc, radius, angle, speed) = new(loc, radius, angle, speed)    	
	#Cell(name, loc, radius, angle, speed) = new(name, loc, radius, angle, speed)

	function getAngle()
		println("Angle: ", angle)
	end
	this.method = getAngle()
end
