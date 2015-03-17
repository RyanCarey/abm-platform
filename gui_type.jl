function gui_type(v8::Matrix{Float64},v9::Matrix{Any})
  # Create a top level window and the assorted stuff with it
	w3 = Toplevel("Cell Types", 300, 300) ## title, width, height
  f3 = Frame(w3)
  pack(f3, expand = true, fill = "both")

  # column labels
  for i in 1:4
    grid(Label(f3, "Type $i"), 1, i+1)
  end

  # row labels
  cat_prompts = String["Ratio: ", "Growth Rate: ", "Division Threshold: ", "Average Speed: ", 
                       "Average Radius: ", "Response to ligand: ", "Stem Threshold: ",
                       "Death Rate: ", "Persistence (0-1): ", "Randomness: ","Speed Threshold triggering bouncing: ","Concentration Threshold Ratio triggering movement (1-2): ", "Colour: "]
  for i in 1:length(cat_prompts)
    grid(Label(f3, cat_prompts[i]), i+1, 1, sticky = "se")
  end

  # initialise dropdown boxes
  colours = String["Red", "Blue", "Magenta", "Green", "Yellow"]
  colour_entries = Tk.Tk_Combobox[Combobox(f3,colours),Combobox(f3,colours),Combobox(f3,colours),Combobox(f3,colours)]

  # initialise checkboxes
  cat_entries_bool = Tk.Tk_Checkbutton[Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell") Checkbutton(f3, "Stick to Source");
                                       Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell") Checkbutton(f3, "Stick to Source");
                                       Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell") Checkbutton(f3, "Stick to Source");
                                       Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell") Checkbutton(f3, "Stick to Source")]
  # initialise forms
  cat_entries = Tk.Tk_Entry[Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3); 
                            Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3); 
                            Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3); 
                            Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3)]
  for i in 1:4
    # set and place forms
    for j in 1 : size(cat_entries,2)
        set_value(cat_entries[i,j], "$(v8[i,j])")
        grid(cat_entries[i,j], j + 1, i+1)
    end

    # set and place dropdown boxes
    co_to_colour = Dict(("ro"=>"Red"), ("bo"=>"Blue"), ("mo"=>"Magenta"), ("go"=>"Green"), ("yo"=>"Yellow"))
    set_value(colour_entries[i], co_to_colour[v9[i,1]])
    grid(colour_entries[i], length(cat_prompts) + 1, i+1)

    # set and place checkboxes
    for j in 1:size(cat_entries_bool,2)
      if i == 4 && j == 2
        continue
      end
      set_value(cat_entries_bool[i,j], v9[i,j+1])
      grid(cat_entries_bool[i,j], length(cat_prompts)+1+j, i+1)
    end
  end

  # Place Ok button in bottom right
  b = Button(f3, "Ok")
  grid(b, 10, 11)
  for i in ["command","<Return>","<KP_Enter>"]
     bind(b, i, path -> destroy_cat_window(w3, v8,v9, cat_entries, colour_entries, cat_entries_bool))
  end
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
    # check that population ratios are positive
    if float(get_value(cat_entries[i,1])) < 0.0
      set_value(cat_entries[i,1], "0.0")
      Messagebox(title = "Warning", message = string("Ratio must be nonnegative. \nResetting value to 0."))
    end
    # convert inputted values to floats
    for j in 1:size(cat_entries,2)
      v8[i,j] = float(get_value(cat_entries[i,j]))
    end
  end

  colour_to_co = Dict(("Red"=>"ro"), ("Blue"=>"bo"), ("Magenta"=>"yo"), ("Green"=>"go"), ("Yellow"=>"yo"))
  for i in 1:4
    v9[i,1] = colour_to_co[get_value(colour_entries[i])]
    v9[i,2] = get_value(cat_entries_bool[i,1])
    v9[i,3] = get_value(cat_entries_bool[i,2])
    v9[i,4] = get_value(cat_entries_bool[i,3])
  end
end
