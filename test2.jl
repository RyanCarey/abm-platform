using Base.Graphics
using Cairo
using Tk
include("abm-platform/pause.jl")

win = Toplevel("Test", 400, 200)
c = Canvas(win)
pack(c, expand=true, fill="both")

x = y = 10
global is_blue = true

# Set coordinates to go from 0 to 10 within a 300x100 centered region

function hello_world()
  is_blue = true
  #println("hello world")
end

function blue_box(a,b,width,height)
  hello_world()
  ctx = getgc(c)
  set_coords(ctx, a, b, width, height, 0, 10, 0, 10)
  redness = !is_blue*.7
  blueness = is_blue*.8
  set_source_rgb(ctx, 0, 0, 1)   # set color to blue
  paint(ctx)                     # paint the entire clip region
end

#blue_box(50,50,50,50)
#blue_box(150,150,50,50)

function blue_boxes()
  for i in linspace(0,180,10)
    for j in linspace(0,180,10)
      blue_box(i,j,10,10)
    end
  end
end


#blue_box(310,310,320,320)


c.mouse.button1press = (c,x,y) -> callback(c,x,y)

function callback(c,x,y)
  println("click: ",x,",",y)
  blue_boxes()
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
