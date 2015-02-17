using Tk
using Winston
include("pause.jl")
include("simulator.jl")
include("show.jl")
include("diffusion_window.jl")
include("categories_window.jl")

# TO DO :
# Adapt the size of the canvas
# Lower the cost of integration
# Understabnd why v2[4] is 10 digit when modifying again the diffusion parameters

##########################################################################################################
function simulate(path)
  check_entries1()
  # store combobox data
  border_choice = get_value(cb)
  global BORDER_BEHAVIOUR = border_choice
  shape_choice = get_value(cb2)
  global BORDER_SHAPE = shape_choice
  # store checkbox data
  global DISPLAY_OUTPUT  = get_value(display_option)
  global TXT_OUTPUT = get_value(txt_option)

  if (!check_diffusion)
		global v2=[0.5,8,1,10,100,150,4]
  end
  if (!check_location)
		global v3=Array(Float64,2*int(v2[7]))
		global v4=Array(Float64,3*int(v2[7]))
		for i in 1:int(v2[7])
			v3[2*i-1]=0
			v3[2*i]=(i-1)/(v2[6]-1)*v[6]

			v4[3*i-2]=10
  		v4[3*i-1]=100
  		v4[3*i]=150		
		end
	end
	if (!changed_cell_type)
		global v8 = [1.0,0.05,2.0,1.0,1.0,1.0,0.0,0.05,2.0,1.0,1.0,-1.0,0.0,0.05,2.0,1.0,1.0,1.0,0.0,0.05,2.0,1.0,1.0,1.0]
		global v9 = ["r",true,true,"b",false,false,"m",false,false,"g",false,false]
	end
  
  main()
end

##########################################################################################################
function check_entries1()
  n = length(prompts)
  global v = zeros(n,1)
  for i in 1:n
    if prompts[i][1:10]=="Probabilit" || prompts[i][end-4:end]=="(0-1)"
      if !(0 <= float(get_value(entries[i])) <= 1)
        Messagebox(title="Warning", message=string(string(prompts[i])," must be between 0 and 1"))
        return
      end
    end
    if !(0 <= float(get_value(entries[i])))
        Messagebox(title="Warning", message=string(string(prompts[i])," must be positive"))
        return
    end
    try
			v[i] = float(get_value(entries[i]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts[i])))
      return
    end
  end
end
   
##########################################################################################################
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
  global prompts = ["Number of cells", "Number of timesteps ", "Width of environment",
                    "Height of environment ", "Stem Threshold", "Probability of cell death"]
  n = length(prompts)
  global entries = []

  # make the input fields 
  entries1 = Entry(ctrls)
  entries2 = Entry(ctrls)
  entries3 = Entry(ctrls)
  entries4 = Entry(ctrls)
  entries5 = Entry(ctrls)
  entries6 = Entry(ctrls)
  set_value(entries1, "10")
  set_value(entries2, "300")
  set_value(entries3, "30")
  set_value(entries4, "30")
  set_value(entries5, "1.5")
  set_value(entries6, "0.001")  
  entries = [entries1,entries2,entries3,entries4,entries5,entries6]

  for i in 1:n
    formlayout(entries[i],string(prompts[i],": "))
    #bind(entries[i], "<Return>", simulate)
    #bind(entries[i], "<KP_Enter>", simulate)
  end
  focus(entries[1])
  
  # Check if the diffusion coefficient has been modified	
  global check_diffusion = false
  global check_location = false
  global changed_cell_type = false

  # make comboboxes
  boundary_options = ["Reflecting","Absorbing","Killing"]
  global cb = Combobox(ctrls, boundary_options)
  formlayout(cb,"Boundary Behaviour")
  set_value(cb, 1)
  boundary_shape = ["Rectangle","Ellipse"]
  global cb2 = Combobox(ctrls, boundary_shape)
  formlayout(cb2,"Boundary Shape")
  set_value(cb2, 1)

  #Choose diffusion parameters
  b2 = Button(ctrls, "Choose diffusion params")
  formlayout(b2, nothing)
  bind(b2, "command", window_diffusion)

  b3 = Button(ctrls, "Edit Cell Types")
  formlayout(b3, nothing)
  bind(b3, "command", get_categories)

  # make checkbuttons
  global display_option = Checkbutton(ctrls, "Display Simulation")
  set_value(display_option, true)
  global txt_option = Checkbutton(ctrls, "Write to text")
  formlayout(display_option, nothing)
  formlayout(txt_option, nothing)
 # set_value(display_option, 1)

	# make, display and sensitise the 'run' button
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
