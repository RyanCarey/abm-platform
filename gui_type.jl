function gui_type(v8::Matrix{Float64},v9::Matrix{Any})
  # Create a top level window and the assorted stuff with it
  w3 = Toplevel("Cell Types", 300, 300) ## title, width, height
  f3 = Frame(w3)
  pack(f3, expand = true, fill = "both")

  # Column labels
  for i in 1:4
    grid(Label(f3, "Type $i"), 1, i+2)
  end

  # Row labels
  cat_prompts = String["Ratio: ", "Growth Rate: ", "Division Threshold: ", "Average Speed: ", 
                       "Average Radius: ", "Response to ligand: ", "Min detectable ligand: ",
                       "Death Rate: ", "Persistence (0-1): ", "Randomness: ","Inertia Threshold: ",
                       "Min Detectable Ligand Ratio (1-2): ", "Colour: "]
  bhelp=[]

  for i in 1:length(cat_prompts)
    bhelp=[bhelp,Button(f3,"?")]
    bhelp[i][:width]=1
    grid(Label(f3, cat_prompts[i]), i+1, 1, sticky = "se")
    grid(bhelp[i],i+1,2,sticky = "e")
  end

  # Initialise dropdown boxes
  colours = String["Red", "Blue", "Magenta", "Green", "Yellow"]
  colour_entries = Tk.Tk_Combobox[Combobox(f3,colours),Combobox(f3,colours),Combobox(f3,colours),Combobox(f3,colours)]

  # Initialise checkboxes
  cat_entries_bool = Tk.Tk_Checkbutton[Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell") Checkbutton(f3, "Stick to Source");
                                       Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell") Checkbutton(f3, "Stick to Source");
                                       Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell") Checkbutton(f3, "Stick to Source");
                                       Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell") Checkbutton(f3, "Stick to Source")]
  # Initialise forms
  cat_entries = Tk.Tk_Entry[Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3); 
                            Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3); 
                            Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3); 
                            Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3)]
  for i in 1 : 4
    # Set and place forms
    for j in 1 : size(cat_entries,2)
        set_value(cat_entries[i,j], "$(v8[i,j])")
        grid(cat_entries[i,j], j + 1, i+2)
    end

    # Set and place dropdown boxes
    # Make a dictionary for colors
    co_to_color = Dict()
    colors = ["Red","Blue","Magenta","Green","Yellow"]
    cos = ["ro","bo","mo","go","yo"]

    for k in 1 : length(cos)
      co_to_color[cos[k]] = colors[k]
    end

    co_to_colour = Dict(("ro"=>"Red"), ("bo"=>"Blue"), ("mo"=>"Magenta"), ("go"=>"Green"), ("yo"=>"Yellow"))
    set_value(colour_entries[i], co_to_colour[v9[i, 1]])
    grid(colour_entries[i], length(cat_prompts) + 1, i+2)

    # Set and place checkboxes
    for j in 1 : size(cat_entries_bool, 2)
      if i == 4 && j == 2
        continue
      end
      set_value(cat_entries_bool[i, j], v9[i, j + 1])
      grid(cat_entries_bool[i, j], length(cat_prompts) + 1 + j, i + 2)
    end
  end

  # Place Ok button in bottom right
  b = Button(f3, "Ok")
  grid(b, 17, 12)
  for i in ["command","<Return>","<KP_Enter>"]
     bind(b, i, path -> destroy_cat_window(w3, v8,v9, cat_entries, colour_entries, cat_entries_bool))
  end

  bhelp=[bhelp, Button(f3,"?"),Button(f3,"?"),Button(f3,"?")]
  bhelp[14][:width]=1
  bhelp[15][:width]=1
  bhelp[16][:width]=1
  grid(bhelp[14],15,2,sticky = "e")
  grid(bhelp[15],16,2,sticky = "e")
  grid(bhelp[16],17,2,sticky = "e")

  bind(bhelp[1], "command", path -> Messagebox(title="Help", message=""))
  bind(bhelp[2], "command", path -> Messagebox(title="Help", message=""))
  bind(bhelp[3], "command", path -> Messagebox(title="Help", message=""))
  bind(bhelp[4], "command", path -> Messagebox(title="Help", message=""))
  bind(bhelp[5], "command", path -> Messagebox(title="Help", message=""))
  bind(bhelp[6], "command", path -> Messagebox(title="Help", message=""))
  bind(bhelp[7], "command", path -> Messagebox(title="Help", message="This is the concentration threshold that will define whether the cell is in the niche and should choose its angle thanks to the ligand concentration or whether this cell is out of the niche and should move randomly. To choose accurately this parameter please look at the diffusion curve within the 'diffusion' window.\n Do not forget in the case of the use of more than one source, that the concentration from each source are added."))
  bind(bhelp[8], "command", path -> Messagebox(title="Help", message=""))
  bind(bhelp[9], "command", path -> Messagebox(title="Help", message="This parameter defines how persistent the movement of this kind of cell will be. To decide if the cell should keep its previous location, we choose a number between 0 and 1 from a uniform distribution and if this number is below the persistence, the cell keeps its direction. The higher the persistence is, the more the cell is persistent."))
  bind(bhelp[10], "command", path -> Messagebox(title="Help", message="This parameter modify the choice of the angle. If it equals 0, the cell will choose its angle only according to the concentration (cf. the manual for more information). Otherwise, the chosen angle is the angle calculated by the concentration to which we add this randomness parameter multiplied by a random number chosen among a normal distribution of mean 0 and variance pi."))
  bind(bhelp[11], "command", path -> Messagebox(title="Help", message="This is the minimum speed the cell needs to have in order to trigger a boucing. Putting it to a high value will decrease the impact of the ballistic and therefore accelerate the calculation of movement. Please refer to the manual for more information."))
  bind(bhelp[12], "command", path -> Messagebox(title="Help", message="This is the threshold above which, the maximum concentration at a specific ligand receptor divided by the mean concentration of all ligand receptors, need to be in order to trigger a movement. Therefore it cannot be below one. Usually 1.1 is a good threshold. If the previous ration is below the threshold, the cell will have a random angle. Please refer to the manual for more information."))
  bind(bhelp[13], "command", path -> Messagebox(title="Help", message=""))
  bind(bhelp[14], "command", path -> Messagebox(title="Help", message=""))
  bind(bhelp[15], "command", path -> Messagebox(title="Help", message=""))
  bind(bhelp[16], "command", path -> Messagebox(title="Help", message=""))


  
end

# Function to get values and destroy window upon clicking OK
function destroy_cat_window(w3::Tk.Tk_Toplevel, v8::Array{Float64,2},v9::Array{Any,2}, cat_entries::Array{Tk.Tk_Entry,2},
                           colour_entries::Vector{Tk.Tk_Combobox}, cat_entries_bool::Array{Tk.Tk_Checkbutton, 2})
  check_cat_entries(v8,v9,cat_entries, colour_entries, cat_entries_bool)
  destroy(w3)
end

# Function to collect values.
function check_cat_entries(v8::Matrix{Float64},v9::Matrix{Any},cat_entries::Matrix{Tk.Tk_Entry},
                           colour_entries::Vector{Tk.Tk_Combobox}, cat_entries_bool::Matrix{Tk.Tk_Checkbutton})
  for i in 1:4
    # Check that population ratios are positive
    if float(get_value(cat_entries[i,1])) < 0.0
      set_value(cat_entries[i,1], "0.0")
      Messagebox(title = "Warning", message = string("Ratio must be nonnegative. \nResetting value to 0."))
    end
    # Convert inputted values to floats
    for j in 1:size(cat_entries,2)
      v8[i,j] = float(get_value(cat_entries[i,j]))
    end
  end

  # make a dictionary for colors
  colour_to_co = Dict()
  colors = ["Red","Blue","Magenta","Green","Yellow"]
  cos = ["ro","bo","mo","go","yo"]
  for i in 1:length(colors)
    colour_to_co[colors[i]] = cos[i]
  end
  
  for i in 1:4
    v9[i,1] = colour_to_co[get_value(colour_entries[i])]
    v9[i,2] = get_value(cat_entries_bool[i,1])
    v9[i,3] = get_value(cat_entries_bool[i,2])
    v9[i,4] = get_value(cat_entries_bool[i,3])
  end

end
