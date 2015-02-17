function find_center_where_they_touch(theta,x1,y1,x2,y2,r1,r2)
	  
	  
	  #Solving of an equation to know where the moving cell touch the overlapped cell first
	  a = 1
	  b = 2*(cos(theta)*(x1-x2) + sin(theta)*(y1-y2))
	  c = (x1-x2)^2 + (y1-y2)^2 - (r1+r2)^2 
	  delta = b^2 - 4*a*c

	  d =(-b - sqrt(delta))/2
	  println("d :",d)	
  
	  #We can now place the cell at the border of the touching cell
	  x1 = x1 + d*cos(theta)
	  y1 = y1 + d*sin(theta)
	  println("new x1: ",x1,", new y1: ",y1)

end
