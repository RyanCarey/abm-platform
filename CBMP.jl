include("import.jl")

function ok_press(window::Tk.Tk_Toplevel, canvas::Tk.Canvas, frame::Tk.Tk_Frame, v::Vector, v2::Vector,v8::Matrix,
                  v9::Matrix{Any},v10::Vector{String},display_output::Bool,
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
  global const n_receptors= int(v2[2])
  global const nb_source= int(v2[7])
  global source_x_ord =Array(Float64,nb_source)
  global source_y_ord =Array(Float64,nb_source)
  global integration_diffusion_coefficient = Array(Float64,nb_source)
  A_coefficients = Array(Float64,nb_source)
  global tau0 = Array(Float64,nb_source)
  global diffusion_maximum = Array(Float64,nb_source)
  diffusion_coefficients = Array(Float64,nb_source)
  global type_source=rb_value[1]
  global type_diffusion=diff_type

  if(type_source=="Point")	
    for i in 1:nb_source
      source_x_ord[i]=v3p[2*i-1]
      source_y_ord[i]=v3p[2*i]
      if(type_diffusion == "Sustained")
        integration_diffusion_coefficient[i] =v4[3*i-2]
        A_coefficients[i] = v4[3*i-1]
        tau0[i] = v4[3*i]
      else
        diffusion_maximum[i] =v5[2*i-1]
        diffusion_coefficients[i] = v5[2*i]
      end
    end
  else
    for i in 1:nb_source
      source_x_ord[i]=v3l[i]
      if(type_diffusion == "Sustained")
        integration_diffusion_coefficient[i] =v4[3*i-2]
        A_coefficients[i] = v4[3*i-1]
        tau0[i] = v4[3*i]
      else
        diffusion_maximum[i] =v5[2*i-1]
        diffusion_coefficients[i] = v5[2*i]
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
    pickle_start(filename, t, n_cell, steps, x_size, y_size, nb_ligands, nb_source, source_x_ord,
                 source_y_ord, v3p, v4, v8, v9, alive_cells)
  end

  simulator(canvas, alive_cells, dead_cells, categories, steps, display_output, pickle_output, 
            filename, x_size, y_size, border_settings,g, diffusion_coefficients, A_coefficients)
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
function pause(pause_time::Real,message::String = "anykey to advance timestep")
  #pauses for pause_time milliseconds
  if pause_time==0
    println(message)
    junk = readline(STDIN)
  else
    sleep(pause_time)
  end
end


##########################################################################################################
function init_window()
  println("Starting up window...")
  # window parameters
  window = Toplevel("Agent-based modeller",350,385)
  frame = Frame(window); pack(frame, expand=true, fill="both")
  grid_columnconfigure(frame, 100, weight=1)
  grid_rowconfigure(frame, 1, weight=1)

   #set defaults    
  v = Float64[10, 100, 30, 30,0.9]
  v2=Float64[8, 8, 1, 10, 1,8,1]
  global rb_value=["Point"]
  global v3p=Array(Float64,2*int(v2[5]))
  global v3l=Array(Float64,int(v2[5]))
  global v4=Array(Float64,3*int(v2[5]))
  global v5=Array(Float64,2*int(v2[5]))
  for i in 1:v2[5]
    v3p[2*i-1]=0
    v3p[2*i]=0
    v3l[i]=0
    v4[3*i-2]=100    # coef
    v4[3*i-1]=1      # A (initial)
    v4[3*i]=300     # tau
    v5[2*i-1]=100
    v5[2*i]=1
  end

  # The user can manually change parameters in the table below. Each row describes one cell type.
  # 1: The proportion of cells that are initialised to each type
  # 2: Growth rate
  # 3: The size at which cells divide
  # 4: Average speed for the given cell type
  # 5: Average radius for the given cell type
  # 6: Response to ligand. If 1, the cell is attracted to ligand. If -1, it is repelled
  # 7: Minimum detectable level of ligand
  # 8: Death rate
  # 9: Persistence. The proportion of the time that the cell moves in the same direction as previously.
  # 10: Randomness. The proportion of the time that the cell moves in a random direction
  # 11: Speed threshold that the cell needs to exceed to push another cell
  # 12: Minimum ratio between max and mean concentration that a cell can detect (for deciding its movement)
  #             1       2     3     4     5     6     7      8      9    10   11    12
      v8 = Float64[1.0   0.10   2.0   1.0   1.0   1.0   25.0  .0001   .2   1.   .1   1.00;
                   0.0   0.20   2.0   2.0   1.0  -1.0   0.0   .0001   .5   1.0   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00]
      v9 = ["ro"    true    true    false;
            "bo"    false    false    false;
            "mo"    false    false    false;
            "go"    false    false    false]

  v10 = String["Absorbing", "Removing", "Removing", "Removing"]

  # make and activate controls
  prompts = String["Number of cells", "Number of timesteps ", "Width of environment",
             "Height of environment ","Cell Contact Energy Loss Coefficient"]

  # make the input fields 
  entries1 = Entry(frame, "$(int(v[1]))") 
  entries2 = Entry(frame, "$(int(v[2]))")
  entries3 = Entry(frame, "$(v[3])")
  entries4 = Entry(frame, "$(v[4])")
  entries5 = Entry(frame, "$(v[5])")
  entries = [entries1,entries2,entries3,entries4,entries5]
  focus(entries[1])  

  for i in entries
    i[:width]=10
  end

  bhs = [Button(frame,"?") Button(frame,"?") Button(frame,"?") Button(frame,"?") Button(frame,"?") Button(frame,"?") Button(frame,"?") Button(frame,"?") Button(frame,"?")]
  for i in bhs
    i[:width]=1
  end

  l=[]
  for i in 1:length(prompts)
    l=[l,Label(frame,string(prompts[i],": "))]
  end

  for i in 1:length(prompts)
    grid(l[i],i,1,sticky="e")
    grid(bhs[i],i,3,sticky="w")
    grid(entries[i],i,2,sticky="ew")
  end

  lvoid1=Label(frame,"")
  grid(lvoid1,6,1:3)

  rb2 = Radio(frame, ["Sustained", "Instantaneous"])
  grid(rb2,7,2,sticky="ew")
  lrb=Label(frame,"Type of source: ")
  grid(lrb,7,1,sticky="e")
  grid(bhs[6],7,3,sticky="w")

  lvoid2=Label(frame,"")
  grid(lvoid2,8,1:3)

  b2 = Button(frame, "Diffusion Settings")
  grid(b2,9,2,sticky="ew")
  bind(b2, "command", path -> gui_diffusion(v,v2, prompts, entries,rb_value,get_value(rb2)))

  b3 = Button(frame, "Cell Type Settings")
  grid(b3,10,2,sticky="ew")
  bind(b3, "command", path -> gui_type(v8,v9))

  b4 = Button(frame, "Border Settings")
  grid(b4,11,2,sticky="ew")
  bind(b4, "command", path -> gui_border(v, v10, prompts, entries))

  lvoid3=Label(frame,"")
  grid(lvoid3,12,1:3)

  # make checkboxes
  display_status = Checkbutton(frame, "Display Simulation")
  set_value(display_status, true)
  pickle_status = Checkbutton(frame, "Write to pickle")
  grid(display_status, 13,2,sticky="w")
  grid(pickle_status,14,2,sticky="w")
  grid(bhs[7],13,3,sticky="w")
  grid(bhs[8],14,3,sticky="w")

  lvoid4=Label(frame,"")
  grid(lvoid4,15,1:3)
  # make, display and sensitise the 'run' button
  b = Button(frame, "Run")
  grid(b,16,2,sticky="ew")

  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b,i,path -> ok_press(window, canvas, frame, v, v2, v8, v9, v10, get_value(display_status), 
    get_value(pickle_status), entries, prompts,rb_value,get_value(rb2)))
  end

  lvoid5=Label(frame,"")
  grid(lvoid5,17,1:3)

  canvas = Canvas(frame, 0, 0)
  grid(canvas, 1:17, 4, sticky="nsew")

  helps = ["Input the number of cell you want to use";
           "Input the number of steps. The program will make cells move this number of steps.";
           "This is the width of the environment, you will also choose the size of each cells. Choose it 
                    properly to make all the cells fit within the environment";
           "This is the heigth of the environment, you will also choose the size of each cells. Choose 
                    it properly to make all the cells fit within the environment";
           "This coefficient is used to decrease the speed of the cell every time it touches another cell 
                    or a wall. Its speed is multiplied by this coefficient.";
           "The normal diffusion makes sources emit ligand only at time 0 (Dirac) whereas the integrative 
                    diffusion one make sources emit ligand during a time you can choose in the location(s) 
                    and parameters window. This parameter is called the time upper integrative limit. The 
                    normal diffusion is faster than the integrative one because no integration is required, 
                    but it is less biologicaly accurate.";
           "Unclick to remove the display. The simulation will be faster.";
           "Click to store cells positions at every step within a pickle file."]
  for i in 1:8
    bind(bhs[i], "command", path -> Messagebox(title="Help", message=helps[i]))
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




#run program

init_window()
