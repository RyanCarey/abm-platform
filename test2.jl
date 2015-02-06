using Base.Graphics
using Cairo
using Tk
include("pause.jl")

win = Toplevel("Test", 400, 200)
c = Canvas(win)
pack(c, expand=true, fill="both")

x = y = 10
global is_blue = true

# Set coordinates to go from 0 to 10 within a 300x100 centered region

global message = ""
function hello()
  is_blue = true
  println(message)
  
end

#=
function box(a,b,width,height,is_blue)
  hello_world()
  ctx = getgc(c)
  set_coords(ctx, a, b, width, height, 0, 10, 0, 10)
  redness = !is_blue*.7
  blueness = is_blue*.8
  println("r: ",redness)
  println("b: ",blueness)
  set_source_rgb(ctx, redness, 0, blueness)   # set color to blue
  paint(ctx)                     # paint the entire clip region
  return is_blue
end


function boxes(is_blue)
  #is_blue = !is_blue
  for i in linspace(0,180,3)
    for j in linspace(0,180,3)
      is_blue = box(i,j,10,10,is_blue)
      is_blue = !is_blue
    end
    println("blue as at end of row: ",is_blue)
  end
  println("blue as at end of click: ",is_blue)
  return !is_blue
end
=#



function precall(c,x,y)
  callback(c,x,y,hello)
end

global is_blue = true
c.mouse.button1press = precall


function callback(c,x,y,is_blue)
  println("click: ",x,",",y)
  println("blue as at time of click: ",is_blue)
  is_blue = boxes(is_blue)
end

# keeps program open
if !isinteractive()
  while true
    a = readline(STDIN)
    if a == "exit"
      return
    end
  end
end
