module Init
export init

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
  list=Array(Float64,n,2)
  list[1,1]=x*rand()
  list[1,2]=y*rand()
  for i in 2:n
    print(list)
    placed = false
    while(!placed)
      xi = rand()*x
      yi = rand()*y
      overlap = false
      sleep(.1)
      println("propose $xi,$yi")
      for j in 1:i-1
        if (xi-list[j,1])^2+(yi-list[j,2])^2<((2r)^2)
          println("overlap")
          overlap=true
        end 
      end
      println("overlap is $overlap")
      if !overlap
          list[i,1]=xi
          list[i,2]=yi
          println("placed:")
          println(list[i,:])
          placed = true
      end
    end
  end
  return list
end

#println(init(50,10,10,0.1))

end