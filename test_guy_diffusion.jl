using Tk



function init_window()

  w3 = Toplevel("Slider/Spinbox")
  f3 = Frame(w3); pack(f3, expand = true, fill = "both")
  global check_location = true
  global w3 = Toplevel("Ligand's source location") ## title, width, height
  global f3 = Frame(w3) 
  pack(f3, expand=true, fill="both")
  ctrls3 = Frame(f3)
  grid(ctrls3, 1, 1, sticky="nw", pady=5, padx=5)
  grid_columnconfigure(f3, 1, weight=1)
  grid_rowconfigure(f3, 1, weight=1)
  n3=4
  button=Array(Button(ctrls3,"Change the diffusion's Coefficient for this source"),int(n3/2))
  for i in 1:n3
	if (mod(i,2)==0)
		formlayout(button[int(i/2)],nothing)
	end
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








init_window()