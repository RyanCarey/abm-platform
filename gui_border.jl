function gui_border(v::Vector{Float64}, v10::Vector{String}, prompts::Vector{String}, entries::Vector{Tk.Tk_Entry})
  #check_entries1(v, prompts, entries)
  # Create a top level window and frames
	w4 = Toplevel("Border Parameters", 250, 300) ## title, width, height
  f4 = Frame(w4)
  pack(f4, expand = true, fill = "both")
  #grid(canvas, 1, 2, sticky="nsew")
  behaviours = ["Reflecting","Absorbing","Removing"]

  border_entries1 = Combobox(f4, behaviours)
  border_entries2 = Combobox(f4, behaviours)
  border_entries3 = Combobox(f4, behaviours)
  border_entries4 = Combobox(f4, behaviours)

  border_entries = [border_entries1, border_entries2, border_entries3, border_entries4]
  for i in 1:4
    set_value(border_entries[i], "$(v10[i])")
  end

  # Place entry fields in columns
  border_entries = [border_entries1,border_entries2,border_entries3,border_entries4]
  border_prompts = ["Left border","Right border","Lower border","Top border"]

  for i in 1:length(border_prompts)
    grid(border_entries[i],i+1,1)
    #grid(Label(f4, border_prompts[i]),i+1,1,sticky = "se")
    formlayout(border_entries[i],string(border_prompts[i],": "))
    bind(border_entries[i], "<Return>", path -> destroy_border_window(v10, border_entries, w4))
    bind(border_entries[i], "<KP_Enter>", path -> destroy_border_window(v10, border_entries, w4))
  end

  # Place Ok button in bottom left
  bbord = Button(f4, "Ok")  
  bind(bbord, "command", path -> destroy_border_window(v10, border_entries, w4))
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
function destroy_border_window(v10::Vector{String}, border_entries::Vector{Tk.Tk_Combobox}, w4)
  check_border_entries(v10, border_entries)
  destroy(w4)
end

# Function to collect values.
function check_border_entries(v10::Vector{String}, border_entries::Vector{Tk.Tk_Combobox})
  for i in 1:4
    v10[i] = get_value(border_entries[i])
  end
end
