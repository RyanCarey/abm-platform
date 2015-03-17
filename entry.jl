include("import.jl")

function ok_press(window::Tk.Tk_Toplevel, canvas::Tk.Canvas, frame::Tk.Tk_Frame, v::Vector, v2::Vector,v8::Matrix,
                  v9::Matrix{Any},v10::Vector{AbstractString},display_output::Bool,
                  pickle_output::Bool, entries::Vector{Tk.Tk_Entry}, prompts::Vector,
                  rb_value::Vector{ASCIIString},diff_type::ASCIIString)
  check_entries(v, prompts, entries)

  # set variables
  n_cell = int(v[1])
  const steps = int(v[2])
  x_size = float(v[3])
  y_size = float(v[4])
  g=float(v[5])
  categories = Cell_type[
          Cell_type(v8[1,1], v8[1,2], v8[1,3], v8[1,4], v8[1,5], v8[1,6], v8[1,7], v8[1,8], v8[1,9], v8[1,10], v8[1,11],v8[1,12],
                    v9[1,1], v9[1,2], v9[1,3], v9[1, 4]),
          Cell_type(v8[2,1], v8[2,2], v8[2,3], v8[2,4], v8[2,5], v8[2,6], v8[2,7], v8[2,8], v8[2,9], v8[2,10], v8[2,11],v8[2,12],
                    v9[2,1], v9[2,2], v9[2,3], v9[2, 4]),
          Cell_type(v8[3,1], v8[3,2], v8[3,3], v8[3,4], v8[3,5], v8[3,6], v8[3,7], v8[3,8], v8[3,9], v8[3,10], v8[3,11],v8[3,12],
                    v9[3,1], v9[3,2], v9[3,3], v9[3, 4]),
          Cell_type(v8[4,1], v8[4,2], v8[4,3], v8[4,4], v8[4,5], v8[4,6], v8[4,7], v8[4,8], v8[4,9], v8[4,10], v8[4,11],v8[4,12],
                    v9[4,1], v9[4,2], false, v9[4, 4])]
  border_settings = [lowercase(v10[1]),lowercase(v10[2]),lowercase(v10[3]),lowercase(v10[4])]
  global const nb_ligands= int(v2[2])
  global const nb_source= int(v2[7])
  global source_abscisse_ligand =Array(Float64,nb_source)
  global source_ordinate_ligand =Array(Float64,nb_source)
  global Diffusion_coefficient = Array(Float64,nb_source)
  global A_coefficient= Array(Float64,nb_source)
  global tau0 = Array(Float64,nb_source)
  global diffusion_maximum = Array(Float64,nb_source)
  global diffusion_coefficient = Array(Float64,nb_source)
  global type_source=rb_value[1]
  global type_diffusion=diff_type

  if(type_source=="Point")	
    for i in 1:nb_source
      source_abscisse_ligand[i]=v3p[2*i-1]
      source_ordinate_ligand[i]=v3p[2*i]
      if(type_diffusion == "Integrative")
        Diffusion_coefficient[i] =v4[3*i-2]
        A_coefficient[i] = v4[3*i-1]
        tau0[i] = v4[3*i]
      else
        diffusion_maximum[i] =v5[2*i-1]
        diffusion_coefficient[i] = v5[2*i]
      end
    end
  else
    for i in 1:nb_source
      source_abscisse_ligand[i]=v3l[i]
      if(type_diffusion == "Integrative")
        Diffusion_coefficient[i] =v4[3*i-2]
        A_coefficient[i] = v4[3*i-1]
        tau0[i] = v4[3*i]
      else
        diffusion_maximum[i] =v5[2*i-1]
        diffusion_coefficient[i] = v5[2*i]
      end
    end
  end

  println("Building Environment")
  alive_cells = Cell[] 
  alive_cells = initial_placement(n_cell, categories, x_size, y_size)
  dead_cells = Cell[]

  if display_output
    canvas[:height] = 400
    canvas[:width] = 400 * x_size/y_size
    window[:width] = 400 + int(canvas[:width])
    pack(frame, expand=true, fill="both")
    show_sim(canvas, alive_cells, categories, x_size, y_size)
  end

  t = strftime(time())[5:27] #store date and time as string
  filename = "out_$t.pickle"
  if pickle_output
    pickle_start(filename, t, n_cell, steps, x_size, y_size, nb_ligands, nb_source, source_abscisse_ligand,
                 source_ordinate_ligand, v3p, v4, v8, v9, alive_cells)
  end

  simulator(canvas, alive_cells, dead_cells, categories, steps, display_output, pickle_output, 
            filename, x_size, y_size, border_settings,g)
end

##########################################################################################################
function check_entries(v::Vector, prompts::Vector, entries::Vector)
  # sanitises input data and stores in an array of floats
  for i in 1:length(prompts)
    if prompts[i][1:10]=="Probability" || prompts[i][end-4:end]=="(0-1)"
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
      Messagebox(title="Warning", message=string("Must enter a numeric for field ", string(prompts[i])))
      return
    end
  end
end

##########################################################################################################
function init_window()
  println("Starting up window...")
  # window parameters
  window = Toplevel("Agent-based modeller",350,385)
  frame = Frame(window); pack(frame, expand=true, fill="both")
  canvas = Canvas(frame, 0, 0)
  grid(canvas, 1, 2, sticky="nsew")
  ctrls = Frame(frame)
  grid(ctrls, 1, 1, sticky="sw", pady=5, padx=5)
  grid_columnconfigure(frame, 1, weight=1)
  grid_rowconfigure(frame, 1, weight=1)

  # set defaults    
  v = Float64[10, 300, 30, 30,0.9]
  v2=Float64[8, 100, 1, 10, 1,100,1]
  global rb_value=["Line"]
  global v3p=Array(Float64,2*int(v2[5]))
  global v3l=Array(Float64,int(v2[5]))
  global v4=Array(Float64,3*int(v2[5]))
  global v5=Array(Float64,2*int(v2[5]))
  for i in 1:v2[5]
    v3p[2*i-1]=0
    v3p[2*i]=0
    v3l[i]=0
    v4[3*i-2]=100
    v4[3*i-1]=1
    v4[3*i]=10
    v5[2*i-1]=100
    v5[2*i]=1
  end
  v8 = Float64[1.0  0.05  2.0  1.0  1.0  1.0  1.5  .0001  .5  .5  .1  1.05;
               0.0  0.05  2.0  1.0  1.0 -1.0  1.5  .0001  .5  .5  .1  1.05;
               0.0  0.05  2.0  1.0  1.0  1.0  1.5  .0001  .5  .5  .1  1.05;
               0.0  0.05  2.0  1.0  1.0  1.0  1.5  .0001  .5  .5  .1  1.05]

  v9 = ["ro" false true false;"bo" false false false;"mo" false false false;"go" false false false]
  v10 = String["Reflecting","Reflecting","Reflecting","Reflecting"]

  # make and activate controls
  prompts = String["Number of cells", "Number of timesteps ", "Width of environment",
             "Height of environment ","Loss energy coefficient when cells bounce"]

  # make the input fields 
  entries1 = Entry(ctrls, "$(int(v[1]))") 
  entries2 = Entry(ctrls, "$(int(v[2]))")
  entries3 = Entry(ctrls, "$(v[3])")
  entries4 = Entry(ctrls, "$(v[4])")
  entries5 = Entry(ctrls, "$(v[5])")

  entries = [entries1,entries2,entries3,entries4,entries5]

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
    bind(b,i,path -> ok_press(window, canvas, frame, v, v2, v8, v9, v10, get_value(display_status), 
    get_value(pickle_status), entries, prompts,rb_value,get_value(rb2)))
  end

  #=
  bq = Button (ctrls, "Quit")
  formlayout(bq, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
    bind(bq,i,path -> destroy(window))
  end
  =#

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

function pause(pause_time::Real,message::String = "anykey to advance timestep")
  #pauses for pause_time milliseconds
  if time==0
    println(message)
    junk = readline(STDIN)
  else
    sleep(time)
  end
end

#run program

init_window()
