# Module containing functions pertaining to cell movement.

function move_any!(dying_indices::Vector{Int},index::Int,x_size::Real, y_size::Real, border_settings::Vector{ASCIIString},
                   alive_cells::Array{Cell,1})
	x=Array(Float64,length(alive_cells))
	y=Array(Float64,length(alive_cells))
	for i in 1:length(alive_cells)
		x[i]=alive_cells[i].x
		y[i]=alive_cells[i].y
	end

 	m = index
	startloc = Point(alive_cells[m].x, alive_cells[m].y)	
	alive_cells[m].angle = mod(angle_from_both(alive_cells[m], categories[alive_cells[m].cell_type].randomness,x_size, y_size), 2*pi)

  if(type_source=="Point")
    sum_ligand = ligand_concentration_multiplesource_2D(alive_cells[m].x,alive_cells[m].y)
  else
    sum_ligand = ligand_concentration_multiplesource_1D(alive_cells[m].x)
  end

	threshold = categories[alive_cells[m].cell_type].stem_threshold

	println("Conc: ", sum_ligand)
	println("Threshold: ", threshold)
	println("Cell is sticking type?: ", categories[alive_cells[m].cell_type].sticking)
	println("Conc > Threshold?: ", sum_ligand > threshold)

  alive_cells[m].speed = -2*log(rand()) * categories[alive_cells[m].cell_type].avg_speed / 5
	if categories[alive_cells[m].cell_type].sticking && sum_ligand > threshold
		println("Cell Stuck!")
		alive_cells[m].speed /= 10
	end

	alive_cells[m].x += alive_cells[m].speed * cos(alive_cells[m].angle)
	alive_cells[m].y += alive_cells[m].speed * sin(alive_cells[m].angle)

	overlap=false
	global list_overlap=[m]

	dying_indices = solve_overlap(m,startloc, dying_indices,x_size, y_size, border_settings,alive_cells) 	
	
	for i in list_overlap
	  if(is_overlap(i,startloc,alive_cells)!=i)
      overlap = true
	  end
	end
	if(overlap)
	  for i in 1:length(alive_cells)
	    alive_cells[i].x=x[i]
	    alive_cells[i].y=y[i]
	  end
	end
	return dying_indices
end
##########################################################################################################
function solve_overlap(m::Int, startloc::Point, dying_indices::Array{Int},x_size::Real, y_size::Real, border_settings::Array{ASCIIString,1},
                       alive_cells::Array{Cell,1})

	#Parameters
	minimum_ratio=0.05 # threshold to trigger cells to move
	g = 0.8 #loss of energy while giving energy to the first cell to the other one
	global counter_overlap = 0

	k=check_any_cell_between(startloc,m,x_size, y_size, border_settings,alive_cells)
	im=true
	ik=true	
	for i in 1:length(list_overlap)
		if(list_overlap[i]==m)
      im=false
		end
		if(list_overlap[i]==k)
      ik=false
		end
	end

	if(im)
    global list_overlap=[list_overlap,m]
	end
	if(ik)
    global list_overlap=[list_overlap,k]
	end

	if k!=m
	  alive_cells[m].x,alive_cells[m].y,d_move=find_center_where_they_touch(alive_cells[m],alive_cells[k],startloc)
	elseif(alive_cells[m].x>x_size-alive_cells[m].r || alive_cells[m].y>y_size-alive_cells[m].r || alive_cells[m].x<0+alive_cells[m].r || alive_cells[m].y<0+alive_cells[m].r)	
	  startloc, dying_indices=put_at_the_border(m,startloc,dying_indices,x_size, y_size, border_settings,alive_cells)
	  dying_indices=solve_overlap(m,startloc,dying_indices,x_size, y_size, border_settings,alive_cells)
	end

	if k!=m
	  d=sqrt((startloc.x - alive_cells[m].x)^2 + (startloc.y - alive_cells[m].y)^2)
	  remaining_distance = alive_cells[m].speed - d

	  if(remaining_distance / categories[alive_cells[m].cell_type].avg_speed > minimum_ratio) #We can now make the cells to move
		x1 = startloc.x
		y1 = startloc.y
		xm=alive_cells[m].x
		xk=alive_cells[k].x
		ym=alive_cells[m].y
		yk=alive_cells[k].y

		if(yk!=ym)
			alive_cells[k].angle=mod(acos((xk-xm)/sqrt((xk-xm)^2+(yk-ym)^2))*sign(yk-ym),2*pi)
			elseif(xk>xm)
				alive_cells[k].angle=0
			else
				alive_cells[k].angle=pi
		end

		if(d_move>0)
			if(ym!=y1)
			alpha = mod(acos((xm - x1)/sqrt((xm - x1)^2+(ym - y1)^2))*sign(ym - y1),2*pi)
			else
			alpha=alive_cells[m].angle
			end

			if(-0.001<alpha<0.001 || pi*0.999<alpha<pi*1.001)
	 	 	  if(xm - x1<0)
				alpha=pi
		 	  else
				alpha=0
			   end
			end


		
		alphak=alive_cells[k].angle
		if(abs(alphak - alpha)  <= pi/2)
        	  if alphak>alpha
          	  	alive_cells[m].angle=mod(alphak-pi/2,2*pi)
        	  else
          		alive_cells[m].angle=mod(alphak+pi/2,2*pi)
        	  end
     		elseif(abs(alphak+2*pi - alpha)  <= pi/2)
      		  if alphak+2*pi>alpha
          		alive_cells[m].angle=mod(alphak-pi/2,2*pi)
      		  else
          		alive_cells[m].angle=mod(alphak+pi/2,2*pi)
        	  end
      		elseif(abs(alphak-2*pi - alpha)  <= pi/2)
        	  if alphak-2*pi>alpha
          		alive_cells[m].angle=mod(alphak-pi/2,2*pi)
        	  else
          		alive_cells[m].angle=mod(alphak+pi/2,2*pi)
        	  end
		else
		  if(abs(alive_cells[k].angle-alpha+pi/2)<pi/2)
			alive_cells[m].angle=mod(alive_cells[k].angle+pi/2,2*pi)
		  else
			alive_cells[m].angle=mod(alive_cells[k].angle-pi/2,2*pi)
		  end
   		end
			
		
		#beta distributes the energy thanks to angle of collision
      		#g*mm*v0 = mm*vm + mk*vk
      		cosm = cos(min(abs(alpha - alive_cells[m].angle),
                 abs(alpha - alive_cells[m].angle +2*pi),abs(alpha - alive_cells[m].angle-2*pi)))
      		cosk = cos(min(abs(alpha - alive_cells[k].angle),
                 abs(alpha - alive_cells[k].angle +2*pi),abs(alpha - alive_cells[k].angle-2*pi)))
      
      		alive_cells[k].speed=cosk*g*alive_cells[k].speed*(alive_cells[m].r/alive_cells[k].r)^2
      		alive_cells[m].speed=cosm*g*alive_cells[m].speed 
		startlock=Point(xk,yk)
		startlocm=Point(xm,ym)


		alive_cells[k].x+=alive_cells[k].speed*cos(alive_cells[k].angle)
		alive_cells[k].y+=alive_cells[k].speed*sin(alive_cells[k].angle)

		saved_anglem=alive_cells[m].angle
		saved_speedm=alive_cells[m].speed

		startlock=Point(xk,yk)
		startlocm=Point(xm,ym)


		alive_cells[k].x+=alive_cells[k].speed*cos(alive_cells[k].angle)
		alive_cells[k].y+=alive_cells[k].speed*sin(alive_cells[k].angle)

		saved_anglem=alive_cells[m].angle
		saved_speedm=alive_cells[m].speed

		dying_indices=solve_overlap(k,startlock,dying_indices,x_size, y_size, border_settings,alive_cells)

		alive_cells[m].angle=saved_anglem
		alive_cells[m].speed=saved_speedm
		startlocm.x=alive_cells[m].x
		startlocm.y=alive_cells[m].y
		alive_cells[m].x+=alive_cells[m].speed*cos(alive_cells[m].angle)
		alive_cells[m].y+=alive_cells[m].speed*sin(alive_cells[m].angle)

		dying_indices=solve_overlap(m,startlocm,dying_indices,x_size, y_size, border_settings,alive_cells)
		#if d_move <0
		else
		alive_cells[m].speed=0
		alive_cells[k].speed=0
		end
	  end	  
	end
	return dying_indices
end

##########################################################################################################
function find_center_where_they_touch(cellm::Cell,cellk::Cell,startloc::Point)
	x1 = startloc.x
	y1 = startloc.y
	x2 = cellk.x
	y2 = cellk.y
	r1 = cellm.r
	r2 = cellk.r
	theta1=mod(cellm.angle,2*pi)
	theta = mod(acos((cellm.x - x1)/sqrt((cellm.x - x1)^2+(cellm.y - y1)^2))*sign(cellm.y - y1),2*pi)

	if(-0.001<theta1<0.001 || pi*0.999<theta1<pi*1.001)
	  if(cellm.x - x1<0)
		theta1=pi
	  else
		theta1=0
	  end
	end

	#Solving of an equation to know where the moving cell touch the overlapped cell first
	a = 1
	b = 2*(cos(theta1)*(x1-x2) + sin(theta1)*(y1-y2))
	c = (x1-x2)^2 + (y1-y2)^2 - (r1+r2)^2 
	delta = b^2 - 4*a*c
	d=0
	try
	d =0.9999*min(((-b - sqrt(delta))/2),((-b + sqrt(delta))/2))
	end
	#We can now place the cell at the border of the touching cell
	x1 = x1 + d*cos(theta1)
	y1 = y1 + d*sin(theta1)

	return x1,y1,d
end

##########################################################################################################
function is_overlap(k::Int,startloc::Point,alive_cells::Array{Cell,1})
	 for i in 1:length(alive_cells)
		if(i!=k)
			if (alive_cells[i].x - startloc.x) ^ 2 + (alive_cells[i].y - startloc.y) ^ 2 < 0.999*(alive_cells[i].r + alive_cells[k].r) ^ 2
			    return i
			end
		end
	end
	return k
end
##########################################################################################################
function is_overlap_divide(cells::Vector{Cell}, point::Point, radius::Real)
	n = length(cells)
		for i in 1:n
			if (cells[i].x - point.x) ^ 2 + (cells[i].y - point.y) ^ 2 < (cells[i].r + radius) ^ 2
			    return true
			end
		end
	return false
end
##########################################################################################################
function check_any_cell_between(startloc::Point,m::Int,x_size::Real, y_size::Real, border_settings::Vector{ASCIIString},
                                alive_cells::Vector{Cell})

	j=m
	index=[]
	distance04=[]
	d_move=0

	x1=alive_cells[m].x
	y1=alive_cells[m].y
	x0=startloc.x
	y0=startloc.y
	r1=alive_cells[m].r

	if(x0!=x1)
		n=(y1-y0)/(x1-x0)
		p=(x1*y0-y1*x0)/(x1-x0)	

		for i in 1:length(alive_cells)
			x2=alive_cells[i].x
			y2=alive_cells[i].y
			r2=alive_cells[i].r

			d23=abs(n*x2 - y2 +p)/sqrt(1+n^2)
			d10=sqrt((x0-x1)^2 + (y0-y1)^2)
			d12=sqrt((x2-x1)^2 + (y2-y1)^2)
			d20=sqrt((x2-x0)^2 + (y2-y0)^2)
			cos1=(-d20^2+d10^2+d12^2)/(2*d10*d12)
			cos0=(-d12^2+d10^2+d20^2)/(2*d10*d20)


			if(i!=m && d23<(r1+r2)-0.0001 && (cos1>0 || d12<r1+r2+0.00001) && (cos0>0||d20<r1+r2+0.00001))
				#To know which overlaping cell is the closest from the startlocation we need to calculate the distance
				d24=r1+r2
				a=1
				b=-2*d20*cos0
				c=d20^2-d24^2
				delta=b^2-4*a*c
				d04=(-b-sqrt(delta))/(2*a)

				d=sqrt((startloc.x - alive_cells[i].x)^2 + (startloc.y - alive_cells[i].y)^2)
				if(!(0>d-r1-r2>-0.000001) && d04>-0.000001)
				index=[index,i]
				distance04=[distance04,d04]
				end
			end
		end
	else
		for i in 1:length(alive_cells)
			x2=alive_cells[i].x
			y2=alive_cells[i].y
			d23=abs(alive_cells[i].x - x0)
			r2=alive_cells[i].r
			if(i!=m && d23<(r1+r2)-0.0001 && min(y0-r1,y1-r1)<y2<max(y0+r1,y1+r1))
				d=sqrt((startloc.x - x2)^2 + (startloc.y - y2)^2)
				a=1
				b=-2*y2
				c=(x0-x2)^2+y2^2-(r1+r2)^2
				delta=b^2-4*a*c
				d04=(-b-sqrt(delta))/(2*a)
				if(!(0>d-r1-r2>-0.000001) && d04>-0.000001)
				index=[index,i]
				distance04=[distance04,d04]
				end				
			end
		end
	end
	
	if(length(index)>0)
		j=index[indmin(distance04)]

		#The cell can touch the border before touching the cell, then we need to put the cell at the border
		#We need to check wether the new location of the cell when touching the closest cell
		x,y,d=find_center_where_they_touch(alive_cells[m],alive_cells[j],startloc)
		if(x>x_size-r1 || x<r1 || y>y_size-r1 || y<r1)
			j=m
		end
	end
	
	return j
end
##########################################################################################################
function put_at_the_border(m::Int,startloc::Point, dying_indices::Vector{Int},x_size::Real, y_size::Real, 
                           border_settings::Vector{ASCIIString},alive_cells::Vector{Cell})
	xm=alive_cells[m].x
	ym=alive_cells[m].y
	x0=startloc.x
	y0=startloc.y	
	r=alive_cells[m].r

  #######
  #If we have any troubles at the very begginning
	if(x0>x_size-r || x0<r || y0>y_size-r || y0<r)
	  if(x0>x_size-r)
		alive_cells[m].x=x_size-r
	  end
	  if(x0<r)	
		alive_cells[m].x=r
	  end
	  if(y0>y_size-r)
		alive_cells[m].y=y_size-r
	  end
	  if(y0<r)	
		alive_cells[m].y=r
	  end
	  alive_cells[m].speed=0
	  startloc=Point(alive_cells[m].x,alive_cells[m].y)
  #######
  #Otherwise
	else

	x=(3*x_size).*ones(4)#w,e,s,n
	y=(3*y_size).*ones(4)
	d2=Array(Float64,4)
	d=Array(Float64,4)

	if(xm>x_size-r || xm<r || ym>y_size-r || ym<r)
	  if(xm!=x0)
		n=(ym-y0)/(xm-x0)
    p=(-ym*x0 + xm*y0)/(xm-x0)

		x[1]=r
		y[1]=n*r+p
		x[2]=x_size-r
		y[2]=n*x[2]+p	
	  end
	  if(ym!=y0)
		x[3]=(r*(xm-x0)-xm*y0+x0*ym)/(ym-y0)
		y[3]=r
		x[4]=((y_size-r)*(xm-x0)-xm*y0+x0*ym)/(ym-y0)
		y[4]=y_size-r	
	  end
	end
	
	for i in 1:4
	  d[i]=sqrt((x[i]-x0)^2+(y[i]-y0)^2)		
	end

	if(xm>x0)#going east
	  if(ym>y0)#going north and east
      if(d[2]>d[4]) #nort border is hit first
        j=4
      else
        j=2
      end
	  else#going south and east	
      if(d[2]>d[3])
        j=3
      else
        j=2
      end
	  end
	else#going west
	  if(ym>y0)#going north and west
      if(d[1]>d[4])
        j=4
      else
        j=1
      end
	  else#going south and west	
      if(d[1]>d[3])
        j=3
      else
        j=1
      end
	  end
	end

	alive_cells[m].speed=0.95*(alive_cells[m].speed-d[j])
	startloc=Point(x[j],y[j])

  for i in [3,4] # check south / north hits
    if j == i
      if border_settings[i] == "reflecting"
        alive_cells[m].angle=mod(-alive_cells[m].angle,2*pi)
      elseif border_settings[i] == "absorbing"
        alive_cells[m].speed /= 10
        alive_cells[m].angle=mod(-alive_cells[m].angle,2*pi)
      elseif border_settings[i] == "removing"
        alive_cells[m].speed /= 10
        alive_cells[m].angle=mod(-alive_cells[m].angle,2*pi)
        push!(dying_indices, m)
      end
    end
  end

  for i in [1,2] # check west / east hits
    if j == i
      if border_settings[i] == "reflecting"
        alive_cells[m].angle=mod(pi-alive_cells[m].angle,2*pi)
      elseif border_settings[i] == "absorbing"
        println("absorbed")
        alive_cells[m].speed /= 10
        alive_cells[m].angle=mod(pi-alive_cells[m].angle,2*pi)
      elseif border_settings[i] == "removing"
        println("killed")
        alive_cells[m].speed /= 10
        alive_cells[m].angle=mod(pi-alive_cells[m].angle,2*pi)
        push!(dying_indices, m)
      end
    end
  end

  # complete move with new direction and speed
  alive_cells[m].x=startloc.x + alive_cells[m].speed*cos(alive_cells[m].angle)
  alive_cells[m].y=startloc.y + alive_cells[m].speed*sin(alive_cells[m].angle)
  end
  return startloc, dying_indices
end
