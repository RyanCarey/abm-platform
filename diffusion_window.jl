#include("source_ligand_window.jl")

function window_diffusion(path)
  check_entries1()
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

  global prompts2 =["Probability of persistance","Numbers of direction for a cell","Randomness","D diffusion coefficient","A diffusion coefficient","Tau coefficient","Number of ligand's sources"]
  n2=length(prompts2)
  if(!check_diffusion)
	entries21 = Entry(ctrls2,"0.5")
	entries22 = Entry(ctrls2,"8")
	entries23 = Entry(ctrls2,"1")
	entries24 = Entry(ctrls2,"10")
	entries25 = Entry(ctrls2,"100")
	entries26 = Entry(ctrls2,"150")
	entries27 = Entry(ctrls2,"4")
  else
	entries21 = Entry(ctrls2,"$(float(v2[1]))")
	entries22 = Entry(ctrls2,"$(int(v2[2]))")
	entries23 = Entry(ctrls2,"$(float(v2[3]))")
	entries24 = Entry(ctrls2,"$(int(v2[4]))")
	entries25 = Entry(ctrls2,"$(int(v2[5]))")
	entries26 = Entry(ctrls2,"$(int(v2[6]))")
	entries27 = Entry(ctrls2,"$(int(v2[7]))")
  end	
  
  global entries2 = [entries21,entries22,entries23,entries24,entries25,entries26,entries27]
  for i in 1:n2
    if(i==4)
	l  = Label(ctrls2, "")
	formlayout(l,nothing)	
    end	

    if(i==7)	
	formlayout(b2, nothing)
	l  = Label(ctrls2, "")
	formlayout(l,nothing)
    end	
    formlayout(entries2[i],string(prompts2[i],": "))
  end
  focus(entries2[1]) 
  

  #f3 = Frame(w2); pack(f3, expand = true, fill = "both")
  grid(Label(f2, "Move the cursor to plot the diffusion over time: "), 2, 1,sticky="e")
  global sc = Slider(f2, 1:int(v[3]))
  l = Label(f2)
  l[:textvariable] = sc[:variable]
  grid(sc, 2, 2, sticky="ew")
  grid(l,  3, 2, sticky="w")
  bind(sc, "command", plot_diffusion)

  #First plot of the concentration
  result = Array(Float64,int(sqrt(v[4]^2+v[5]^2)),1)
  for x in 1:int(sqrt(v[4]^2+v[5]^2))
  	global distance_source_squared = int(x)
	timediff = get_value(sc)	
	tau0 = int(get_value(entries2[6]))
  	(res,tmp)=quadgk(integrand_entry,0,min(timediff,tau0))
	result[x]=res
  end
  p=plot(result)
  xlabel("Distance from source")
  ylabel("Concentration")
  display(canvas2,p)

  #If the button b2 is clicked on
  for i in ["command","<Return>","<KP_Enter>"] 
     bind(b2,i,plot_diffusion)
  end

  b1 = Button(ctrls2, "Ligand's source location")
  # displays the button
  formlayout(b1, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
     bind(b1,i,window_ligand)
  end
  b3 = Button(ctrls2, "Ok")
  # displays the button
  formlayout(b3, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
     bind(b3,i,destroy_diffusion_window)
  end

end


##########################################################################################################
function destroy_diffusion_window(path)
  check_entries2()
  destroy(w2) 
end

##########################################################################################################
function plot_diffusion(path)
  check_entries2()
  result = Array(Float64,int(sqrt(v[4]^2+v[5]^2)),1)
  for x in 1:int(sqrt(v[4]^2+v[5]^2))
  	global distance_source_squared = int(x)
	timediff = get_value(sc)	
	tau0 = v2[6]
  	(res,tmp)=quadgk(integrand_entry,0,min(timediff,tau0))
	result[x]=res
  end
  p=plot(result)
  xlabel("Distance from source")
  ylabel("Concentration")
  display(canvas2,p)
  
end

##########################################################################################################
function integrand_entry(tau)
	timediff = get_value(sc)
	A=int(get_value(entries2[5]))
	D=int(get_value(entries2[4]))
	result = A*exp(-distance_source_squared/(4*D*(timediff-tau)))/(4*D*timediff*pi)
	return result
end


##########################################################################################################
function check_entries1()
  n = length(prompts)
  global v = zeros(n,1)
  for i in 1:n
    if prompts[i][1:10]=="Probabilit" || prompts[i][end-4:end]=="(0-1)"
      if !(0 <= float(get_value(entries[i])) <= 1)
        Messagebox(title="Warning", message=string(string(prompts[i])," must be between 0 and 1"))
        return
      end
    end
    if !(0 <= float(get_value(entries[i])))
      Messagebox(title="Warning", message=string(string(prompts[i])," must be positive"))
      return
    end
    try
      v[i] = float(get_value(entries[i]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts[i])))
      return
    end
  end
end

function check_entries2()
  n2 = length(prompts2)
  global v2 = zeros(n2,1)
  for i in 1:n2
    if !(0 <= float(get_value(entries2[i])))
        Messagebox(title="Warning", message=string(string(prompts2[i])," must be positive"))
        return
    end
    if prompts2[i][1:10]=="Probabilit"
      if !(0 <= float(get_value(entries2[i])) <= 1)
        Messagebox(title="Warning", message=string(string(prompts[i])," must be between 0 and 1"))
        return
      end
    end  
    try
      v2[i] = float(get_value(entries2[i]))
    catch
      Messagebox(title="Warning", message=string("Must enter a numeric for field ", string(prompts2[i])))
      return
    end
    global check_diffusion = true
  end  
end
