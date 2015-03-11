function gui_diffusion(v::Vector{Real}, v2::Vector{Real}, prompts::Array, entries::Array,rb_value,diff_type)
  check_entries(v, prompts, entries)
  global w2 = Toplevel("Diffusion Parameters",350,385) ## title, width, height
  global f2 = Frame(w2) 
  pack(f2, expand=true, fill="both")
  global canvas2 = Canvas(f2, 300, 300)
  grid(canvas2, 1, 2, sticky="news")
  ctrls2 = Frame(f2)
  grid(ctrls2, 1, 1, sticky="nw", pady=5, padx=5)
  grid_columnconfigure(f2, 1, weight=1)
  grid_rowconfigure(f2, 1, weight=1)

  println(v2)

  if(diff_type=="Integrative")
    prompts2 =["Numbers of direction for a cell","Initial Concentration","Gradient Coeffient","Upper time integrative limit","Number of sources"]
    global entries2 = [Entry(ctrls2,"$(float(v2[1]))"),
                       Entry(ctrls2,"$(int(v2[2]))"),
                       Entry(ctrls2,"$(float(v2[3]))"), 
                       Entry(ctrls2,"$(int(v2[4]))"),
                       Entry(ctrls2,"$(float(v2[5]))")]
  else
    prompts2 =["Numbers of direction for a cell","Initial Concentration","Gradient Coeffient","Number of sources"]
    global entries2 = [Entry(ctrls2,"$(float(v2[1]))"),
                       Entry(ctrls2,"$(float(v2[6]))"),
                       Entry(ctrls2,"$(float(v2[7]))"),
                       Entry(ctrls2,"$(int(v2[5]))")]
  end

  #Display
  n2=length(prompts2)
  b2 = Button(ctrls2, "See diffusion")
  for i in 1:n2
    if(i==2)
      l  = Label(ctrls2, "")
      formlayout(l,nothing) 
    end 
    if(i==5 && diff_type=="Integrative" || i==4 && diff_type=="Normal")  
      formlayout(b2, nothing)
      l  = Label(ctrls2, "")
      formlayout(l,nothing)
      global rb = Radio(ctrls2, ["Point", "Line"])
      set_value(rb,rb_value[1])
      formlayout(rb, "Type of source: ")
    end 
    formlayout(entries2[i],string(prompts2[i],": "))
  end
  focus(entries2[1]) 

  #Time Slider
  grid(Label(f2, "Move the cursor to plot the diffusion over time: "), 2, 1,sticky="e")
  global sc = Slider(f2, 1:int(v[2]))
  l = Label(f2)
  l[:textvariable] = sc[:variable]
  grid(sc, 2, 2, sticky="ew")
  grid(l,  3, 2, sticky="w")
  bind(sc, "command", path -> plot_diffusion(v, v2, prompts2, entries2,diff_type))

  #First plot of the concentration
  plot_diffusion(v, v2, prompts2, entries2,diff_type)

  #If button b2 is clicked
  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b2,i,path -> plot_diffusion(v, v2, prompts2, entries2,diff_type))
  end

  # display
  b1 = Button(ctrls2, "Location and Coefficients")
  formlayout(b1, "Choose source ligand location and coefficients")
  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b1,i,path -> gui_ligand(v, v2, v3p,v3l, v4,v5, prompts2, entries2,get_value(rb),diff_type))
  end

  # display
  b3 = Button(ctrls2, "Ok")
  formlayout(b3, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b3,i, path -> destroy_diffusion_window(w2, v2, prompts2, entries2,get_value(rb),diff_type))
  end
end

##########################################################################################################
function destroy_diffusion_window(w2::Tk.Tk_Toplevel, v2::Array, prompts2::Array, entries2::Array,value_rb,diff_type)
  rb_value[1]=value_rb
  check_entries2(v2, prompts2, entries2,diff_type)
  destroy(w2) 
end

##########################################################################################################
function plot_diffusion(v::Array, v2::Array, prompts2::Array, entries2::Array,diff_type)
  check_entries2(v2, prompts2, entries2,diff_type)
  result = Array(Float64,int(sqrt(v[3]^2+v[4]^2))+1,1)
  timediff=int(get_value(sc)/v[1]+1)
  try
  for x in 0:int(sqrt(v[3]^2+v[4]^2))
    global distance_source_squared = int(x)
    if(diff_type=="Integrative")
      tau0 = int(get_value(entries2[4]))
      (result[x+1],tmp)=quadgk(integrand_entry,0,min(timediff,tau0))
    else
      amplitude=float(get_value(entries2[2]))
      D=float(get_value(entries2[3]))
      result[x+1]=float(amplitude/sqrt(4*pi*D*timediff)*exp(-x^2/(4*D*timediff)))
    end
  end
  p=plot(result)
  xlabel("Distance from source")
  ylabel("Concentration")
  display(canvas2,p)
  catch
	Messagebox(title="Warning", message="Cannot display with those parameters. Please choose others.")
        return
  end
end

##########################################################################################################
function integrand_entry(tau::Float64)

  timediff = int(get_value(sc))
  A=float(get_value(entries2[2]))
  D=float(get_value(entries2[3]))
  result = A*exp(-distance_source_squared/(4*D*(timediff-tau)))/(4*D*timediff*pi)
  return result
end

############################################################################################################
function check_entries2(v2::Array, prompts2::Array, entries2::Array,diff_type)

if(diff_type=="Integrative")

  for i in 1:length(prompts2)
    try
      v2[i] = float(get_value(entries2[i]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts2[i])))
      return
    end
  end

else


    try
      v2[1] = float(get_value(entries2[1]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts2[1])))
      return
    end
    try
      v2[6] = float(get_value(entries2[2]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts2[2])))
      return
    end
    try
      v2[7] = float(get_value(entries2[3]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts2[3])))
      return
    end
    try
      v2[5] = float(get_value(entries2[4]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts2[4])))
      return
    end
  end

end
