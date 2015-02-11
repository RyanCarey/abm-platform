using Base.Graphics
using Cairo
using Tk
include("pause.jl")
using Winston

function incr(state)
  println("4th state equals: ",state["col"])
  state["col"] += .1
end

function invert_coord(x,y)
  println("coords: ",x,", ",y)
  println("transformed: ",X_SIZE*(x-47)/(372-47),", ",Y_SIZE*(360-y)/(360-28))
end

function box(c,x,y,state)
  x_click = X_SIZE*(x-47)/(372-47)
  y_click = Y_SIZE*(360-y)/(360-28)
  if (0 < x_click < X_SIZE) && (0 < y_click < Y_SIZE)
    state["x_list"] = [state["x_list"]; x_click]
    state["y_list"] = [state["y_list"]; y_click]
    state["col_list"] = [state["col_list"]; state["col"]]
    state["col"] += .1

    println("x list: ",state["x_list"])
    println("y list: ",state["y_list"])
    println("col: ",state["col_list"])
    size_list = ones(length(state),1)

    ctx = getgc(c)
    println(state["x_list"],state["y_list"])
    p = scatter(state["x_list"],state["y_list"])
    xlim(0,X_SIZE)
    ylim(0,Y_SIZE)
    display(c,p)
  end
end

global state = Dict("x_list"=>[],"y_list"=>[],"col_list"=>[],"col"=>0.)

win = Toplevel("Test")
c = Canvas(win)
c[:width]=400
c[:height]=400
println("canvas height: ",c[:height])
pack(c, expand=true, fill="both")
p = scatter([0.],[0.],[0.])
xlim(0,10)
ylim(0,10)
display(c,p)
X_SIZE = Y_SIZE = 10

c.mouse.button1press = (c,x,y) -> box(c,x,y,state)








# keeps program open
if !isinteractive()
  while true
    a = readline(STDIN)
    if a == "exit"
      return
    end
  end
end

#= to paint
  width = height = 10
  set_coords(ctx, a, b, width, height, 0, 10, 0, 10)
  set_source_rgb(ctx, redness, 0, blueness)
  paint(ctx) #paint the entire clip region
  =#
#=
function boxes(state)
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

