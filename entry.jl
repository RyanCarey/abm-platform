#using Tk
#using Winston
#include("pause.jl")
#include("simulator.jl")
#include("show.jl")
#include("diffusion_window.jl")
#include("categories_window.jl")
#include("cell_type.jl")
include("import.jl")
# TO DO :
# Adapt the size of the canvas
# Lower the cost of integration
# Understabnd why v2[4] is 10 digit when modifying again the diffusion parameters

##########################################################################################################
function ok_press(v::Array,v2::Array,v3::Array,v4::Array,v8::Array,
                  v9::Array,v10::Array,display_output::Bool,txt_output::Bool)
  n = length(prompts)
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
  main(v,v2,v3,v4,v8,v9,v10,display_output,txt_output)
end

##########################################################################################################
function init_window()
println("starting program")
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
    #bind(entries[i], "<Return>", ok_press)
    #bind(entries[i], "<KP_Enter>", ok_press)
  end
  focus(entries[1])
  
  # Check if the diffusion coefficient has been modified	
  global check_diffusion = false
  global check_location = false
  global changed_cell_type = false

  # make comboboxes

  #Choose diffusion parameters
  b2 = Button(ctrls, "Choose diffusion params")
  formlayout(b2, nothing)
  bind(b2, "command", window_diffusion)

  b3 = Button(ctrls, "Edit Cell Types")
  formlayout(b3, nothing)
  bind(b3, "command", path -> get_categories(v8,v9))

  b4 = Button(ctrls, "Edit Border Types")
  formlayout(b4, nothing)
  bind(b4, "command", path -> get_borders(v10))

  # make checkbuttons
  display_status = Checkbutton(ctrls, "Display Simulation")
  set_value(display_status, true)
  txt_status = Checkbutton(ctrls, "Write to text")
  formlayout(display_status, nothing)
  formlayout(txt_status, nothing)
  # set_value(display_status, 1)

	# make, display and sensitise the 'run' button
  b = Button(ctrls, "Run")
  # displays the button
  formlayout(b, nothing)
  v = zeros(n,1)

  # set defaults
	v2=[0.5,8,1,10,100,150,4]
	v3=Array(Float64,2*int(v2[7]))
	v4=Array(Float64,3*int(v2[7]))
  v8 = [1.0,0.05,2.0,1.0,1.0,1.0,0.0,0.05,2.0,1.0,1.0,-1.0,0.0,0.05,2.0,1.0,1.0,1.0,0.0,0.05,2.0,1.0,1.0,1.0,.5,.5,.5,.5]
  v9 = ["ro",true,true,"bo",false,false,"mo",false,false,"go",false,false]
  v10 = ["Absorbing","Killing","Killing","Killing"]
	for i in 1:int(v2[7])
		v3[2*i-1]=0
		v3[2*i]=(i-1)/(v2[6]-1)*v[5]
		v4[3*i-2]=10
 		v4[3*i-1]=100
 		v4[3*i]=150		
  end

  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b,i,path -> ok_press(
                     v::Array,
                     v2::Array,
                     v3::Array,
                     v4::Array,
                     v8::Array,
                     v9::Array,
                     v10::Array,
                     get_value(display_status),
                     get_value(txt_status)))
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
