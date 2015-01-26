using Tk
include("pause.jl")
include("master_file.jl")
include("show.jl")

function simulate(path)
  n = length(prompts)
  global v = zeros(n,1)
  for i in 1:n
    try
      v[i] = float(get_value(entries[i]))
      p = FramedPlot()
      Winston.display(c, p)
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts[i])[1:end-2]))
      return
    end
  end
  main()
end

function init_window()
  # window parameters
  w = Toplevel("Testing", 700, 400)
  f = Frame(w); pack(f, expand=true, fill="both")
  global c = Canvas(f, 400, 400)
  grid(c, 1, 1, sticky="nsew")
  ctrls = Frame(f)
  grid(ctrls, 1, 2, sticky="sw", pady=5, padx=5)
  grid_columnconfigure(f, 1, weight=1)
  grid_rowconfigure(f, 1, weight=1)
  #grid(ok, 1, 1)


  # make and activate controls
  global prompts = ["Number of cells: ", "Speed of cells: ", "Average cell radius: ", "Number of timesteps: ", 
  "Width of environment: ", "Height of environment: "]
  n = length(prompts)
  global entries = []

  # make the input fields 
  for i in 1:n
    push!(entries, Entry(ctrls))
    formlayout(entries[i],prompts[i])
    bind(entries[i], "<Return>", simulate)
    bind(entries[i], "<KP_Enter>", simulate)
  end
  focus(entries[1])

  # make, sensitise and display the button
  b = Button(ctrls, "Run")
  # displays the button
  formlayout(b, nothing)
  for i in ["command","<Return>","<KP_Enter>"]
    bind(b,i,simulate)
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




init_window()
