using Tk
include("pause.jl")
include("simulator.jl")
include("show.jl")

function simulate(path)
  # store entry field data
  n = length(prompts)
  global v = zeros(n,1)
  for i in 1:n
    if startswith(prompts[i],"Probability")
      if !(0 <= float(get_value(entries[i])) <= 1)
        Messagebox(title="Warning", message=string(string(prompts[i])," must be between 0 and 1"))
        return
      end
    end
    try
			v[i] = float(get_value(entries[i]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts[i])))
      return
    end
    p = FramedPlot()
    Winston.display(c, p)
  end
  # store combobox data
  border_choice = get_value(cb)
  global BORDER_BEHAVIOUR = (border_choice == "Reflecting" ? "Bounce" : "Stick")
  # store checkbox data
  global DISPLAY_OUTPUT  = get_value(display_option)
  global TXT_OUTPUT = get_value(txt_option)
  main()
end

function init_window()
  # window parameters
  w = Toplevel("Testing", 700, 400)
  f = Frame(w); pack(f, expand=true, fill="both")
  global c = Canvas(f, 400, 400)
  grid(c, 1, 2, sticky="nsew")
  ctrls = Frame(f)
  grid(ctrls, 1, 1, sticky="sw", pady=5, padx=5)
  grid_columnconfigure(f, 1, weight=1)
  grid_rowconfigure(f, 1, weight=1)
  #grid(ok, 1, 1)

  # make and activate controls
  global prompts = ["Number of cells", "Speed of cells", "Average cell radius", "Number of timesteps", 
  "Width of environment", "Height of environment", "Probability of cell division", "Probability of cell death"]
  n = length(prompts)
  global entries = []

  # make the input fields 
  for i in 1:n
    push!(entries, Entry(ctrls))
    formlayout(entries[i],string(prompts[i],": "))
    bind(entries[i], "<Return>", simulate)
    bind(entries[i], "<KP_Enter>", simulate)
  end
  focus(entries[1])

  # make combobox
  boundary_options = ["Reflecting","Absorbing"]
  global cb = Combobox(ctrls, boundary_options)
  formlayout(cb,"Reflecting or absorbing edges?")

  # make checkbuttons
  global display_option = Checkbutton(ctrls, "display simulation")
  global txt_option = Checkbutton(ctrls, "write to txt")
  formlayout(display_option, nothing)
  formlayout(txt_option, nothing)

	# make, display and sensitise the button
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
