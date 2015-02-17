using Tk

function get_categories(path)
  # Create a top level window and the assorted stuff with it
	global w3 = Toplevel("Type Parameters", 300, 300) ## title, width, height
  global f3 = Frame(w3)
  pack(f3, expand = true, fill = "both")
  grid(Label(f3, "Type 1"), 1, 2)
  grid(Label(f3, "Type 2"), 1, 3)
  grid(Label(f3, "Type 3"), 1, 4)
  grid(Label(f3, "Type 4"), 1, 5)
  
  cat_prompts = String["Ratio: ", "Growth Rate: ", "Division Threshold: ", "Average Speed: ", "Average Radius: ", "Conc. Response: ", "Colour: "]
  colours = String["r", "b", "m", "g", "y"]
  # Put prompt labels down left hand side
  for i in 1 : 7
    grid(Label(f3, cat_prompts[i]), i + 1, 1, sticky = "se")
  end
  n = length(cat_prompts)  
  # Each entry field
	cat_entries1 = Entry(f3, "1.0")
  cat_entries2 = Entry(f3, "0.05")
  cat_entries3 = Entry(f3, "2.0")
  cat_entries4 = Entry(f3, "1.0")
  cat_entries5 = Entry(f3, "1.0")
  cat_entries6 = Entry(f3, "1.0")  
  global cat_entries7 = Combobox(f3, colours)
  global cat_entries8 = Checkbutton(f3, "Left Placed")
  global cat_entries9 = Checkbutton(f3, "Stem Cell")
  
  cat_entries21 = Entry(f3, "0.0")
  cat_entries22 = Entry(f3, "0.05")
  cat_entries23 = Entry(f3, "2.0")
  cat_entries24 = Entry(f3, "1.0")
  cat_entries25 = Entry(f3, "1.0")
  cat_entries26 = Entry(f3, "-1.0")
  global cat_entries27 = Combobox(f3, colours)
  global cat_entries28 = Checkbutton(f3, "Left Placed")
  global cat_entries29 = Checkbutton(f3, "Stem Cell")
 
  cat_entries31 = Entry(f3, "0.0")
  cat_entries32 = Entry(f3, "0.05")
  cat_entries33 = Entry(f3, "2.0")
  cat_entries34 = Entry(f3, "1.0")
  cat_entries35 = Entry(f3, "1.0")
  cat_entries36 = Entry(f3, "1.0")
  global cat_entries37 = Combobox(f3, colours)
  global cat_entries38 = Checkbutton(f3, "Left Placed")
  global cat_entries39 = Checkbutton(f3, "Stem Cell")

  cat_entries41 = Entry(f3, "0.0")
  cat_entries42 = Entry(f3, "0.05")
  cat_entries43 = Entry(f3, "2.0")
  cat_entries44 = Entry(f3, "1.0")
  cat_entries45 = Entry(f3, "1.0")
  cat_entries46 = Entry(f3, "1.0")
  global cat_entries47 = Combobox(f3, colours)
  global cat_entries48 = Checkbutton(f3, "Left Placed")
  global cat_entries49 = Checkbutton(f3, "Stem Cell")

  global cat_entries = Tk.Tk_Entry[cat_entries1, cat_entries2, cat_entries3, cat_entries4, cat_entries5, cat_entries6, cat_entries21, cat_entries22, cat_entries23, cat_entries24, cat_entries25, cat_entries26,
   cat_entries31, cat_entries32, cat_entries33, cat_entries34, cat_entries35, cat_entries36, cat_entries41, cat_entries42, cat_entries43, cat_entries44, cat_entries45, cat_entries46]
  
  # Place entry fields in columns
  for i in 1 : 6
  	grid(cat_entries[i], i + 1, 2)
  end
  for i in 7 : 12
  	grid(cat_entries[i], i - 5, 3)
  end
  for i in 13 : 18
  	grid(cat_entries[i], i - 11, 4)
  end
  for i in 19 : 24
  	grid(cat_entries[i], i - 17, 5)
  end
  grid(cat_entries7, 8, 2)
  grid(cat_entries8, 9, 2)
  grid(cat_entries9, 10, 2)
  set_value(cat_entries7, "r")
  set_value(cat_entries8, true)
  set_value(cat_entries9, true)

  grid(cat_entries27, 8, 3)
  grid(cat_entries28, 9, 3)
  grid(cat_entries29, 10, 3)
  set_value(cat_entries27, "b")

  grid(cat_entries37, 8, 4)
  grid(cat_entries38, 9, 4)
  grid(cat_entries39, 10, 4)
  set_value(cat_entries37, "m")

  grid(cat_entries47, 8, 5)
  grid(cat_entries48, 9, 5)
  grid(cat_entries49, 10, 5)
  set_value(cat_entries47, "g")

  # Place Ok button in bottom left
  b = Button(f3, "Ok")  
  grid(b, 10, 6)
  for i in ["command","<Return>","<KP_Enter>"] 
     bind(b, i, destroy_cat_window)
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
function destroy_cat_window(path)
  check_cat_entries()
  destroy(w3)
end

# Function to collect values.
function check_cat_entries()
  global v8 = []
  global v9 = []
  for i in 1 : length(cat_entries)
    try
      push!(v8, float(get_value(cat_entries[i])))
    catch
      Messagebox(title="Warning", message=string("Must enter a numeric for field ", cat_entries[i]))
      return
    end
  end
  push!(v9, get_value(cat_entries7))
  push!(v9, get_value(cat_entries8))
  push!(v9, get_value(cat_entries9))
  push!(v9, get_value(cat_entries27))
  push!(v9, get_value(cat_entries28))
  push!(v9, get_value(cat_entries29))
  push!(v9, get_value(cat_entries37))
  push!(v9, get_value(cat_entries38))
  push!(v9, get_value(cat_entries39))
  push!(v9, get_value(cat_entries47))
  push!(v9, get_value(cat_entries48))
  push!(v9, get_value(cat_entries49))
  
  global changed_cell_type = true
   
end
