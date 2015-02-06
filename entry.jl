using Tk
using Winston
include("pause.jl")
include("simulator.jl")
include("show.jl")
include("diffusion.jl")

# TO DO :
# Problems with the call of the global values, put a default setting
# Define properly the size of the distance from source (200 now)
# More than one source
# Adapt the size of the canvas

function simulate2(path)
  n2 = length(prompts2)
  global v2 = zeros(n2,1)
  for i in 1:n2
    try
      v2[i] = float(get_value(entries2[i]))
    catch
      Messagebox(title="Warning", message=string("Must enter a numeric for field ", string(prompts2[i])))
      return
    end
  end
  destroy(w2) 
end

##########################################################################################################
function simulate3(path)
  result = Array(Float64,100,1)
  for x in 1:100
  	global distance_source_squared = int(x)
	timediff = get_value(sc)	
	tau0 = int(get_value(entries2[6]))
  	(res,tmp)=quadgk(integrand,0,min(timediff,tau0))
	result[x]=res
  end
  p=plot(result)
  xlabel("Distance from source")
  ylabel("Concentration")
  display(canvas2,p)
  
end
##########################################################################################################

function integrand(tau)
	timediff = get_value(sc)
	A=int(get_value(entries2[5]))
	D=int(get_value(entries2[4]))
	result = A*exp(-distance_source_squared/(4*D*(timediff-tau)))/(4*D*timediff*pi)
	return result
end
##########################################################################################################
function callback(path)
  global w2 = Toplevel("Diffusion Parameters",350,385) ## title, width, height
  global f2 = Frame(w2) 
  pack(f2, expand=true, fill="both")
  global canvas2 = Canvas(f2, 300, 300)
  grid(canvas2, 1, 2, sticky="news")
  ctrls2 = Frame(f2)
  grid(ctrls2, 1, 1, sticky="nw", pady=5, padx=5)
  grid_columnconfigure(f2, 1, weight=1)
  grid_rowconfigure(f2, 1, weight=1)

  global prompts2 =["X ordinate of the injury","Y ordinate of the injury","Probability of persistance","D diffusion coefficient","A diffusion coefficient","Tau coefficient (maximum intergration time)","Choose the numbers of direction for a cell"]
  n2=length(prompts2)
  entries21 = Entry(ctrls2)
  entries22 = Entry(ctrls2)
  entries23 = Entry(ctrls2)
  entries24 = Entry(ctrls2)
  entries25 = Entry(ctrls2)
  entries26 = Entry(ctrls2)
  entries27 = Entry(ctrls2)

  
  global entries2 = [entries21,entries22,entries23,entries24,entries25,entries26,entries27]
  for i in 1:n2
    formlayout(entries2[i],string(prompts2[i],": "))
    bind(entries2[i], "<Return>", simulate2)
    bind(entries2[i], "<KP_Enter>", simulate2)
  end
  focus(entries2[1]) 
  

  #f3 = Frame(w2); pack(f3, expand = true, fill = "both")
  grid(Label(f2, "Move the cursor to plot the diffusion over time"), 2, 1)
  global sc = Slider(f2, 1:200)
  l = Label(f2)
  l[:textvariable] = sc[:variable]
  grid(sc, 3, 1, sticky="ew")
  grid(l,  4, 1, sticky="w")
  bind(sc, "command", simulate3)

  b = Button(ctrls2, "Simulate diffusion")
  # displays the button
  formlayout(b, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
     bind(b,i,simulate3)
  end
  b2 = Button(ctrls2, "Ok")
  # displays the button
  formlayout(b2, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
     bind(b2,i,simulate2)
  end

end

##########################################################################################################
function simulate(path)
  # store entry field data
  n = length(prompts)
  global v = zeros(n,1)
  for i in 1:n
    if prompts[i][1:11]=="Probability" || prompts[i][end-4:end]=="(0-1)"
      if !(0 <= float(get_value(entries[i])) <= 1)
        Messagebox(title="Warning", message=string(string(prompts[i])," must be between 0 and 1"))
        return
      end
    end
    if prompts[i][1:8]=="Abscisse" 
      if !(0 <= float(get_value(entries[i])) <= v[5])
        Messagebox(title="Warning", message=string(string(prompts[i])," must be between 0 and width"))
        return
      end
    end
    if prompts[i][1:8]=="Ordinate" 
      if !(0 <= float(get_value(entries[i])) <= v[6])
        Messagebox(title="Warning", message=string(string(prompts[i])," must be between 0 and height"))
        return
      end
    end     
    if prompts[i][1:9]=="Diffusion" 
      if !(0 <= float(get_value(entries[i])))
        Messagebox(title="Warning", message=string(string(prompts[i])," must be positive"))
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
  global prompts = ["Number of cells", "Speed of cells (~1)", "Average cell radius (~1)", "Number of timesteps (~100)", 
    "Width of environment (~20)", "Height of environment (~20)", "Probability of cell division", "Probability of cell death"
    ]       #"persistence of cell movement (0-1)", "relative weight on bias (0-1)"]
  n = length(prompts)
  global entries = []

  # make the input fields 
  entries1 = Entry(ctrls)
  entries2 = Entry(ctrls)
  entries3 = Entry(ctrls)
  entries4 = Entry(ctrls)
  entries5 = Entry(ctrls)
  entries6 = Entry(ctrls)
  entries7 = Entry(ctrls)
  entries8 = Entry(ctrls)

  entries = [entries1,entries2,entries3,entries4,entries5,entries6,entries7,entries8]
  for i in 1:n
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

  #Choose diffusion parameters
  b2 = Button(ctrls, "Change Diffusion Coefficient")
  formlayout(b2, nothing)
  bind(b2, "command", callback) 

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
