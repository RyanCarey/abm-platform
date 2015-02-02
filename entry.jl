using Tk
include("pause.jl")
include("simulator.jl")
include("show.jl")

function simulate(path)
  # store entry field data
  n = length(prompts)
  global v = zeros(n,1)
  for i in 1:n
    if startswith(prompts[i],"Probability") || endswith(prompts[i],"(0-1)")
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
  end
  # store combobox data
  border_choice = get_value(cb)
  global BORDER_BEHAVIOUR = (border_choice == "Reflecting" ? "Bounce" : "Stick")
  shape_choice = get_value(cb2)
  global ELLIPTICAL_BORDER = (shape_choice == "Rectangle" ? false : true)
  # store checkbox data
  global DISPLAY_OUTPUT  = get_value(display_option)
  global TXT_OUTPUT = get_value(txt_option)
  main()
end

function init_window()
  # window parameters
  global w = Toplevel("Agent-based modeller",350,385)
  global frame = Frame(w); pack(frame, expand=true, fill="both")
  global canvas = Canvas(frame, 0, 0)
  grid(canvas, 1, 2, sticky="nsew")
  ctrls = Frame(frame)
  grid(ctrls, 1, 1, sticky="sw", pady=5, padx=5)
  grid_columnconfigure(frame, 1, weight=1)
  grid_rowconfigure(frame, 1, weight=1)
  #grid(ok, 1, 1)

  # make and activate controls
  global prompts = ["Number of cells", "Speed of cells (~1)", "Average cell radius (~1)", "Number of timesteps (~100)", 
    "Width of environment (~20)", "Height of environment (~20)", "Probability of cell division", "Probability of cell death",
    ]       #"persistence of cell movement (0-1)", "relative weight on bias (0-1)"]
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

  # make comboboxes
  boundary_options = ["Reflecting","Absorbing"]
  global cb = Combobox(ctrls, boundary_options)
  formlayout(cb,"Reflecting or absorbing edges?")
  boundary_shape = ["Rectangle","Ellipse"]
  global cb2 = Combobox(ctrls, boundary_shape)
  formlayout(cb2,"Boundary Shape")

  # make checkbuttons
  global display_option = Checkbutton(ctrls, "display simulation")
  global txt_option = Checkbutton(ctrls, "write to txt")
  formlayout(display_option, nothing)
  formlayout(txt_option, nothing)

	# make, display and sensitise the button
  b = Button(ctrls, "Run")
  # displays the button
  formlayout(b, nothing)
  for i in ["command","<Return>","<KP_Enter>"] bind(b,i,simulate)
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
