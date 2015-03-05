function gui_diffusion(v::Array, v2::Array, prompts::Array, entries::Array,rb_value,diff_type)
  check_entries1(v, prompts, entries)
  global w2 = Toplevel("Diffusion Parameters",350,385) ## title, width, height
  global f2 = Frame(w2) 
  pack(f2, expand=true, fill="both")
  global canvas2 = Canvas(f2, 300, 300)
  grid(canvas2, 1, 2, sticky="news")
  ctrls2 = Frame(f2)
  grid(ctrls2, 1, 1, sticky="nw", pady=5, padx=5)
  grid_columnconfigure(f2, 1, weight=1)
  grid_rowconfigure(f2, 1, weight=1)


  #Button definition
  b2 = Button(ctrls2, "See diffusion")

  if(diff_type=="Integrative")
    prompts2 =["Probability of persistance","Numbers of direction for a cell","Randomness",
             "Gradient Coeffient","Initial Coencentration","Upper time integrative limit","Number of sources"]
    global entries2 = [Entry(ctrls2,"$(float(v2[1]))"),
                       Entry(ctrls2,"$(int(v2[2]))"),
                       Entry(ctrls2,"$(float(v2[3]))"), 
                       Entry(ctrls2,"$(int(v2[4]))"),
                       Entry(ctrls2,"$(int(v2[5]))"),
                       Entry(ctrls2,"$(int(v2[6]))"),
                       Entry(ctrls2,"$(int(v2[7]))")]
  else
    prompts2 =["Probability of persistance","Numbers of direction for a cell","Randomness",
             "Initial Concentration","Gradient Coeffient","Number of sources"]
    global entries2 = [Entry(ctrls2,"$(float(v2[1]))"),
                       Entry(ctrls2,"$(int(v2[2]))"),
                       Entry(ctrls2,"$(float(v2[3]))"), 
                       Entry(ctrls2,"$(int(v2[8]))"),
                       Entry(ctrls2,"$(float(v2[9]))"),
                       Entry(ctrls2,"$(int(v2[7]))")]
  end

  n2=length(prompts2)
  
  for i in 1:n2
    if(i==4)
      l  = Label(ctrls2, "")
      formlayout(l,nothing) 
    end 
    if(i==7 && diff_type=="Integrative" || i==6 && diff_type=="Normal")  
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


  #f3 = Frame(w2); pack(f3, expand = true, fill = "both")
  grid(Label(f2, "Move the cursor to plot the diffusion over time: "), 2, 1,sticky="e")
  global sc = Slider(f2, 1:int(v[2]))
  l = Label(f2)
  l[:textvariable] = sc[:variable]
  grid(sc, 2, 2, sticky="ew")
  grid(l,  3, 2, sticky="w")
  bind(sc, "command", path -> plot_diffusion(v, v2, prompts2, entries2,diff_type))

  #First plot of the concentration
  result = Array(Float64,int(sqrt(v[3]^2+v[4]^2))+1,1)
  for x in 0:int(sqrt(v[3]^2+v[4]^2))
  global distance_source_squared = int(x)
  timediff = get_value(sc)  
    if(diff_type=="Integrative")
      tau0 = int(v2[6])
      (res,tmp)=quadgk(integrand_entry,0,min(timediff,tau0))
      result[x+1]=res
    else
      result[x+1]=v2[8]/sqrt(v2[9]*timediff*4*pi)*exp(-x^2/(v2[9]*timediff*4))
    end
  end
  p=plot(result)
  xlabel("Distance from source")
  ylabel("Concentration")
  display(canvas2,p)

  #If button b2 is clicked
  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b2,i,path -> plot_diffusion(v, v2, prompts2, entries2,diff_type))
  end

  b1 = Button(ctrls2, "Location and Coefficients")
  # displays the button
  formlayout(b1, "Choose source ligand location and coefficients")
  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b1,i,path -> gui_ligand(v, v2, v3, v4,v5, prompts2, entries2,get_value(rb),diff_type))
  end
  b3 = Button(ctrls2, "Ok")
  # displays the button
  formlayout(b3, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b3,i, path -> destroy_diffusion_window(w2, v2, prompts2, entries2,get_value(rb)))
  end
end

##########################################################################################################
function destroy_diffusion_window(w2::Tk.Tk_Toplevel, v2::Array, prompts2::Array, entries2::Array,value_rb)
  rb_value[1]=value_rb
  check_entries1(v2, prompts2, entries2)
  destroy(w2) 
end

##########################################################################################################
function plot_diffusion(v::Array, v2::Array, prompts2::Array, entries2::Array,diff_type)
  check_entries1(v2, prompts2, entries2)
  result = Array(Float64,int(sqrt(v[3]^2+v[4]^2))+1,1)
  for x in 0:int(sqrt(v[3]^2+v[4]^2))
    global distance_source_squared = int(x)
    timediff = get_value(sc)  
    if(diff_type=="Integrative")
      tau0 = int(get_value(entries2[6]))
      (res,tmp)=quadgk(integrand_entry,0,min(timediff,tau0))
      result[x+1]=res
    else
      amplitude=float(get_value(entries2[4]))
      D=float(get_value(entries2[5]))
      result[x+1]=float(amplitude/sqrt(4*pi*D*timediff)*exp(-x^2/(4*D*timediff)))
    end
  end
  p=plot(result)
  xlabel("Distance from source")
  ylabel("Concentration")
  display(canvas2,p)
end

##########################################################################################################
function integrand_entry(tau::Real)
  timediff = get_value(sc)
  A=int(get_value(entries2[5]))
  D=float(get_value(entries2[4]))
  result = A*exp(-distance_source_squared/(4*D*(timediff-tau)))/(4*D*timediff*pi)
  return result
end

##########################################################################################################
