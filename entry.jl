include("import.jl")

##########################################################################################################
function ok_press(v::Array, v2::Array,v8::Array,v9::Array,v10::Array,display_output::Bool,pickle_output::Bool, entries, prompts,rb_value,diff_type)
  check_entries1(v, prompts, entries)

  # set variables
  n_cell = int(v[1])
  const steps = int(v[2])
  global X_SIZE = v[3]
  global Y_SIZE = v[4]
  global STEM_THRESHOLD = v[5]
  global DIE_THRESHOLD = v[6]
  global categories = Cell_type[Cell_type(v8[1], v8[2], v8[3], v8[4], v8[5], v8[6], v8[25], v9[1], v9[2], v9[3]),
                      Cell_type(v8[7], v8[8], v8[9], v8[10], v8[11], v8[12], v8[26], v9[4], v9[5], v9[6]),
                      Cell_type(v8[13], v8[14], v8[15], v8[16], v8[17], v8[18], v8[27], v9[7], v9[8], v9[9]),
                      Cell_type(v8[19], v8[20], v8[21], v8[22], v8[23], v8[24], v8[28], v9[10], v9[11], v9[12])]
  global border_settings = [lowercase(v10[1]),lowercase(v10[2]),lowercase(v10[3]),lowercase(v10[4])]
  global const probability_persistent=v2[1]
  global const nb_ligands= int(v2[2])
  global const nb_source= int(v2[7])
  global source_abscisse_ligand =Array(Float64,nb_source)
  global source_ordinate_ligand =Array(Float64,nb_source)
  global Diffusion_coefficient = Array(Float64,nb_source)
  global A_coefficient= Array(Float64,nb_source)
  global tau0 = Array(Float64,nb_source)
  global diffusion_maximum = Array(Float64,nb_source)
  global speed_variance = Array(Float64,nb_source)
  global initial_variance = Array(Float64,nb_source)
  global type_source=rb_value[1]
  global type_diffusion=diff_type


  if(type_source=="Point")	
    for i in 1:nb_source
      source_abscisse_ligand[i]=v3[2*i-1]
      source_ordinate_ligand[i]=v3[2*i]
      if(type_diffusion == "Integrative")
        Diffusion_coefficient[i] =v4[3*i-2]
        A_coefficient[i] = v4[3*i-1]
        tau0[i] = v4[3*i]
      else
        diffusion_maximum[i] =v5[3*i-2]
        speed_variance[i] = v5[3*i-1]
        initial_variance[i] = v5[3*i]
      end
    end
  else
    for i in 1:nb_source
      source_abscisse_ligand[i]=v3[i]
      if(type_diffusion == "Integrative")
        Diffusion_coefficient[i] =v4[3*i-2]
        A_coefficient[i] = v4[3*i-1]
        tau0[i] = v4[3*i]
      else
        diffusion_maximum[i] =v4[3*i-2]
        speed_variance[i] = v4[3*i-1]
        initial_variance[i] = v4[3*i]
      end
    end
  end



  println("building environment")
  alive_cells = Cell[] 
  alive_cells = init(n_cell, categories)
  global dead_cells = Cell[]

  if display_output
    canvas[:height] = 400
    canvas[:width] = 400 * X_SIZE/Y_SIZE
    w[:width] = 400 + int(canvas[:width])
    pack(frame, expand=true, fill="both")
    show_sim(alive_cells)
  end

  t = strftime(time())[5:27] #store date and time as string
  filename = "out_$t.pickle"
  if pickle_output
    pickle_start(filename, t, v, v2, v3, v4, v8, v9, border_settings, alive_cells)
  end

  simulator(alive_cells, dead_cells, steps, display_output, pickle_output, filename)
end

##########################################################################################################
function check_entries1(v::Array, prompts::Array, entries::Array)
  for i in 1:length(prompts)
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
  v = [10, 300, 30, 30, 1.5, 0.000]
  v2=[0.5, 8, 1, 10, 100, 150, 1,10,10,0.1]
  global rb_value=["Line"]
  global check_location = false
  global v3=Array(Float64,2*int(v2[7]))
  global v4=Array(Float64,3*int(v2[7]))
  global v5=Array(Float64,3*int(v2[7]))
  for i in 1:v2[7]
    v3[2*i-1]=0
    v3[2*i]=(i-1)/(v2[7]-1)*v[4]
    v4[3*i-2]=10
    v4[3*i-1]=100
    v4[3*i]=150	
    v5[3*i-2]=10
    v5[3*i-1]=10
    v5[3*i]=0.1	
  end
  v8 = Float64[1.0,0.05,2.0,1.0,1.0,1.0,0.0,0.05,2.0,1.0,1.0,-1.0,0.0,0.05,2.0,1.0,1.0,1.0,0.0,0.05,2.0,1.0,1.0,1.0,.5,.5,.5,.5]
  v9 = ["ro",false,true,"bo",false,false,"mo",false,false,"go",false,false]
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

  rb2 = Radio(ctrls, ["Integrative", "Normal"])
  formlayout(rb2, "Type of diffusion: ")

  b2 = Button(ctrls, "Diffusion Settings")
  formlayout(b2, nothing)
  bind(b2, "command", path -> gui_diffusion(v,v2, prompts, entries,rb_value,get_value(rb2)))

  b3 = Button(ctrls, "Cell Type Settings")
  formlayout(b3, nothing)
  bind(b3, "command", path -> gui_type(v8,v9))

  b4 = Button(ctrls, "Border Settings")
  formlayout(b4, nothing)
  bind(b4, "command", path -> gui_border(v, v10, prompts, entries))

  # make checkboxes
  display_status = Checkbutton(ctrls, "Display Simulation")
  set_value(display_status, true)
  pickle_status = Checkbutton(ctrls, "Write to pickle")
  formlayout(display_status, nothing)
  formlayout(pickle_status, nothing)

  # make, display and sensitise the 'run' button
  b = Button(ctrls, "Run")
  # displays the button
  formlayout(b, nothing)

  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b,i,path -> ok_press(v, v2, v8, v9, v10, get_value(display_status), get_value(pickle_status), entries, prompts,rb_value,get_value(rb2)))
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
