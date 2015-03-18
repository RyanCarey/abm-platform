# Module containing functions pertaining to cell movement.

function move!(alive_cells::Vector{Cell},categories::Vector{Cell_type},dying_indices::Vector{Int},index::Int,
               x_size::Real, y_size::Real, border_settings::Vector{ASCIIString}, time::Real,g)

	#Storage of teh location in the case of a wriong computation
	x=Array(Float64,length(alive_cells))
	y=Array(Float64,length(alive_cells))
	for i in 1:length(alive_cells)
		x[i]=alive_cells[i].x
		y[i]=alive_cells[i].y
	end
	#index of the cell we are going to move
 	m = index
	#Orignial location of the m cell
	startloc = Point(alive_cells[m].x, alive_cells[m].y)
	#Thanks to the concnetration we calculate the angle of the m cell
  proposed_angle, concentrations = angle_from_both(alive_cells[m], categories, 
                                   categories[alive_cells[m].cell_type].randomness,x_size, y_size, time)
	alive_cells[m].angle = mod2pi(proposed_angle)

	#Is the cell in the niche?
	threshold = categories[alive_cells[m].cell_type].stem_threshold
	#Proposed speed
	alive_cells[m].speed = -2*log(rand()) * categories[alive_cells[m].cell_type].avg_speed / 5
	#The speed is reduced if the cell is sticking to ligand
  println("mean concentration: ",mean(concentrations))
	if categories[alive_cells[m].cell_type].sticking && mean(concentrations) > threshold
		alive_cells[m].speed /= 10
	end
	#Propose move for the m cell
	alive_cells[m].x += alive_cells[m].speed * cos(alive_cells[m].angle)
	alive_cells[m].y += alive_cells[m].speed * sin(alive_cells[m].angle)

	overlap=false
	#This is the list where we are going to test for evidence for overlap (ie the move is not correct)
	global list_overlap=[m]

	#the propose move ios tested within this function. It can actualize the movements
	dying_indices = solve_overlap(categories,m,startloc, dying_indices,x_size, y_size, border_settings,alive_cells,g)

	for i in list_overlap
	  if is_overlap(i,startloc,alive_cells)!=i
      	    overlap = true
	  end
	end
	if overlap
	  for i in 1:length(alive_cells)
	    alive_cells[i].x=x[i]
	    alive_cells[i].y=y[i]
	  end
	end
	return dying_indices, concentrations
end

##########################################################################################################
function solve_overlap(categories::Vector{Cell_type},m::Int, startloc::Point, 
                       dying_indices::Array{Int},x_size::Real, y_size::Real, border_settings::Vector{ASCIIString},
                       alive_cells::Vector{Cell},g::Real)
	#We first check for cells between the original location and the propose location of the cell m
	#k is the index of the touching cell. The function returns m if the cell m does not touch any cell.
	#If the cell touches iots first cell beyond the wall this function returns the index m. It does not count. 
	k=check_any_cell_between(startloc,m,x_size, y_size, border_settings,alive_cells)

	#We store in this part of the code all the index of cells we have moved to know whether they overlap with anotehr cell at the end
	#this allows us to check for less overlap
	indexm=true
	indexk=true
	for i in 1:length(list_overlap)
	  if list_overlap[i]==m
      		indexm=false
	  end
	  if list_overlap[i]==k
      		indexk=false
		end
	end
	if indexm
    	  global list_overlap=[list_overlap,m]
	end
	if indexk
    	  global list_overlap=[list_overlap,k]
	end

	#If the cell touch another cell, we put this cell at the border of the cell k. 
	#otherwise, if the cell m goes beyond the wall, we put it at the border and we actualize its angle, speed, startlocation and propose location
	#Otherwise, the cell can complete its move
	if k!=m
	  alive_cells[m].x,alive_cells[m].y,d_move=find_center_where_they_touch(alive_cells[m],alive_cells[k],startloc)
	elseif (alive_cells[m].x>x_size-alive_cells[m].r || alive_cells[m].y>y_size-alive_cells[m].r || 
         alive_cells[m].x<0+alive_cells[m].r || alive_cells[m].y<0+alive_cells[m].r)
	  startloc, dying_indices=put_at_the_border(m,startloc,dying_indices,x_size, y_size, border_settings,alive_cells,g)
	  dying_indices=solve_overlap(categories, m,startloc,dying_indices,x_size, y_size, border_settings,alive_cells,g)
	end

	#this part deals with the boucing of cells. k needs to be different from m.
	if k!=m
	  #the major cause of stop of movement is because the cell m which has moved to cell k does not have enough speed left (ie. energy) to trigger boucing 
	  #of the cell k and the cell m. We therefore calculate the remaining distance to do (as we work within one time step, speed and distance are equivalent)
	  d=sqrt((startloc.x - alive_cells[m].x)^2 + (startloc.y - alive_cells[m].y)^2)
	  remaining_distance = alive_cells[m].speed - d
	  if remaining_distance > categories[alive_cells[m].cell_type].threshold_movement   
		#We can now make the cells to move
		#Notation simplification, in order to understand what is following
		x1 = startloc.x
		y1 = startloc.y
		xm=alive_cells[m].x
		xk=alive_cells[k].x
		ym=alive_cells[m].y
		yk=alive_cells[k].y
		
		#According to the manual the angle of the cell k is calculated as follow
		if yk!=ym
		  alive_cells[k].angle=mod2pi(acos((xk-xm)/sqrt((xk-xm)^2+(yk-ym)^2))*sign(yk-ym))
		  elseif xk>xm
		    alive_cells[k].angle=0
		  else
		   alive_cells[k].angle=pi
		end
		#If the distance m had to do to be placed next to k is negative, it is because they were already overlaping and therefore we need to stop the algorithm
		#Otherwise the speed could be increased and the movement would never stop. Besides we are going to delete the move, so we earn time.
		if d_move>0
		  #According to the manual the angle of the cell k is calculated as follow
		  #alpha is the original angle of the m cell
		  if ym!=y1
		    alpha = mod2pi(acos((xm - x1)/sqrt((xm - x1)^2+(ym - y1)^2))*sign(ym - y1))
		  else
		    alpha=alive_cells[m].angle
		  end
		  #Because of the fact that angle true modulo 2*pi, we need to do as following to calculate the angle of the cell m
		  #the cell m will move perpendicularely to the cell k and in the same direction than its first direction
		  alphak=alive_cells[k].angle
		  if abs(alphak - alpha)  <= pi/2
          	    if alphak>alpha
          	  	alive_cells[m].angle=mod2pi(alphak-pi/2)
        	    else
          		alive_cells[m].angle=mod2pi(alphak+pi/2)
        	    end
     		  elseif abs(alphak+2*pi - alpha)  <= pi/2
      		    if alphak+2*pi>alpha
          		alive_cells[m].angle=mod2pi(alphak-pi/2)
      		    else
          		alive_cells[m].angle=mod2pi(alphak+pi/2)
        	    end
      		  elseif abs(alphak-2*pi - alpha)  <= pi/2
        	    if alphak-2*pi>alpha
          		alive_cells[m].angle=mod2pi(alphak-pi/2)
        	    else
          		alive_cells[m].angle=mod2pi(alphak+pi/2)
        	    end
		  else
		    if abs(alive_cells[k].angle-alpha+pi/2)<pi/2
        		alive_cells[m].angle=mod2pi(alive_cells[k].angle+pi/2)
		    else
       			alive_cells[m].angle=mod2pi(alive_cells[k].angle-pi/2)
		    end
    		  end
		  #Distribution of the energy thanks to angle of collision
      		  #g*mm*v0 = mm*vm + mk*vk
      		  cosm = cos(min(abs(alpha - alive_cells[m].angle),
                   abs(alpha - alive_cells[m].angle +2*pi),abs(alpha - alive_cells[m].angle-2*pi)))
      		  cosk = cos(min(abs(alpha - alive_cells[k].angle),
                   abs(alpha - alive_cells[k].angle +2*pi),abs(alpha - alive_cells[k].angle-2*pi)))
     		  alive_cells[k].speed=cosk*g*alive_cells[k].speed*(alive_cells[m].r/alive_cells[k].r)^2
      		  alive_cells[m].speed=cosm*g*alive_cells[m].speed

		  #We store the original position of the cell k and the cell m before proposing a move for them and test it recursively.
		  #the original position is a parameter of the function we are now in.
		  startlock=Point(xk,yk)
		  startlocm=Point(xm,ym)
		  #Propose move for k
		  alive_cells[k].x+=alive_cells[k].speed*cos(alive_cells[k].angle)
		  alive_cells[k].y+=alive_cells[k].speed*sin(alive_cells[k].angle)
		  #We need to save the speed and angle of the cell m in order to make it move in the right direction when the cell k will have made its move 
		  #(and the move of all the cells that it could trigger, including the cell m)
		  saved_anglem=alive_cells[m].angle
		  saved_speedm=alive_cells[m].speed
		  #Recursively we make the cell k move
		  dying_indices=solve_overlap(categories, k,startlock,dying_indices,x_size, y_size, border_settings,alive_cells,g)
		  #We restore the value of m and we make it move recursively.
		  alive_cells[m].angle=saved_anglem
		  alive_cells[m].speed=saved_speedm
		  startlocm.x=alive_cells[m].x
		  startlocm.y=alive_cells[m].y
		  alive_cells[m].x+=alive_cells[m].speed*cos(alive_cells[m].angle)
		  alive_cells[m].y+=alive_cells[m].speed*sin(alive_cells[m].angle)
		  dying_indices=solve_overlap(categories, m,startlocm,dying_indices,x_size, y_size, border_settings,alive_cells,g)
		#if d_move <0 we do not implemet the movement and we stop cell k and cell m
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
	#Notation simplification, in order to understand what is following
	x1 = startloc.x
	y1 = startloc.y
	x2 = cellk.x
	y2 = cellk.y
	r1 = cellm.r
	r2 = cellk.r
	theta=mod2pi(cellm.angle)
	#Solving of an equation to know where the moving cell touch the overlapped cell first
	#To understand the a,b and c please refer to the manual
	a = 1
	b = 2*(cos(theta)*(x1-x2) + sin(theta)*(y1-y2))
	c = (x1-x2)^2 + (y1-y2)^2 - (r1+r2)^2
	delta = b^2 - 4*a*c
	#Because the computer can confund -1e-16 and 0, the square root of delta can be negative
	d=0
	try
	d =0.9999*min(((-b - sqrt(delta))/2),((-b + sqrt(delta))/2))#we multiply it by 0.9999 in order to prevent the cell from a overlap of -1e-16 for instance
	end
	#We can now place the cell at the border of the touching cell
	x1 = x1 + d*cos(theta)
	y1 = y1 + d*sin(theta)

	return x1,y1,d
end

##########################################################################################################
function is_overlap(k::Int,startloc::Point,alive_cells::Array{Cell,1})
#Function used to assess wheteher there are some overlaps at the end of the movement process
	for i in 1:length(alive_cells)
	  if (alive_cells[i].x - startloc.x) ^ 2 + (alive_cells[i].y - startloc.y) ^ 2 < 0.999*(alive_cells[i].r + alive_cells[k].r) ^ 2 && i!=k
	    return i
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
	#This function returns the index of the ceel on the journey of the cell m
	#therefore if there are no cell we initialize the j to m
	j=m
	#Initialization and notation simplification
	index=[]
	distance04=[]
	d_move=0
	x1=alive_cells[m].x
	y1=alive_cells[m].y
	x0=startloc.x
	y0=startloc.y
	r1=alive_cells[m].r
	#Depending on the case whether the cell is going in a way parallel of the x axis or not we can or not calculate the 
	#coefficient of the line linking the startlocation of the cell m and its proposed location
	if x0!=x1
	  #Those are the coefficients of the line linking the startlocation of the cell m and its proposed location
	  #D: y=nx+p
	  n=(y1-y0)/(x1-x0)
	  p=(x1*y0-y1*x0)/(x1-x0)
	    #For each cell we are going to check whether it os on the journey of the cell m
	    for i in 1:length(alive_cells)
		#notation simplification
		x2=alive_cells[i].x
		y2=alive_cells[i].y
		r2=alive_cells[i].r
		#Those are the distance linking the different cell location
		#Please refer to the manual for more information
		#0 is the startlocation of the m cell
		#1 is the proposed location of the cell m
		#2 is the location of the studied cell for overlap with the cell m
		#3 is the location of the cell m where its distance with the cell 2 is minimal (the overlap can be big) 
		#4 is the first position of the cell m when it start overlaping the cell 2
		d23=abs(n*x2 - y2 +p)/sqrt(1+n^2)
		d10=sqrt((x0-x1)^2 + (y0-y1)^2)
		d12=sqrt((x2-x1)^2 + (y2-y1)^2)
		d20=sqrt((x2-x0)^2 + (y2-y0)^2)
		#Thanks to Al-Kashi we hace calculated teh angle within the triangle 012
		cos1=(-d20^2+d10^2+d12^2)/(2*d10*d12)
		cos0=(-d12^2+d10^2+d20^2)/(2*d10*d20)
		#the cell m overlap with the cell 2 if 
		#	the distance between 2 and 3 is smaller than the sum of their radius
		#	cos1 is positive of if the cell 2 is already overlaping the cell 0
		#	cos0 is positive of if the cell 2 is overlaping the cell 1
		#Please seek in the manual more information
		if i!=m && d23<(r1+r2)-0.0001 && (cos1>0 || d12<r1+r2+0.00001) && (cos0>0||d20<r1+r2+0.00001)
	  	  #To know which overlaping cell is the closest from the startlocation we need to calculate the distance between 0 and 4
		  #Please seek in the manual the origin of the coefficients a b and c
		  d24=r1+r2
		  a=1
		  b=-2*d20*cos0
		  c=d20^2-d24^2
		  delta=b^2-4*a*c
		  #d04 is necessary the smallest of the two solution of the equation and therefore necessary the one with a minus
		  d04=(-b-sqrt(delta))/(2*a)
		  d=sqrt((startloc.x - alive_cells[i].x)^2 + (startloc.y - alive_cells[i].y)^2)
		  #Finally we store the distance between 0 and 4 and the index of the cell 2 to look after for the first one touching the cell m
		  if !(0>d-r1-r2>-0.000001) && d04>-0.000001
		    index=[index,i]
		    distance04=[distance04,d04]
		  end
		end
	    end
	else
	  #We do the same thing in the case where x1=x0
	  #Its just much simpler
	  for i in 1:length(alive_cells)
	    x2=alive_cells[i].x
	    y2=alive_cells[i].y
	    d23=abs(alive_cells[i].x - x0)
    	    r2=alive_cells[i].r
	    if i!=m && d23<(r1+r2)-0.0001 && min(y0-r1,y1-r1)<y2<max(y0+r1,y1+r1)
		d=sqrt((startloc.x - x2)^2 + (startloc.y - y2)^2)
		a=1
		b=-2*y2
		c=(x0-x2)^2+y2^2-(r1+r2)^2
		delta=b^2-4*a*c
		#d04 is necessary the smallest of the two solution of the equation and therefore necessary the one with a minus
		d04=(-b-sqrt(delta))/(2*a)
		#Finally we store the distance between 0 and 4 and the index of the cell 2 to look after for the first one touching the cell m
		if !(0>d-r1-r2>-0.000001) && d04>-0.000001
	  	  index=[index,i]
		  distance04=[distance04,d04]
		end
	    end
	  end
	end
	#Finally we have to check wehther they are touching beyond the wall or not
	if length(index)>0
		j=index[indmin(distance04)]
		#The cell can touch the border before touching the cell, then we need to put the cell at the border
		#We need to check wether the new location of the cell when touching the closest cell
		x,y,d=find_center_where_they_touch(alive_cells[m],alive_cells[j],startloc)
		if x>x_size-r1 || x<r1 || y>y_size-r1 || y<r1
			j=m
		end
	end
	return j
end
##########################################################################################################
function put_at_the_border(m::Int,startloc::Point, dying_indices::Vector{Int},x_size::Real, y_size::Real,
                           border_settings::Vector{ASCIIString},alive_cells::Vector{Cell},g::Real)
#This functions put the moving cell m at the border (its new startlocation), changes its direction and its speed.

	#Notation simplification
	xm=alive_cells[m].x
	ym=alive_cells[m].y
	x0=startloc.x
	y0=startloc.y
	r=alive_cells[m].r
  	#If we have any troubles at the very begginning
	#we cancel the move
	if x0>x_size-r || x0<r || y0>y_size-r || y0<r
	  if x0>x_size-r
		alive_cells[m].x=x_size-r
	  end
	  if x0<r
		alive_cells[m].x=r
	  end
	  if y0>y_size-r
		alive_cells[m].y=y_size-r
	  end
	  if y0<r
		alive_cells[m].y=r
	  end
	  alive_cells[m].speed=0
	  startloc=Point(alive_cells[m].x,alive_cells[m].y)
  	#Otherwise, we areg oing top search first where the cell can touch the wall. Four positions are possible. 
	#Then we are going to choose the one the cell is going to touch first.
	#finally we are going to modify cell movement according to the behaviour of the it is touching
	else
	#Array initialization
	#We are going to store the west, east, south and north behaviour
	#We put a original high value for x and y as we are going to calculate distance afterwards in order to know which wall is touched first
	x=(3*x_size).*ones(4)#x coordinates of the possible locations when touching the wall
	y=(3*y_size).*ones(4)#y coordinates of the possible locations when touching the wall
	d2=Array(Float64,4)
	d=Array(Float64,4)
	#First, we store the four possible locations of the cell while touching each wall
	#Please refer to report to have a display
	if xm>x_size-r || xm<r || ym>y_size-r || ym<r
	  #We are going to use the line linking the startlocation of the cell m and its proposed location
	  #D: y=nx+p, n and p only exists if the line is not vertical and we 
	  if xm!=x0#The line needs to be not vertical in order to touch the west and the east borders
      	    n=(ym-y0)/(xm-x0)
            p=(-ym*x0 + xm*y0)/(xm-x0)
	    #West and East behaviour. We use the line equation to find ywest and yeast. 
      	    x[1]=r
      	    y[1]=n*r+p
      	    x[2]=x_size-r
      	    y[2]=n*x[2]+p
	  end
	  if ym!=y0#The line needs to be not horizontal in order to touch the north and the south borders
	    #South and North behaviour. We use the line equation to find xsouth and xnorth	     
      	    x[3]=(r*(xm-x0)-xm*y0+x0*ym)/(ym-y0)
      	    y[3]=r
      	    x[4]=((y_size-r)*(xm-x0)-xm*y0+x0*ym)/(ym-y0)
      	    y[4]=y_size-r
	  end
	end
	#we store here the distance between the startlocation and the proposed location
	for i in 1:4
	  d[i]=sqrt((x[i]-x0)^2+(y[i]-y0)^2)
	end
	#According to the direction of the moving cell, we are going to choose whcich wall is touched first
	#j=1:west
	#j=2:east
	#j=3:south
	#j=4:north
	if xm>x0  #going east
	  if ym>y0 #going north and east
      	    if d[2]>d[4] #nort border is hit first
              j=4
      	    else
              j=2
            end
	  else  #going south and east
            if d[2]>d[3]
              j=3
            else
              j=2
            end
	  end
	else  #going west
	  if ym>y0 #going north and west
            if d[1]>d[4]
              j=4
            else
              j=1
            end
	  else  #going south and west
            if d[1]>d[3]
              j=3
            else
              j=1
            end
	  end
	end
	#We can then modify without any knowledge about the wall behaviour change the speed (ie the remaining distance, as we are working in a defined time step)
	#And the startlocation
	alive_cells[m].speed=g*(alive_cells[m].speed-d[j])
	startloc=Point(x[j],y[j])
	#The angle in case of north/south reflection is not the same as in the case of east/west reflection 	
	for i in [3,4] # check south / north hits
	  if j == i
	    if border_settings[i] == "reflecting"
	      alive_cells[m].angle=mod2pi(-alive_cells[m].angle)
	    elseif border_settings[i] == "absorbing"
	      alive_cells[m].speed /= 10
	      alive_cells[m].angle=mod2pi(-alive_cells[m].angle)
	    elseif border_settings[i] == "removing"
	      alive_cells[m].speed /= 10
	      alive_cells[m].angle=mod2pi(-alive_cells[m].angle)
	      push!(dying_indices, m)
	    end
	  end
	end
        for i in [1,2] # check west / east hits
          if j == i
            if border_settings[i] == "reflecting"
              alive_cells[m].angle=mod2pi(pi-alive_cells[m].angle)
            elseif border_settings[i] == "absorbing"
              alive_cells[m].speed /= 10
              alive_cells[m].angle=mod2pi(pi-alive_cells[m].angle)
            elseif border_settings[i] == "removing"
              alive_cells[m].speed /= 10
              alive_cells[m].angle=mod2pi(pi-alive_cells[m].angle)
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
