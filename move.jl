# Module containing functions pertaining to cell movement.
include("angle.jl")
include("new_border.jl")
include("cell_type.jl")
using Distributions

function move_any!(wall_behaviour,fc_behaviour,walls,fc)
 	m = rand(1:length(alive_cells))	

	startloc = Point(alive_cells[m].x, alive_cells[m].y)

	alive_cells[m].speed = -2*log(rand()) * categories[alive_cells[m].cell_type].avg_speed / 5
	alive_cells[m].angle = angle_from_both(alive_cells[m])
	alive_cells[m].x += alive_cells[m].speed * cos(alive_cells[m].angle)
	alive_cells[m].y += alive_cells[m].speed * sin(alive_cells[m].angle)

	check_borders!(alive_cells[m],startloc,wall_behaviour,fc_behaviour,walls,fc)
  println("cell loc in move function: ", alive_cells[m].x,", ",alive_cells[m].y)
	solve_overlap(m,startloc,walls,fc)	

end
##########################################################################################################
function solve_overlap(m::Int, startloc::Point,walls,fc)
	#Parameters
	minimum_ratio=0.01 # threshold to trigger cells to move
	g = 0.9 #loss of energy while giving energy to the first cell to the other one
	
	k=m
	k = is_overlap(m::Int, startloc::Point,k)	
	if(k!=m)
	  d=sqrt((startloc.x - alive_cells[m].x)^2 + (startloc.y - alive_cells[m].y)^2)
	  remaining_distance = alive_cells[m].speed - d

	  if(remaining_distance / categories[alive_cells[m].cell_type].avg_speed > minimum_ratio) #We can now make the cells to move
		alpha = alive_cells[m].angle
		
		xm=alive_cells[m].x
		xk=alive_cells[k].x
		ym=alive_cells[m].y
		yk=alive_cells[k].y

		alive_cells[k].angle=acos((xk-xm)/sqrt((xk-xm)^2+(yk-ym)^2))*sign(yk-ym)
		a=sign(-sin(alive_cells[k].angle)*cos(alive_cells[m].angle)+cos(alive_cells[k].angle)*sin(alive_cells[m].angle))
		if(a>0)
		  alive_cells[m].angle=acos(-sin(alive_cells[k].angle))*sign(cos(alive_cells[k].angle))
		else
		  alive_cells[m].angle=acos(-sin(alive_cells[k].angle))*sign(cos(alive_cells[k].angle))+pi
		end
		
		beta = abs(alpha - alive_cells[k].angle)

		alive_cells[m].speed=remaining_distance*g*(beta/(pi/2))
		alive_cells[k].speed=remaining_distance*g*(1-beta/(pi/2))

		startlock=Point(xk,yk)
		startlocm=Point(xm,ym)
		alive_cells[m].x+=alive_cells[m].speed*cos(alive_cells[m].angle)
		alive_cells[k].x+=alive_cells[k].speed*cos(alive_cells[k].angle)
		alive_cells[m].y+=alive_cells[m].speed*sin(alive_cells[m].angle)
		alive_cells[k].y+=alive_cells[k].speed*sin(alive_cells[k].angle)
		check_borders!(alive_cells[m],startlocm,wall_behaviour,fc_behaviour,walls,fc)
		check_borders!(alive_cells[k],startlock,wall_behaviour,fc_behaviour,walls,fc)
		solve_overlap(k, startlock,walls,fc)
		solve_overlap(m, startlocm,walls,fc)
	  else
		
	  end
	end
end
########
#function move_cell_x!(alive_cells::Array, dead_cells::Array, m::Int, max_speed::Float64)
#  num_cells = length(alive_cells)
#  # takes cell list and (attempts to) move specified cell
#	startloc = Point(alive_cells[m].x, alive_cells[m].y)
#	alive_cells[m] = propose_move_x(alive_cells[m], max_speed)
#	cell_died = check_borders!(alive_cells,dead_cells,m,startloc)
#  if !cell_died
#    if is_overlap(alive_cells, m)
#      alive_cells[m] = Point(startloc.x,startloc.y)
#      alive_cells[m].angle = 0.
#     alive_cells[m].speed = 0.
#      #move_cell_x!(alive_cells,dead_cells,m,max_speed) # include this to retry moving cell
#    end
#  end
#  return cell_died
##### 284575dcab57ce2c88e33e39c199e21990ce2d58
#end

##########################################################################################################
function is_overlap( m::Int, startloc::Point,k::Int)
#k is used if we want to exclude also another cell than the studied cell (m)  

  index=[]
  distance=[]
  for i in 1:length(alive_cells)
    if (alive_cells[i].x - alive_cells[m].x)^2 + (alive_cells[i].y - alive_cells[m].y)^2< (alive_cells[i].r + alive_cells[m].r) ^ 2
	  if  (i != m && i!=k)
		index=[index,i]
	  end
    end
  end
  if(length(index)>0)
  	for j in 1:length(index)
	  d=sqrt((startloc.x - alive_cells[index[j]].x)^2 + (startloc.y - alive_cells[index[j]].y)^2)
	  distance=[distance,d]
  	end
	k=index[indmin(distance)]
	alive_cells[m].x,alive_cells[m].y = find_center_where_they_touch(alive_cells[m],alive_cells[k],startloc)		  
	is_overlap(m, startloc,k)
  end
  return k
end

##########################################################################################################
function find_center_where_they_touch(cellm,cellk,startloc)
	theta = cellm.angle
	x1 = startloc.x
	y1 = startloc.y
	x2 = cellk.x
	y2 = cellk.y
	r1 = cellm.r
	r2 = cellk.r
	println("x1: ",x1, ", y1: ",y1,"   r1: ",r1) 
	println("x2: ",x2, ", y2: ",y2,"   r2: ",r2)
	#Solving of an equation to know where the moving cell touch the overlapped cell first
	a = 1
	b = 2*(cos(theta)*(x1-x2) + sin(theta)*(y1-y2))
	c = (x1-x2)^2 + (y1-y2)^2 - (r1+r2)^2 
	delta = b^2 - 4*a*c

	d =(-b - sqrt(delta))/2
  
	#We can now place the cell at the border of the touching cell
	x1 = x1 + d*cos(theta)
	y1 = y1 + d*sin(theta)
	println("New x1: ",x1, ", New y1: ",y1)
	return x1,y1
end
##########################################################################################################
function is_overlap_divide(cells::Array, point::Point, radius::Real)
	n = length(cells)
		for i in 1:n
			if (cells[i].x - point.x) ^ 2 + (cells[i].y - point.y) ^ 2 < (cells[i].r + radius) ^ 2
			    return true
			end
		end
	return false
end

#=function is_overlap(cells::Array, index::Int, point::Point, radius::Real)
  n = length(cells)
    for i in 1:n
      if (cells[i].x - point.x) ^ 2 + (cells[i].y - point.y) ^ 2 < (cells[i].r + radius) ^ 2 && i != index
        return true
      end
    end
  return false
end
=#


