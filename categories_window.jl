using Tk

function get_categories(path)
	global w3 = Toplevel("Type Parameters", 300, 300) ## title, width, height
  global f3 = Frame(w3)
  pack(f3, expand = true, fill = "both")
  grid(Label(f3, "Type 1"), 1, 2)
  grid(Label(f3, "Type 2"), 1, 3)
  grid(Label(f3, "Type 3"), 1, 4)
  grid(Label(f3, "Type 4"), 1, 5)
  
  cat_prompts = "Ratio: ", "Colour: ", "Growth Rate: ", "Division Threshold: ", "Average Speed: ",
   "Average Radius: ", "Conc. Response: "

  for i in 1 : 7
    grid(Label(f3, cat_prompts[i]), i + 1, 1, sticky = "se")
  end
  n = length(cat_prompts)  

	cat_entries1 = Entry(f3, "1.0")
  cat_entries2 = Entry(f3, "r")
  cat_entries3 = Entry(f3, "0.05")
  cat_entries4 = Entry(f3, "2.0")
  cat_entries5 = Entry(f3, "1.0")
  cat_entries6 = Entry(f3, "1.0")  
  cat_entries7 = Entry(f3, "1.0")
  cat_entries8 = Checkbutton(f3, "Left Placed")
  cat_entries9 = Checkbutton(f3, "Stem Cell")
  
  cat_entries21 = Entry(f3, "0.0")
  cat_entries22 = Entry(f3, "b")
  cat_entries23 = Entry(f3, "0.05")
  cat_entries24 = Entry(f3, "2.0")
  cat_entries25 = Entry(f3, "1.0")
  cat_entries26 = Entry(f3, "1.0")
  cat_entries27 = Entry(f3, "-1.0")
  cat_entries28 = Checkbutton(f3, "Left Placed")
  cat_entries29 = Checkbutton(f3, "Stem Cell")
 
  cat_entries31 = Entry(f3, "0.0")
  cat_entries32 = Entry(f3, "m")
  cat_entries33 = Entry(f3, "0.05")
  cat_entries34 = Entry(f3, "2.0")
  cat_entries35 = Entry(f3, "1.0")
  cat_entries36 = Entry(f3, "1.0")
  cat_entries37 = Entry(f3, "1.0")
  cat_entries38 = Checkbutton(f3, "Left Placed")
  cat_entries39 = Checkbutton(f3, "Stem Cell")

  cat_entries41 = Entry(f3, "0.0")
  cat_entries42 = Entry(f3, "g")
  cat_entries43 = Entry(f3, "0.05")
  cat_entries44 = Entry(f3, "2.0")
  cat_entries45 = Entry(f3, "1.0")
  cat_entries46 = Entry(f3, "1.0")
  cat_entries47 = Entry(f3, "1.0")
  cat_entries48 = Checkbutton(f3, "Left Placed")
  cat_entries49 = Checkbutton(f3, "Stem Cell")

  cat_entries = [cat_entries1, cat_entries2, cat_entries3, cat_entries4, cat_entries5, cat_entries6,
  cat_entries7, cat_entries8, cat_entries9, cat_entries21, cat_entries22, cat_entries23, cat_entries24,
  cat_entries25, cat_entries26, cat_entries27, cat_entries28, cat_entries29, cat_entries31,
  cat_entries32, cat_entries33, cat_entries34, cat_entries35, cat_entries36, cat_entries37,
  cat_entries38, cat_entries39, cat_entries41, cat_entries42, cat_entries43, cat_entries44,
  cat_entries45, cat_entries46, cat_entries47, cat_entries48, cat_entries49]
  
  for i in 1 : 9
  	grid(cat_entries[i], i + 1, 2)
    #formlayout(cat_entries[i], string(cat_prompts[i],": "))
  end

  #grid(cat_entries8, 9, 2)
  #grid(cat_entries9, 10, 2)


  for i in 10 : 18
  	grid(cat_entries[i], i - 8, 3)
  end

  for i in 19 : 27
  	grid(cat_entries[i], i - 17, 4)
  end

  for i in 28 : 36
  	grid(cat_entries[i], i - 26, 5)
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