
#Initialization function
#1st parameter: number of cells
#2nd parameter: length of the square
#3rd parameter: width of the square surrounding the cells
#4th parameter: radius of the cell
#
#This function return a 2D list of random located cells within the square's borders. The cells have a radius and they do not overlap.
#We initilaize the first location of the cell and then for each new potential cell we look within the list whether the cell is
#overlapping with another cell. If yes, we choose another random location for the cell

function init(n,x,y,r)
list=Array(Float64,n,5)
list[1,3]= rand_radius(r,r*rvar)
list[1,1]= list[1,3] + (x- 2 * list[1,3]) * rand()
list[1,2]= list[1,3] + (y- 2 * list[1,3]) * rand()
rvar = 0.1 # variation can be adjusted here
  if(n>1)
    for i in 2:n
      placed=false
      fails = 0
      ri = rand_radius(r,r*rvar)
      while !placed
        xi = ri+(x-2*ri) * rand()
        yi = ri+(y-2*ri) * rand()
        overlap=false
        for j in 1:i-1
          if((xi-list[j,1])^2+(yi-list[j,2])^2<(ri+list[j,3])^2)
            overlap=true
          end
        end
        if overlap
          fails += 1
          if fails > 10000
            println("")
            error("could not place cell, try smaller radius or larger map")
          end
        else
          list[i,1]=xi
          list[i,2]=yi
          list[i,3]=ri
          placed=true
        end
      end
    end
  end
return list
end

function rand_radius(mean,stdev)
  radius = mean+stdev*randn()
  # while radius is negative, try again
  while radius <= 0
    radius = rand_radius(mean,stdev)
  end
  return radius
end





#println(init(50,10,10,0.1))


