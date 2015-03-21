function gui_diffusion(v::Vector{Float64}, v2::Vector{Float64}, prompts::Array, entries::Array,rb_value::Array{ASCIIString,1},diff_type::ASCIIString)
  #actualization of the parameters of the first window
  check_entries(v, prompts, entries)

  #Initialization of the window
  global w2 = Toplevel("Diffusion Parameters",350,385) ## title, width, height
  global f2 = Frame(w2) 
  pack(f2, expand=true, fill="both")
  grid_columnconfigure(f2, 1, weight=1)
  grid_rowconfigure(f2, 1, weight=1)


  #Choice of the default parameters depending of the diffusion type
  if(diff_type=="Integrative")
    prompts2 =["Number of ligand receptors","Initial Concentration","Gradient Coefficient","Upper time integrative limit","Number of sources"]
    global entries2 = [Entry(f2,"$(float(v2[1]))"),
                       Entry(f2,"$(float(v2[2]))"),
                       Entry(f2,"$(float(v2[3]))"), 
                       Entry(f2,"$(int(v2[4]))"),
                       Entry(f2,"$(int(v2[5]))")]
    #In the case of the integrative diffusion, there is one more parmeter. So in order to locate properly the elements on the grid, we add a parameter.                   
    plusintegrative=1 
  else
    prompts2 =["Number of directions for a cell","Initial Concentration","Gradient Coefficient","Number of sources"]
    global entries2 = [Entry(f2,"$(float(v2[1]))"),
                       Entry(f2,"$(float(v2[6]))"),
                       Entry(f2,"$(float(v2[7]))"),
                       Entry(f2,"$(int(v2[5]))")]
    plusintegrative=0
  end
  #Help button creation
  bhelp = [Button(f2,"?") Button(f2,"?") Button(f2,"?") Button(f2,"?") Button(f2,"?") Button(f2,"?") Button(f2,"?")]
  #We adjuste the size of the buttons
  for i in bhelp
    i[:width]=1
  end
  #Creation of the labels to give information to the user. 
  l=[]
  for i in 1:length(prompts2)
    l=[l,Label(f2,string(prompts2[i],": "))]
  end
  #Display of the first input: Number of ligand receptors
  grid(l[1],1,1,sticky="e")
  grid(entries2[1],1,2,sticky="ew")
  grid(bhelp[1],1,3,sticky="w")
  bind(bhelp[1], "command", path -> Messagebox(title="Help", message="Input the number of receptors of ligand for the cell. This is also the number of directions the cell can go. Besides, the smaller this coefficient is the fatser the software will work."))
  #Gap
  l1  = Label(f2, "")
  grid(l1,2,1:3) 
  #Display of the input of the diffusion parameters
  grid(l[2],3,1,sticky="e")
  grid(entries2[2],3,2,sticky="ew")
  grid(bhelp[2],3,3,sticky="w")
  bind(bhelp[2], "command", path -> Messagebox(title="Help", message="This is the A coefficient within the diffusion equation. Increasing this number proportionally increases the ligand concentration. See manual for more information.\nNB: This coefficient only modifies the plot and not the sources parameters."))
  grid(l[3],4,1,sticky="e")
  grid(entries2[3],4,2,sticky="ew")
  grid(bhelp[3],4,3,sticky="w")
  bind(bhelp[3], "command", path -> Messagebox(title="Help", message="This is the D coefficient within the diffusion equation. It is usually called the diffusion coefficient. Decreasing this number make the increases the slopes. It is equivalent to reducing the time diffusion. See manual for more information.\nNB: This coefficient only modifies the plot and not the sources parameters."))
  if(diff_type=="Integrative")
    grid(l[4],5,1,sticky="e")
    grid(entries2[4],5,2,sticky="ew")
    grid(bhelp[7],5,3,sticky="w")
    bind(bhelp[7], "command", path -> Messagebox(title="Help", message="This is the tau coefficient within the diffusion equation. It defines the time during which sources emit ligands. See manual for more information.\nNB: This coefficient only modifies the plot and not the sources parameters."))
  end
  #See diffusion button
  b1=Button(f2,"See Diffusion")
  grid(b1,5+plusintegrative,2,sticky="ew")
  grid(bhelp[4],5+plusintegrative,3,sticky="w")
  bind(bhelp[4], "command", path -> Messagebox(title="Help", message="Click to plot ligand concentration against the distance from one source with the above parameters.\nNB: The curve only allows the user a better understanding of the diffusion and do not affect any real sources."))
  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b1,i,path -> plot_diffusion(v, v2, prompts2, entries2,diff_type, plusintegrative))
  end
  #Gap
  l2  = Label(f2, "")
  grid(l2,6+plusintegrative,1:3)
  #Radio button to choose the kind of sources
  global rb = Radio(f2, ["Point", "Line"])
  set_value(rb,rb_value[1])
  grid(rb,7+plusintegrative,2,sticky="w")
  ltype  = Label(f2, "Type of sources: ")
  grid(ltype,7+plusintegrative,1,sticky="e")
  grid(bhelp[5],7+plusintegrative,3,sticky="e")
  bind(bhelp[5], "command", path -> Messagebox(title="Help", message="Choose the kind of source you want. The diffusion parameters are modifiable by clicking on the 'Location(s) and Coefficients' button."))
  #Gap
  grid(l[4+plusintegrative],8+plusintegrative,1,sticky="e")
  grid(entries2[4+plusintegrative],8+plusintegrative,2,sticky="ew")
  #Button to access the parameters of the sources
  b2 = Button(f2, "Location(s) and Coefficients")
  grid(b2,9+plusintegrative,2,sticky="ew")
  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b2,i,path -> gui_ligand(v, v2, v3p,v3l, v4,v5, prompts2, entries2,get_value(rb),diff_type))
  end
  #Ok button
  b3 = Button(f2, "Ok")
  grid(b3,10+plusintegrative,2,sticky="ew")
  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b3,i, path -> destroy_diffusion_window(w2, v2, prompts2, entries2,get_value(rb),diff_type))
  end
  #Gap
  l3  = Label(f2, "")
  grid(l3,11+plusintegrative,1:3)
  #Information and help button to undertsand how to change the diffusion plot over time.
  grid(Label(f2, "Move the slider to plot the diffusion over time: "), 12+plusintegrative, 1:2,sticky="e")
  grid(bhelp[6],12+plusintegrative,3,sticky="e")
  bind(bhelp[6], "command", path -> Messagebox(title="Help", message="Move the slider to change the diffusion time. This will change the plot."))
  #Display of the canvas
  global canvas2 = Canvas(f2, 300, 300)
  grid(canvas2, 1:11+plusintegrative, 4, sticky="news")
  #Time slider
  global sc = Slider(f2, 1:int(v[2]/v[1]))
  grid(sc,12+plusintegrative, 4, sticky="ew")
  bind(sc, "command", path -> plot_diffusion(v, v2, prompts2, entries2,diff_type,plusintegrative))

  #First plot of the concentration
  plot_diffusion(v, v2, prompts2, entries2,diff_type,plusintegrative)

end

##########################################################################################################
function destroy_diffusion_window(w2::Tk.Tk_Toplevel, v2::Array, prompts2::Array, entries2::Array,value_rb,diff_type)
  rb_value[1]=value_rb
  check_entries2(v2, prompts2, entries2,diff_type)
  destroy(w2) 
end

##########################################################################################################
function plot_diffusion(v::Array, v2::Array, prompts2::Array, entries2::Array,diff_type,plusintegrative)
  #Actualization of v2 thanks to the parameters input in entries2
  check_entries2(v2, prompts2, entries2,diff_type)
  #Initialization
  result = Array(Float64,int(sqrt(v[3]^2+v[4]^2))+1,1)
  timediff=int(get_value(sc))
  l = Label(f2,"Time: $(timediff)  ")
  grid(l, 13+plusintegrative, 4, sticky="w")
  #some parameters may prevent the software from displaying
  try
  #choice of the upper limit for y
  if(diff_type=="Integrative")
	tau0 = int(get_value(entries2[4]))
	ymaxi,tmp=quadgk(integrand_max,0,tau0)
	ymaxi=ceil(ymaxi)
  else
      amplitude=float(get_value(entries2[2]))
      D=float(get_value(entries2[3]))
      ymaxi=ceil(amplitude/sqrt(4*pi*D))
  end
  
  #Display
  for x in 0:int(sqrt(v[3]^2+v[4]^2))
    distance_source_squared = float(int(x))
    if(diff_type=="Integrative")
      tau0 = int(get_value(entries2[4]))
      A=float(get_value(entries2[2]))
      timediff = float(int(get_value(sc)))
      D=float(get_value(entries2[3]))
      (result[x+1],tmp)=quadgk(tau->integrand(tau, timediff, distance_source_squared, D),0,min(timediff,tau0))
      result[x+1] *= A/sqrt(4*D*timediff*pi)
    elseif(diff_type=="Normal")
      amplitude=float(get_value(entries2[2]))
      D=float(get_value(entries2[3]))
      result[x+1]=float(amplitude/sqrt(4*pi*D*timediff)*exp(-x^2/(4*D*timediff)))
    end
  end
  p=plot(result)
  xlabel("Distance from source")
  ylabel("Concentration")
  ylim(0,ymaxi)
  display(canvas2,p)
  catch
    Messagebox(title="Warning", message="Cannot display with those parameters. Please choose others.")
    return
  end
end

#=
function integrand_entry(tau::Float64)
#this is the function we need to integrate when we are in the integrative case
  timediff = int(get_value(sc))
  A=float(get_value(entries2[2]))
  D=float(get_value(entries2[3]))
  result = A*exp(-distance_source_squared/(4*D*(timediff-tau)))/sqrt(4*D*timediff*pi)
  return result
end
=#

##########################################################################################################
function integrand_max(tau::Float64)
#we use this function to calculate the maximum value in order ot to keep the same length axis
  timediff = int(get_value(entries2[4]))
  A=float(get_value(entries2[2]))
  D=float(get_value(entries2[3]))
  result = A/sqrt(4*D*timediff*pi)
  return result
end


############################################################################################################
function check_entries2(v2::Array, prompts2::Array, entries2::Array,diff_type)
#We actualize the value of v2 depending on the kind of diffusion
#v2 is made of
#	 the number of ligand receptors for a cell 
#	 the 3 diffusion coefficients for the integrative case
#	 the number of sources
#	 the 2 diffusion coefficients for the normal case
#But we display in entrie whatever the integration is
#	 the number of ligand receptors for a cell 
#	 the 2/3 diffusion coefficients for the normal/integrative case
#	 the number of sources
#Therefore we need to adapt v2 to entries as follow
if(diff_type=="Integrative")
  for i in 1:length(prompts2)
    try
      v2[i] = float(get_value(entries2[i]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts2[i])))
      return
    end
  end

elseif(diff_type=="Normal")
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
