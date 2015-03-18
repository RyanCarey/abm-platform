function gui_ligand(v::Array, v2::Array,v3p::Array,v3l::Array, v4::Array,v5::Array, prompts2::Array, entries2::Array,value_rb,diff_type)

  #Window initialization
  check_entries2(v2, prompts2, entries2,diff_type)

  global w3 = Toplevel("Ligand's source location") ## title, width, height
  global f3 = Frame(w3) 
  pack(f3, expand=true, fill="both")
  ctrls3 = Frame(f3)
  ctrls4 = Frame(f3)
  grid(ctrls3, 1, 1, sticky="nw", pady=5, padx=5)
  grid(ctrls4, 1, 2, sticky="nw", pady=5, padx=5)
  grid_columnconfigure(f3, 1, weight=1)
  grid_rowconfigure(f3, 1, weight=1)
 
  global prompts3=[]
  if(value_rb=="Point")
    prompts3=["X ordinate of the injury","Y ordinate of the injury"]
  else
    prompts3=["X ordinate of the injury"]
  end
  if(diff_type=="Integrative")
    global prompts4 = ["Initial Concentration","Gradient Coeffient","Upper time integrative limit"]
  else
    global prompts4 = ["Initial Concentration","Gradient Coeffient"]
  end
  global entries3=[]
  global entries4=[]

  #choice of the default parameters
  for i in 1:v2[5]   # for each source 
    l = Label(ctrls3, "Source $(int(i)):") 
    formlayout(l,nothing) 
    try #this try allows to put the previous value for the source location and the source parameters
	if(value_rb=="Point")
      	  entries3=[entries3,Entry(ctrls3,"$(v3p[2*i-1])")]
      	  entries3=[entries3,Entry(ctrls3,"$(v3p[2*i])")] 
	else
	  entries3=[entries3,Entry(ctrls3,"$(v3l[i])")]
	end
      if(diff_type=="Integrative")
        entries4=[entries4,Entry(ctrls4,"$(v4[3*i-2])")] 
        entries4=[entries4,Entry(ctrls4,"$(v4[3*i-1])")] 
        entries4=[entries4,Entry(ctrls4,"$(v4[3*i])")] 
      else
        entries4=[entries4,Entry(ctrls4,"$(v5[2*i-1])")] 
        entries4=[entries4,Entry(ctrls4,"$(v5[2*i])")] 
      end
    catch #otherwise we put the default values
	if(value_rb=="Point")
	  entries3=[entries3,Entry(ctrls3,"$(0.0)")]
      	  entries3=[entries3,Entry(ctrls3,"$(0.0)")]
	else
	  entries3=[entries3,Entry(ctrls3,"$(0.0)")]
	end
      if(diff_type=="Integrative")
        entries4=[entries4,Entry(ctrls4,"$(100.0)")]
        entries4=[entries4,Entry(ctrls4,"$(1.0)")]
        entries4=[entries4,Entry(ctrls4,"$(10.0)")]
      else
        entries4=[entries4,Entry(ctrls4,"$(100.0)")]
        entries4=[entries4,Entry(ctrls4,"$(1.0)")]
      end
    end

  #display  
    if(value_rb=="Point")
      formlayout(entries3[2*i-1],string(prompts3[1],": ")) 
      formlayout(entries3[2*i],string(prompts3[2],": ")) 
      l3 = Label(ctrls3, " ") 
      formlayout(l3,nothing) 
    else
      formlayout(entries3[i],string(prompts3[1],": "))
      l3 = Label(ctrls3, " ") 
      formlayout(l3,nothing) 
      l3 = Label(ctrls3, " ") 
      formlayout(l3,nothing) 
    end
    if(diff_type=="Integrative")
      formlayout(entries4[3*i-2],string(prompts4[1],": ")) 
      formlayout(entries4[3*i-1],string(prompts4[2],": ")) 
      formlayout(entries4[3*i],string(prompts4[3],": "))
    else
      l4 = Label(ctrls4, " ") 
      formlayout(l4,nothing) 
      formlayout(entries4[2*i-1],string(prompts4[1],": ")) 
      formlayout(entries4[2*i],string(prompts4[2],": "))
    end
    if(i!=5)
    l4 = Label(ctrls4, " ") 
    formlayout(l4,nothing) 
    end
  end

  #End button
  b = Button(ctrls3, "Ok")
  formlayout(b, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
     bind(b,i,path -> check_entries3(v2[5],value_rb,diff_type))
  end

  #Help button
  bhelp = Button(ctrls4, "Need Help ?")
  formlayout(bhelp, nothing)
  bind(bhelp, "command", path -> Messagebox(title="Help", message="Here you choose for each source its location and its coefficient. Use the previous window to choose the diffusion coefficient with care. NB: the diffusion coefficients of the previous window are only useful to plot the curve."))
end
##########################################################################################################
function check_entries3(n_sources::Real,value_rb,diff_type)
#We store in the global variable v3, v4 and v5 the sources location and parameters


  #Source location
  if(value_rb=="Point")
    global v3p = zeros(2*int(n_sources),1)
    for i in 1:2*int(n_sources)
      try
        v3p[i] = float(get_value(entries3[i]))
      catch
        Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts3[mod(i,2)])))
        return
      end
    end
  else
    global v3l = zeros(int(n_sources),1)
    for i in 1:int(n_sources)
      try
        v3l[i] = float(get_value(entries3[i]))
      catch
        Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts3[1])))
        return
      end
    end

  end


  #source parameters
  if(diff_type=="Integrative")
    global v4 = zeros(3*int(n_sources),1)
    for i in 1:3*n_sources
      try
        v4[i] = float(get_value(entries4[i]))
      catch
        Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts4[mod(i,3)])," of the source $(floor(i/3+1))."))
        return
      end
    end
  else
    global v5 = zeros(2*int(n_sources),1)
    for i in 1:2*n_sources
      try
        v5[i] = float(get_value(entries4[i]))
      catch
        Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts4[mod(i,2)])," of the source $(floor(i/2+1))."))
        return
      end
    end

  end

  destroy(w3)
end
