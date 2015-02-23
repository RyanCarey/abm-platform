using Tk

function get_categories(v8::Array,v9::Array)
  # Create a top level window and the assorted stuff with it
	global w3 = Toplevel("Type Parameters", 300, 300) ## title, width, height
  global f3 = Frame(w3)
  pack(f3, expand = true, fill = "both")
  grid(Label(f3, "Type 1"), 1, 2)
  grid(Label(f3, "Type 2"), 1, 3)
  grid(Label(f3, "Type 3"), 1, 4)
  grid(Label(f3, "Type 4"), 1, 5)

  cat_prompts = String["Ratio: ", "Growth Rate: ", "Division Threshold: ", "Average Speed: ", "Average Radius: ", "Conc. Response: ", "Randomness", "Colour: "]
  colours = String["ro", "bo", "mo", "go", "yo"]
  # Put prompt labels down left hand side
  for i in 1 : 7
    grid(Label(f3, cat_prompts[i]), i + 1, 1, sticky = "se")
  end
  n = length(cat_prompts)
  # Inititalise and set defaults for each entry. Could probably be cleaner / more efficient. At the moment this happens every time the button is pressed, and then occasionally overwritten by previously
  # entered options.
	cat_entries1 = Entry(f3)
  cat_entries2 = Entry(f3)
  cat_entries3 = Entry(f3)
  cat_entries4 = Entry(f3)
  cat_entries5 = Entry(f3)
  cat_entries6 = Entry(f3)
  cat_entries6_1 = Entry(f3)
  global cat_entries7 = Combobox(f3, colours)
  global cat_entries8 = Checkbutton(f3, "Left Placed")
  global cat_entries9 = Checkbutton(f3, "Stem Cell")

  cat_entries21 = Entry(f3)
  cat_entries22 = Entry(f3)
  cat_entries23 = Entry(f3)
  cat_entries24 = Entry(f3)
  cat_entries25 = Entry(f3)
  cat_entries26 = Entry(f3)
  cat_entries26_1 = Entry(f3)
  global cat_entries27 = Combobox(f3, colours)
  global cat_entries28 = Checkbutton(f3, "Left Placed")
  global cat_entries29 = Checkbutton(f3, "Stem Cell")

  cat_entries31 = Entry(f3)
  cat_entries32 = Entry(f3)
  cat_entries33 = Entry(f3)
  cat_entries34 = Entry(f3)
  cat_entries35 = Entry(f3)
  cat_entries36 = Entry(f3)
  cat_entries36_1 = Entry(f3)
  global cat_entries37 = Combobox(f3, colours)
  global cat_entries38 = Checkbutton(f3, "Left Placed")
  global cat_entries39 = Checkbutton(f3, "Stem Cell")

  cat_entries41 = Entry(f3)
  cat_entries42 = Entry(f3)
  cat_entries43 = Entry(f3)
  cat_entries44 = Entry(f3)
  cat_entries45 = Entry(f3)
  cat_entries46 = Entry(f3)
  cat_entries46_1 = Entry(f3)
  global cat_entries47 = Combobox(f3, colours)
  global cat_entries48 = Checkbutton(f3, "Left Placed")
  global cat_entries49 = Checkbutton(f3, "Stem Cell")

  # If options have already been specified, overwrites entries with those previously given.
  set_value(cat_entries1, "$(v8[1])")
  set_value(cat_entries2, "$(v8[2])")
  set_value(cat_entries3, "$(v8[3])")
  set_value(cat_entries4, "$(v8[4])")
  set_value(cat_entries5, "$(v8[5])")
  set_value(cat_entries6, "$(v8[6])")
  set_value(cat_entries6_1, "$(v8[25])")
  set_value(cat_entries7, "$(v9[1])")
  set_value(cat_entries8, v9[2])
  set_value(cat_entries9, v9[3])
  set_value(cat_entries21, "$(v8[7])")
  set_value(cat_entries22, "$(v8[8])")
  set_value(cat_entries23, "$(v8[9])")
  set_value(cat_entries24, "$(v8[10])")
  set_value(cat_entries25, "$(v8[11])")
  set_value(cat_entries26, "$(v8[12])")
  set_value(cat_entries26_1, "$(v8[26])")
  set_value(cat_entries27, "$(v9[4])")
  set_value(cat_entries28, v9[5])
  set_value(cat_entries29, v9[6])
  set_value(cat_entries31, "$(v8[13])")
  set_value(cat_entries32, "$(v8[14])")
  set_value(cat_entries33, "$(v8[15])")
  set_value(cat_entries34, "$(v8[16])")
  set_value(cat_entries35, "$(v8[17])")
  set_value(cat_entries36, "$(v8[18])")
  set_value(cat_entries36_1, "$(v8[27])")
  set_value(cat_entries37, "$(v9[7])")
  set_value(cat_entries38, v9[8])
  set_value(cat_entries39, v9[9])
  set_value(cat_entries41, "$(v8[19])")
  set_value(cat_entries42, "$(v8[20])")
  set_value(cat_entries43, "$(v8[21])")
  set_value(cat_entries44, "$(v8[22])")
  set_value(cat_entries45, "$(v8[23])")
  set_value(cat_entries46, "$(v8[24])")
  set_value(cat_entries46_1, "$(v8[28])")
  set_value(cat_entries47, "$(v9[10])")
  set_value(cat_entries48, v9[11])
  set_value(cat_entries49, v9[12])

  global cat_entries = Tk.Tk_Entry[cat_entries1, cat_entries2, cat_entries3, cat_entries4, cat_entries5, cat_entries6, cat_entries21, cat_entries22, cat_entries23, cat_entries24, cat_entries25, cat_entries26,
   cat_entries31, cat_entries32, cat_entries33, cat_entries34, cat_entries35, cat_entries36, cat_entries41, cat_entries42, cat_entries43, cat_entries44, cat_entries45, cat_entries46,
  cat_entries6_1, cat_entries26_1, cat_entries36_1, cat_entries46_1]

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

  grid(cat_entries6_1, 8, 2)
  grid(cat_entries7, 9, 2)
  grid(cat_entries8, 10, 2)
  grid(cat_entries9, 11, 2)

  grid(cat_entries26_1, 8, 3)
  grid(cat_entries27, 9, 3)
  grid(cat_entries28, 10, 3)
  grid(cat_entries29, 11, 3)

  grid(cat_entries36_1, 8, 4)
  grid(cat_entries37, 9, 4)
  grid(cat_entries38, 10, 4)
  grid(cat_entries39, 11, 4)

  grid(cat_entries46_1, 8, 5)
  grid(cat_entries47, 9, 5)
  grid(cat_entries48, 10, 5)
  grid(cat_entries49, 11, 5)


  # Place Ok button in bottom right
  b = Button(f3, "Ok")
  grid(b, 10, 6)
  for i in ["command","<Return>","<KP_Enter>"]
     bind(b, i, path -> destroy_cat_window(v8,v9,n))
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
function destroy_cat_window(v8,v9,n)
  check_cat_entries(v8,v9,n)
  destroy(w3)
end

# Function to collect values.
function check_cat_entries(v8,v9,n)
  for i in 1 : length(cat_entries)      
    if i == 1 || i == 7 || i == 13 || i == 19
      if float(get_value(cat_entries[i])) < 0.0
        set_value(cat_entries[i], "0.0")
        Messagebox(title = "Warning", message = string("Ratio must be above 0. \nResetting value to 0."))
      end
    end
    v8[i] = float(get_value(cat_entries[i]))
  end
  v9[1] = get_value(cat_entries7)
  v9[2] = get_value(cat_entries8)
  v9[3] = get_value(cat_entries9)
  v9[4] = get_value(cat_entries27)
  v9[5] = get_value(cat_entries28)
  v9[6] = get_value(cat_entries29)
  v9[7] = get_value(cat_entries37)
  v9[8] = get_value(cat_entries38)
  v9[9] = get_value(cat_entries39)
  v9[10] = get_value(cat_entries47)
  v9[11] = get_value(cat_entries48)
  v9[12] = get_value(cat_entries49)
  
  #v8[1] /= n
  #v8[7] /= n
  #v8[13] /= n
  #v8[19] /= n
end