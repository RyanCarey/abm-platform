using Tk

function get_borders(path)
  # Create a top level window and frames
	global w4 = Toplevel("Border Parameters", 250, 300) ## title, width, height
  global f4 = Frame(w4)
  pack(f4, expand = true, fill = "both")
  grid(canvas, 1, 2, sticky="nsew")
  behaviours = ["Reflecting","Absorbing","Killing"]

  global border_entries1 = Combobox(f4, behaviours)
  set_value(border_entries1, "Absorbing")
  global border_entries2 = Combobox(f4, behaviours)
  set_value(border_entries2, "Killing")
  global border_entries3 = Combobox(f4, behaviours)
  set_value(border_entries3, "Killing")
  global border_entries4 = Combobox(f4, behaviours)
  set_value(border_entries4, "Killing")

  if changed_border_type
    set_value(border_entries1, "$(v10[1])")
    set_value(border_entries2, "$(v10[2])")
    set_value(border_entries3, "$(v10[3])")
    set_value(border_entries4, "$(v10[4])")
  end

  # Place entry fields in columns
  border_entries = [border_entries1,border_entries2,border_entries3,border_entries4]

  border_prompts = ["Left border","Lower border","Right border","Top border"]
  n = length(border_prompts)  
  for i in 1:length(border_prompts)
    grid(border_entries[i],i+1,1)
    #grid(Label(f4, border_prompts[i]),i+1,1,sticky = "se")
    formlayout(border_entries[i],string(border_prompts[i],": "))
    bind(entries[i], "<Return>", simulate)
    bind(entries[i], "<KP_Enter>", simulate)
  end

  # Place Ok button in bottom left
  bbord = Button(f4, "Ok")  
  #grid(bbord, 5, 1)
  for i in ["command","<Return>","<KP_Enter>"] 
     bind(bbord, i, destroy_cat_window)
  end
  formlayout(bbord, nothing)

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
  check_border_entries()
  destroy(w4)
end

# Function to collect values.
function check_border_entries()
  global v10 = []
  push!(v10, get_value(border_entries1))
  push!(v10, get_value(border_entries2))
  push!(v10, get_value(border_entries3))
  push!(v10, get_value(border_entries4))
  global changed_border_type = true
end
