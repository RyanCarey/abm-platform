function window_ligand(v::Array, v2::Array, prompts2::Array)
  # check data from diffusion window
  check_entries2(v2, prompts2)
  global w3 = Toplevel("Ligand's source location") ## title, width, height
  global f3 = Frame(w3) 
  pack(f3, expand=true, fill="both")
  ctrls3 = Frame(f3)
  ctrls4 = Frame(f3)
  grid(ctrls3, 1, 1, sticky="nw", pady=5, padx=5)
  grid(ctrls4, 1, 2, sticky="nw", pady=5, padx=5)
  grid_columnconfigure(f3, 1, weight=1)
  grid_rowconfigure(f3, 1, weight=1)

  ###########################
  #Discrete case
  if(get_value(rb)=="Point")
    v3=Array(Float64,2*int(v2[7]))
    v4=Array(Float64,3*int(v2[7]))
    for i in 1:v2[7]
      v3[2*i-1]=0
      v3[2*i]=(i-1)/(v2[7]-1)*v[4]
      v4[3*i-2]=10
      v4[3*i-1]=100
      v4[3*i]=150	
    end
    global check_location = true
    global prompts3=[]
    for i in 1:v2[7]
      prompts3=[prompts3,"X ordinate of the injury","Y ordinate of the injury"]
    end
    global prompts4 = ["D Diffusion Coefficient","A Diffusion Coefficient","Tau Diffusion Coefficent"]
    n3=length(prompts3) # 2 times the number of sources
    global entries3=[]
    global entries4=[]

    for i in 1:n3
      if(mod(i,2)==1)
        if(i!=1)
          l  = Label(ctrls3, " ")
          formlayout(l,nothing)	
        end
        l  = Label(ctrls3, "Source $(int((i+1)/2)):")
        formlayout(l,nothing)	
      end
      entries3=[entries3,Entry(ctrls3,"$(v3[i])")]
      formlayout(entries3[i],string(prompts3[i],": "))
      if(mod(i,2)==1)
        if(i!=1)
          l  = Label(ctrls4, " ")
          formlayout(l,nothing)	
        end
          entries4=[entries4,Entry(ctrls4,"$(v4[3*(floor((i+1)/2))-2])")]
          formlayout(entries4[end],string(prompts4[1],": "))
          entries4=[entries4,Entry(ctrls4,"$(v4[3*(floor((i+1)/2))-1])")]
          formlayout(entries4[end],string(prompts4[2],": "))
          entries4=[entries4,Entry(ctrls4,"$(v4[3*(floor((i+1)/2))])")]
          formlayout(entries4[end],string(prompts4[3],": "))
      end
    end
  ###########################
  #Continuous case
  else
    if(!check_location)
      global v3=Array(Float64,int(v2[7]))
      global v4=Array(Float64,3*int(v2[7]))
      for i in 1:v2[7]
        v3[i]=(i-1)/(v2[7]-1)*v[3]
        v4[3*i-2]=10
        v4[3*i-1]=100
        v4[3*i]=150	
      end
    end
    global check_location = true
    global prompts3=[]
    global prompts4=[]
    for i in 1:v2[7]
      prompts3=[prompts3,"X ordinate of the injury"]
      prompts4 = [prompts4,"D Diffusion Coefficient","A Diffusion Coefficient","Tau Diffusion Coefficent"]
    end
    n3=length(prompts3) 
    global entries3=[]
    global entries4=[]
    for i in 1:n3
      if(i!=1)
        l  = Label(ctrls3, " ")
        formlayout(l,nothing)	
      end
      l  = Label(ctrls3, "Source $(i):")
      formlayout(l,nothing)	

      entries3=[entries3,Entry(ctrls3,"$(v3[i])")]
      formlayout(entries3[i],string(prompts3[i],": "))
      l  = Label(ctrls3, " ")
      formlayout(l,nothing)
    end
    for i in 1 : length(prompts4)
      if(i!=1 && mod(i,3)==1)
        l  = Label(ctrls4, " ")
        formlayout(l,nothing)	
      end
        entries4=[entries4,Entry(ctrls4,"$(v4[i])")]
        formlayout(entries4[i],string(prompts4[i],": "))
    end
  end
  b = Button(ctrls3, "Ok")
  # displays the button
  formlayout(b, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
    bind(b,i,path -> destroy_ligand_window())
  end
end
##########################################################################################################
function check_entries3()
  if(!check_location)
	v=check_entries1()
	check_entries2()
	global v3=Array(Float64,2*int(v2[7]))
	global v4=Array(Float64,3*int(v2[7]))
	for i in 1:v2[7]
		v3[2*i-1]=0
		v3[2*i]=(i-1)/(v2[7]-1)*v[4]
		v4[3*i-2]=10
 		v4[3*i-1]=100
 		v4[3*i]=150	
  	end
  else
    n3=length(prompts3)
    global v3 = zeros(n3,1)
    for i in 1:n3
      try
        v3[i] = float(get_value(entries3[i]))
      catch
        Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts3[i])))
        return
      end
    end
  n4=length(entries4)
  global v4 = zeros(n4,1)
  for i in 1:n4
    try
	    v4[i] = float(get_value(entries4[i]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts4[mod(i,3)])," of the source $(floor(i/3+1))."))
      return
    end
  end
  end
end
##########################################################################################################
function destroy_ligand_window()
  check_entries3()
  destroy(w3)
end
