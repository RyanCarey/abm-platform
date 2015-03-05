function gui_type(v8::Array,v9::Array)
  # Create a top level window and the assorted stuff with it
	global w3 = Toplevel("Type Parameters", 300, 300) ## title, width, height
  global f3 = Frame(w3)
  pack(f3, expand = true, fill = "both")

  # place labels
  for i in 1:4
    grid(Label(f3, "Type $i"), 1, i+1)
  end

  cat_prompts = String["Ratio: ", "Growth Rate: ", "Division Threshold: ", "Average Speed: ", 
                       "Average Radius: ", "Response to ligand: ", #"Persistence (0-1)", 
                       "Randomness", "Colour: "]
  colours = String["red", "blue", "magenta", "green", "yellow"]

  # Put prompt labels down left hand side
  for i in 1:8
    grid(Label(f3, cat_prompts[i]), i + 1, 1, sticky = "se")
  end

  # initialise dropdown boxes
  global colour_entries = [Combobox(f3,colours),Combobox(f3,colours),Combobox(f3,colours),Combobox(f3,colours)]

  # initialise checkboxes
  global cat_entries_bool = [Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell");
                             Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell");
                             Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell");
                             Checkbutton(f3, "Left Placed")  Checkbutton(f3, "Stem Cell")]

  # initialise forms
  global cat_entries = Tk.Tk_Entry[Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3); 
                                   Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3); 
                                   Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3); 
                                   Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3) Entry(f3)]

  for i in 1:4
    # set and place forms
    for j in 1 : size(cat_entries,2)
      set_value(cat_entries[i,j], "$(v8[i,j])")
      grid(cat_entries[i,j], j + 1, i+1)
    end

    # set and place dropdown boxes
    set_value(colour_entries[i], "$(v9[i,1])")
    grid(colour_entries[i], 9, i+1)

    # set and place checkboxes
    for j in 1:size(cat_entries_bool,2)
      set_value(cat_entries_bool[i,j], v9[i,j+1])
      grid(cat_entries_bool[i,j], 9+j, i+1)
    end
  end

  # Place Ok button in bottom right
  b = Button(f3, "Ok")
  grid(b, 10, 6)
  for i in ["command","<Return>","<KP_Enter>"]
     bind(b, i, path -> destroy_cat_window(v8,v9))
  end

 if !isinteractive()
    while true
      a = readline(STDIN)
      if a == "exit"
        return
      end
    end
  end
end

# Function to get values and destroy window upon clicking OK
function destroy_cat_window(v8::Array{Float64,2},v9::Array{Any,2})
  check_cat_entries(v8,v9)
  destroy(w3)
end

# Function to collect values.
function check_cat_entries(v8::Array{Float64,2},v9::Array{Any,2})
  for i in 1:4
    # check that population ratios are positive
    if float(get_value(cat_entries[i,1])) < 0.0
      set_value(cat_entries[i,1], "0.0")
      Messagebox(title = "Warning", message = string("Ratio must be above 0. \nResetting value to 0."))
    end
    # convert inputted values to floats
    for j in 1:size(cat_entries,2)
      v8[i,j] = float(get_value(cat_entries[i,j]))
    end
  end

  colour_dict = Dict("red"=>"ro", "blue"=>"bo", "magenta"=>"yo", "green"=>"go", "yellow"=>"yo",)
  for i in 1:4
    v9[i,1] = colour_dict[get_value(colour_entries[i])]
    v9[i,2] = get_value(cat_entries_bool[i,1])
    v9[i,3] = get_value(cat_entries_bool[i,2])
  end
end
