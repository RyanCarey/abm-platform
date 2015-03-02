function gui_ligand(v::Array, v2::Array,v3::Array, v4::Array, prompts2::Array, entries2::Array)
  println(v3)
  check_entries1(v2, prompts2, entries2)
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
  println("v2[7]: ",v2[7])
  println("v3: ",v3)
  prompts3=["X ordinate of the injury","Y ordinate of the injury"]

  global prompts4 = ["D Diffusion Coefficient","A Diffusion Coefficient","Tau Diffusion Coefficent"]
  global entries3=[]
  global entries4=[]

  for i in 1:v2[7]   # for each source 
    #if(mod(i,2)==1 && i!=1) 
    #l = Label(ctrls3, " ") 
    #formlayout(l,nothing) 
    #l = Label(ctrls4, " ") 
    #formlayout(l,nothing) 
    #end 
    l = Label(ctrls3, "Source $(int(i)):") 
    formlayout(l,nothing) 
    if i <= length(v3)/2    # fill in any values that have previously been entered
      entries3=[entries3,Entry(ctrls3,"$(v3[2*i-1])")]
      entries3=[entries3,Entry(ctrls3,"$(v3[2*i])")] 
      entries4=[entries4,Entry(ctrls4,"$(v4[3*i-2])")] 
      entries4=[entries4,Entry(ctrls4,"$(v4[3*i-1])")] 
      entries4=[entries4,Entry(ctrls4,"$(v4[3*i])")] 
    end
    if i > length(v3) / 2
      entries3=[entries3,Entry(ctrls3,"$(0)")]
      entries3=[entries3,Entry(ctrls3,"$(0)")]
      entries4=[entries4,Entry(ctrls4,"$(10)")]
      entries4=[entries4,Entry(ctrls4,"$(100)")]
      entries4=[entries4,Entry(ctrls4,"$(150)")]
    end
    formlayout(entries3[2*i-1],string(prompts3[1],": ")) 
    formlayout(entries3[2*i],string(prompts3[2],": ")) 
    formlayout(entries4[3*i-2],string(prompts4[1],": ")) 
    formlayout(entries4[3*i-1],string(prompts4[2],": ")) 
    formlayout(entries4[3*i],string(prompts4[3],": "))
  end

  b = Button(ctrls3, "Ok")
  # displays the button
  formlayout(b, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
     bind(b,i,path -> check_entries3(v2[7]))
  end
end
##########################################################################################################
function check_entries3(n_sources::Real)
  println("n sources: ",n_sources)
  global v3 = zeros(2*int(n_sources),1)
  for i in 1:2*n_sources
    try
      v3[i] = float(get_value(entries3[i]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts3[mod(i,2)])))
      return
    end
  end

  global v4 = zeros(3*int(n_sources),1)
  for i in 1:3*n_sources
    try
      v4[i] = float(get_value(entries4[i]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts4[mod(i,3)])," of the source $(floor(i/3+1))."))
      return
    end
  end

  global check_location = true
  destroy(w3)
end
