include("pause.jl")
using Tk
using Winston

function graph(canvas,x,y,color::String)
  p = FramedPlot()
  add(p,Curve(x,y,"color",color))
  Winston.display(canvas, p)
end

w = Toplevel("Testing", 700, 400)
f = Frame(w); pack(f, expand=true, fill="both")

c = Canvas(f, 500, 400)
grid(c, 1, 1, sticky="nsew")
ctrls = Frame(f)
grid(ctrls, 1, 2, sticky="sw", pady=5, padx=5)
grid_columnconfigure(f, 1, weight=1)
grid_rowconfigure(f, 1, weight=1)

e1 = Entry(ctrls)
ok = Button(ctrls, "OK")
formlayout(e1,"Number of cells:")
formlayout(ok,nothing)

#grid(ok, 1, 1)

# plot sin
x = [1:pi/100:4*pi]
y = sin(x)
graph(c,x,y,"red")
pause(0)

#plot cos
y = cos(x)
graph(c,x,y,"blue")




if !isinteractive()
  pause(0,"any key to close program")
end
