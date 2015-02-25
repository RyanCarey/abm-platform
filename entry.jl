include("import.jl")

##########################################################################################################
function ok_press(v::Array, v2::Array,v8::Array,v9::Array,v10::Array,display_output::Bool,txt_output::Bool, entries, prompts)
  v = check_entries1(v, entries, prompts)
	v3=Array(Float64,2*int(v2[7]))
	v4=Array(Float64,3*int(v2[7]))
	for i in 1:v2[7]
		v3[2*i-1]=0
		v3[2*i]=(i-1)/(v2[7]-1)*v[4]
		v4[3*i-2]=10
 		v4[3*i-1]=100
 		v4[3*i]=150	
  end
  main(v,v2,v3,v4,v8,v9,v10,display_output,txt_output)
end

##########################################################################################################
function check_entries1(v::Array, entries::Array, prompts::Array)
  n = length(prompts)
  v = Array(Float64,n)
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
  return v
end
##########################################################################################################
function init_window()
  println("starting up window...")
  # window parameters
  global w = Toplevel("Agent-based modeller",350,385)
  global frame = Frame(w); pack(frame, expand=true, fill="both")
  global canvas = Canvas(frame, 0, 0)
  grid(canvas, 1, 2, sticky="nsew")
  ctrls = Frame(frame)
  grid(ctrls, 1, 1, sticky="sw", pady=5, padx=5)
  grid_columnconfigure(frame, 1, weight=1)
  grid_rowconfigure(frame, 1, weight=1)

  # set defaults        
  v = Float64[10,1000,30,30,1.5,.001]
  v2 = Float64[0.5,8,0.5,10,100,150,4]
  v8 = Float64[1.0,0.05,2.0,1.0,1.0,1.0,0.0,0.05,2.0,1.0,1.0,-1.0,0.0,0.05,2.0,1.0,1.0,1.0,0.0,0.05,2.0,1.0,1.0,1.0,.5,.5,.5,.5]
  v9 = ["ro",true,true,"bo",false,false,"mo",false,false,"go",false,false]
  v10 = String["Reflecting","Reflecting","Reflecting","Reflecting"]

  # make and activate controls
  prompts = ["Number of cells", "Number of timesteps ", "Width of environment",
             "Height of environment ", "Stem Threshold", "Probability of cell death"]

  # make the input fields 
  entries1 = Entry(ctrls, "$(Int(v[1]))")
  entries2 = Entry(ctrls, "$(Int(v[2]))")
  entries3 = Entry(ctrls, "$(v[3])")
  entries4 = Entry(ctrls, "$(v[4])")
  entries5 = Entry(ctrls, "$(v[5])")
  entries6 = Entry(ctrls, "$(v[6])")
  entries = [entries1,entries2,entries3,entries4,entries5,entries6]

  for i in 1:length(prompts)
    formlayout(entries[i],string(prompts[i],": "))
    #bind(entries[i], "<Return>", ok_press)
    #bind(entries[i], "<KP_Enter>", ok_press)
  end
  focus(entries[1])
  
  # globals - should be removed asap
  global check_location = false
  global type_source = "Point"

  b2 = Button(ctrls, "Choose diffusion params")
  formlayout(b2, nothing)
  bind(b2, "command", path -> window_diffusion(v,v2, entries, prompts))

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

	# make, display and sensitise the 'run' button
  b = Button(ctrls, "Run")
  # displays the button
  formlayout(b, nothing)

  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b,i,path -> ok_press(v, v2, v8, v9, v10, get_value(display_status), get_value(txt_status), entries, prompts))
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
