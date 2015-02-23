# Module containing functions pertaining to cell movement.
include("angle.jl")
include("new_border.jl")
include("cell_type.jl")
using Distributions

function move_any!()
 	m = rand(1:length(alive_cells))	

	startloc = Point(alive_cells[m].x, alive_cells[m].y)

	alive_cells[m].speed = -2*log(rand()) * categories[alive_cells[m].cell_type].avg_speed / 5
	alive_cells[m].angle = angle_from_both(alive_cells[m])
	alive_cells[m].x += alive_cells[m].speed * cos(alive_cells[m].angle)
	alive_cells[m].y += alive_cells[m].speed * sin(alive_cells[m].angle)
	println("alive_cells[m].angle: ",alive_cells[m].angle)
	println("alive_cells[m].x: ",alive_cells[m].x)
	println("alive_cells[m].y: ",alive_cells[m].y)
	println("alive_cells[m].r: ",alive_cells[m].r)
	println("startloc: ",startloc)
	solve_overlap(m,startloc)	

end
##########################################################################################################
function solve_overlap(m::Int, startloc::Point)
	#Parameters
	minimum_ratio=0.05 # threshold to trigger cells to move
	g = 0.8 #loss of energy while giving energy to the first cell to the other one
	global counter_overlap = 0
	println("")
	println("solve_overlap")
	println("number of cell: ",m)

	if(alive_cells[m].x>X_SIZE-alive_cells[m].r || alive_cells[m].y>Y_SIZE-alive_cells[m].r || alive_cells[m].x<0+alive_cells[m].r || alive_cells[m].y<0+alive_cells[m].r)
		println("going towards the walls")
		k=check_any_cell_between(startloc,m)
		if(k!=m)
			println("cell between")
			alive_cells[m].x,alive_cells[m].y,d_move=find_center_where_they_touch(alive_cells[m],alive_cells[k],startloc)
			println("move the cell to the cell between the wall and itself")
			x1 = startloc.x
			y1 = startloc.y
			xm=alive_cells[m].x
			xk=alive_cells[k].x
			ym=alive_cells[m].y
			yk=alive_cells[k].y
			println("x1: ",x1, ", y1: ",y1) 
			println("x$m: ",xm, ", y$m: ",ym)
			println("x$k: ",xk, ", y$k: ",yk) 
		else
			#check_borders!(alive_cells[m],startloc,wall_behaviour,fc_behaviour,walls,fc)
			println("no cell between")
			startloc=put_at_the_border(m,startloc)
			#alive_cells[m].angle=acos((alive_cells[m].x-startloc.x)/sqrt((alive_cells[m].x-startloc.x)^2+(alive_cells[m].y-startloc.y)^2))*sign(alive_cells[m].y-startloc.y)
			println("move the cell to the wall")
			x1 = startloc.x
			y1 = startloc.y
			xm=alive_cells[m].x
			ym=alive_cells[m].y
			println("x1: ",x1, ", y1: ",y1) 
			println("x$m: ",xm, ", y$m: ",ym)
			println("angle: ",alive_cells[m].angle)
			println("remaining distance: ", alive_cells[m].speed)
			#quit()
			#The cell need to have its startloc at the border with a new speed and a new location.
			solve_overlap(m,startloc)
			k=m
		end
	else
		println("not going toward the wall")
		k,d_move = is_overlap(m, startloc,m)	
	end

	if(k!=m)
	  d=sqrt((startloc.x - alive_cells[m].x)^2 + (startloc.y - alive_cells[m].y)^2)
	  remaining_distance = alive_cells[m].speed - d

	  if(remaining_distance / categories[alive_cells[m].cell_type].avg_speed > minimum_ratio) #We can now make the cells to move
		x1 = startloc.x
		y1 = startloc.y
		xm=alive_cells[m].x
		xk=alive_cells[k].x
		ym=alive_cells[m].y
		yk=alive_cells[k].y

		println("")
		println("Bouncing: different locations: ")
		println("x1: ",x1, ", y1: ",y1) 
		println("xm: ",xm, ", ym: ",ym)
		println("xk: ",xk, ", yk: ",yk) 

		if(yk!=ym)
			alive_cells[k].angle=mod(acos((xk-xm)/sqrt((xk-xm)^2+(yk-ym)^2))*sign(yk-ym),2*pi)
			elseif(xk>xm)
				alive_cells[k].angle=0
			else
				alive_cells[k].angle=pi
		end

		if(d_move>0)
			println("d move >0")
			alpha = mod(acos((xm - x1)/sqrt((xm - x1)^2+(ym - y1)^2))*sign(ym - y1),2*pi)
			if(-0.001<alpha<0.001 || pi*0.999<alpha<pi*1.001)
	 	 	  if(xm - x1<0)
				alpha=pi
		 	  else
				alpha=0
			   end
			end

		#else
			#println("d move <0")
			#alpha = mod(acos((xm - x1)/sqrt((xm - x1)^2+(ym - y1)^2))*sign(ym - y1)+pi,2*pi)
			#if(-0.001<alpha<0.001 || pi*0.999<alpha<pi*1.001)
	 	 	  #if(xm - x1<0)
				#alpha=pi
		 	  #else
				#alpha=0
			  # end
			#end
		#end

		if(abs(alive_cells[k].angle-alpha+pi/2)<pi/2)
			alive_cells[m].angle=alive_cells[k].angle+pi/2
		else
			alive_cells[m].angle=alive_cells[k].angle-pi/2
		end
		
		beta = abs(alpha - alive_cells[k].angle)/(pi/2)
		println("alphak: ", alive_cells[k].angle, " - alpham: ", alive_cells[m].angle, " - alpha: ", alpha)
		println("beta: ", beta)

		
		alive_cells[m].speed=remaining_distance*g*beta
		alive_cells[k].speed=remaining_distance*g*(1-beta)
		println("speed : m :",alive_cells[m].speed," - k :", alive_cells[k].speed)
		startlock=Point(xk,yk)
		startlocm=Point(xm,ym)
		#println("startlock: ",startlock," - startlocm: ", startlocm)

		alive_cells[k].x+=alive_cells[k].speed*cos(alive_cells[k].angle)
		alive_cells[k].y+=alive_cells[k].speed*sin(alive_cells[k].angle)

		println("before checkborder for k:")
		println("x: ", alive_cells[k].x, " y: ",alive_cells[k].y)
		#check_borders!(alive_cells[k],startlock,wall_behaviour,fc_behaviour,walls,fc)
		#println("after checkborederd for k:")
		#println("x: ", alive_cells[k].x, " y: ",alive_cells[k].y)
		println("Overlap k? ", is_overlap2(k))
		#is_overlap(k,startlock,walls,fc)

		alive_cells[m].x+=alive_cells[m].speed*cos(alive_cells[m].angle)
		alive_cells[m].y+=alive_cells[m].speed*sin(alive_cells[m].angle)


		println("before checkborder for m:")
		println("x: ", alive_cells[m].x, " y: ",alive_cells[m].y)
		#check_borders!(alive_cells[m],startlocm,wall_behaviour,fc_behaviour,walls,fc)
		#println("after checkborederd for m:")
		#println("x: ", alive_cells[m].x, " y: ",alive_cells[m].y)
		println("Overlap m? ", is_overlap2(m))
		#println("")
		println("")
		#is_overlap(m,startlocm,walls,fc)
		solve_overlap(k,startlock)	
		solve_overlap(m, startlocm)

		#if d_move <0
		else
		alive_cells[m].speed=0
		alive_cells[k].speed=0
		end
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
function is_overlap( m::Int, startloc::Point,k)
#k is used if we want to exclude also another cell than the studied cell (m)  
  println("Looking for overlap")
  global counter_overlap += 1
  index=[]
  distance=[]
  d=0
  for i in 1:length(alive_cells)

    if (alive_cells[i].x - alive_cells[m].x)^2 + (alive_cells[i].y - alive_cells[m].y)^2< ((alive_cells[i].r + alive_cells[m].r)) ^ 2
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
	d=minimum(distance)
	println("indeed overlap so find center where they touch")
			x1 = startloc.x
			y1 = startloc.y
			xm=alive_cells[m].x
			xk=alive_cells[k].x
			ym=alive_cells[m].y
			yk=alive_cells[k].y
			println("x1: ",x1, ", y1: ",y1) 
			println("xm: ",xm, ", ym: ",ym)
			println("xk: ",xk, ", yk: ",yk) 
	alive_cells[m].x,alive_cells[m].y,d = find_center_where_they_touch(alive_cells[m],alive_cells[k],startloc)
	if(counter_overlap<10)		  
	  is_overlap(m, startloc,k)
	end
  else
	println("no overlap at is_overlap")
  end
  return k,d
end

##########################################################################################################
function find_center_where_they_touch(cellm,cellk,startloc)
	x1 = startloc.x
	y1 = startloc.y
	x2 = cellk.x
	y2 = cellk.y
	r1 = cellm.r
	r2 = cellk.r
	theta=cellm.angle
	theta1 = acos((cellm.x - x1)/sqrt((cellm.x - x1)^2+(cellm.y - y1)^2))*sign(cellm.y - y1)

	println("Find Center Where they Touch")
	println("angle cellm1 (theta): ", theta)	
	println("angle cellm1 (theta1): ", theta1)
	if(-0.001<theta1<0.001 || pi*0.999<theta1<pi*1.001)
	  if(cellm.x - x1<0)
		theta1=pi
	  else
		theta1=0
	  end
	end

	#if(!(mod(theta1,2*pi) - 0.001<mod(theta,2*pi)<mod(theta1,2*pi) +0.001))
	 # println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	  #println(theta,"  theta!=theta1  ",theta1)
	  #println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	#end

	println("x1: ",x1, ", y1: ",y1,"   r1: ",r1) 
	println("x2: ",x2, ", y2: ",y2,"   r2: ",r2)

	#Solving of an equation to know where the moving cell touch the overlapped cell first
	a = 1
	b = 2*(cos(theta1)*(x1-x2) + sin(theta1)*(y1-y2))
	c = (x1-x2)^2 + (y1-y2)^2 - (r1+r2)^2 
	delta = b^2 - 4*a*c
	println("with minus: ",(-b - sqrt(delta))/2)
	println("with plus: ",(-b + sqrt(delta))/2)
	
	d =min(((-b - sqrt(delta))/2),((-b + sqrt(delta))/2))
  	if(d<-1.2)
		global negative_distance+=1
		#quit()
	end
	#We can now place the cell at the border of the touching cell
	x1 = x1 + d*cos(theta1)
	y1 = y1 + d*sin(theta1)
	println("New x1: ",x1, ", New y1: ",y1)
		println("")

	return x1,y1,d

end
##########################################################################################################
function is_overlap2(k)
	 for i in 1:length(alive_cells)
		if(i!=k)
			if (alive_cells[i].x - alive_cells[k].x) ^ 2 + (alive_cells[i].y - alive_cells[k].y) ^ 2 < (alive_cells[i].r + alive_cells[k].r) ^ 2
			    return true
			end
		end
	return false
	end
end

function is_overlap_divide(cells::Array, point::Point, radius::Real)
	n = length(cells)
		for i in 1:n
			if (cells[i].x - point.x) ^ 2 + (cells[i].y - point.y) ^ 2 < (cells[i].r + radius) ^ 2
			    return true
			end
		end
	return false
end
##########################################################################################################
function check_any_cell_between(startloc,m)

	println("Check any Cell between")
	println("Angle: ", alive_cells[m].angle)
	j=m
	index=[]
	distance=[]
	d_move=0

	x1=alive_cells[m].x
	y1=alive_cells[m].y
	x0=startloc.x
	y0=startloc.y
	r1=alive_cells[m].r

	println("x0: ",x0, ", y0: ",y0,"   r0: ",r1) 
	println("x1: ",x1, ", y1: ",y1,"   r1: ",r1)
	println("speed: ", alive_cells[m].speed)


	if(x0!=x1)
		a=(y1-y0)/(x1-x0)
		b=(x1*y0-y1*x0)/(x1-x0)
		println("D: y=$(a)x+$(b)")
		for i in 1:length(alive_cells)
			x2=alive_cells[i].x
			y2=alive_cells[i].y
			d23=abs(a*x2 - y2 +b)/sqrt(1+a^2)
			d10=sqrt((x0-x1)^2 + (y0-y1)^2)
			d12=sqrt((x2-x1)^2 + (y2-y1)^2)
			d20=sqrt((x2-x0)^2 + (y2-y0)^2)
			cos1=(-d20^2+d10^2+d12^2)/(2*d10*d12)
			cos0=(-d12^2+d10^2+d20^2)/(2*d10*d20)
			r2=alive_cells[i].r
			if(i!=m && d23<r1+r2 && cos1>0 && cos0>0)
				println("cell number ",i," ",d23)
				index=[index,i]
			end
		end
	else
		for i in 1:length(alive_cells)
			distance=abs(alive_cells[i].x - x0)
			r2=alive_cells[i].r
			if(i!=m && distance<r1+r2 && min(y0,y1)<alive_cells[i].y<max(y0,y1))
				index=[index,i]
			end
		end
	end
	
	if(length(index)>0)
  		for j in 1:length(index)
	  		d=sqrt((startloc.x - alive_cells[index[j]].x)^2 + (startloc.y - alive_cells[index[j]].y)^2)
	  		distance=[distance,d]
			println("x$(index[j]): ",alive_cells[index[j]].x, ", y$(index[j]): ",alive_cells[index[j]].y,"   r$(index[j]): ",alive_cells[index[j]].r," distance: ",d-alive_cells[index[j]].r-alive_cells[m].r)
  		end
		j=index[indmin(distance)]

	end
	
	return j
	println("")
end
##########################################################################################################
function put_at_the_border(m,startloc)
	xm=alive_cells[m].x
	ym=alive_cells[m].y
	x0=startloc.x
	y0=startloc.y
	r=alive_cells[m].r
	
	x=(3*X_SIZE).*ones(4)#w,e,s,n
	x2=(3*X_SIZE).*ones(4)#w,e,s,n
	y=(3*Y_SIZE).*ones(4)
	y2=(3*Y_SIZE).*ones(4)
	d2=Array(Float64,4)
	d=Array(Float64,4)

	if(xm>X_SIZE-r || xm<r || ym>Y_SIZE-r || ym<r)
	  if(xm!=x0)
		n=(ym-y0)/(xm-x0)
	  	p=(-ym*x0 + xm*y0)/(xm-x0)

		x[1]=r
		x2[1]=0
		y[1]=n*r+p
		y2[1]=r
		x[2]=X_SIZE-r
		x2[2]=X_SIZE
		y[2]=n*x[2]+p	
		y2[2]=n*x[2]+p
	  end
	  if(ym!=y0)
		x[3]=(r*(xm-x0)-xm*y0+x0*ym)/(ym-y0)
		x2[3]=(-xm*y0+x0*ym)/(ym-y0)
		y[3]=r
		y2[3]=0
		x[4]=((Y_SIZE-r)*(xm-x0)-xm*y0+x0*ym)/(ym-y0)
		x2[4]==((Y_SIZE)*(xm-x0)-xm*y0+x0*ym)/(ym-y0)
		y[4]=Y_SIZE-r	
		y2[4]=Y_SIZE
	  end
	end

	for i in 1:4
	  d2[i]=sqrt((x2[i]-x0)^2+(y2[i]-y0)^2)
	  d[i]=sqrt((x[i]-x0)^2+(y[i]-y0)^2)		
	end
	j=indmin(d2)
	alive_cells[m].speed=0.95*(alive_cells[m].speed-d[j])

	startloc=Point(x[j],y[j])

	if(j==3 || j==4)
	  alive_cells[m].angle=-alive_cells[m].angle
	else
	  alive_cells[m].angle=pi-alive_cells[m].angle
	end

	if(alive_cells[m].speed>categories[alive_cells[m].cell_type].avg_speed*0.01)
	  alive_cells[m].x=startloc.x + alive_cells[m].speed*cos(alive_cells[m].angle)
	  alive_cells[m].y=startloc.y + alive_cells[m].speed*sin(alive_cells[m].angle)
	else
	  alive_cells[m].y=startloc.y
	  alive_cells[m].x=startloc.x
	  alive_cells[m].speed=0
	end

	return startloc
end
##########################################################################################################
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


