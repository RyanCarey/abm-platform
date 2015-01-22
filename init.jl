
# Initialization Function
# 1st parameter: Number of cells
# 2nd parameter: Height of environment
# 3rd parameter: Width of environment
# 4th parameter: Radius of the cell
#
# This function return a 2D cells of random located cells within the square's borders. The cells have a radius and they do not overlap.
# We initilaize the first location of the cell and then for each new potential cell we look within the cells whether the cell is
# overlapping with another cell. If yes, we choose another random location for the cell

function init(n, x, y, r)
cells = Cell[]

rvar = 0.1 # Radius Variation
#cells[1,3]= rand_radius(r,r*rvar)
#cells[1,1]= cells[1,3] + (x- 2 * cells[1,3]) * rand()
#cells[1,2]= cells[1,3] + (y- 2 * cells[1,3]) * rand()
	if(n >= 1)
		for i in 1:n
			placed = false
			fails = 0
			ri = rand_radius(r, r * rvar)
			while !placed
				xi = ri + (x - 2 * ri) * rand()
				yi = ri + (y - 2 * ri) * rand()
				overlap = false
					for j in 1:i-1
						if((xi - cells[j].loc.x) ^ 2 + (yi - cells[j].loc.y) ^ 2 < (ri + cells[j].r) ^ 2)
							overlap = true
						end
					end
					if overlap
						fails += 1
						if fails > 10000
						println("")
						error("could not place cell, try smaller radius or larger map")
						end
					else
					cells[i].loc.x = xi
					cells[i].loc.y = yi
					cells[i].r = ri
					placed = true
					end
			end
		end
	end
	return cells
end

function rand_radius(mean, stdev)
	radius = mean + (stdev * randn())
	# while radius is negative, try again
	while radius <= 0
		radius = rand_radius(mean, stdev)
	end
	return radius
end





#println(init(50,10,10,0.1))


