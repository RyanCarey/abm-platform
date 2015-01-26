using Tk
include("pause.jl")
include("master_file.jl")
include("show.jl")

function simulate(path)
  n = length(prompts)
  for i in 1:n
    try
      v[i] = float(get_value(entries[i]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts[i])[1:end-2]))
      return
    end
  end
  println("variables stored")
  main()
end

function init_window()
  global entries = []
  global prompts = ["Number of cells: ", "Speed of cells: ", "Average cell radius: ", "Number of timesteps: ", 
  "Width of environment: ", "Height of environment: "]
  field_length = length(prompts)
  global v = zeros(field_length,1)
  n = length(prompts)

  for i in 1:n
    push!(entries, Entry(ctrls))
  end
  b = Button(ctrls, "Run")

  for i in 1:n
    formlayout(entries[i],prompts[i])
  end
  formlayout(b, nothing)
  focus(entries[1])

  bind(b,"command", simulate)
  bind(b,"<Return>", simulate)
  bind(b,"<KP_Enter>", simulate)
  for i in 1:n
    bind(entries[i], "<Return>", simulate)
    bind(entries[i], "<KP_Enter>", simulate)
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
end


w = Toplevel("Testing", 700, 400)
f = Frame(w); pack(f, expand=true, fill="both")
global c = Canvas(f, 400, 400)

grid(c, 1, 1, sticky="nsew")
ctrls = Frame(f)
grid(ctrls, 1, 2, sticky="sw", pady=5, padx=5)
grid_columnconfigure(f, 1, weight=1)
grid_rowconfigure(f, 1, weight=1)


#grid(ok, 1, 1)

# plot sin
x = [1:pi/100:4*pi]
y = sin(x)

p = FramedPlot()
Winston.display(c, p)

init_window()
