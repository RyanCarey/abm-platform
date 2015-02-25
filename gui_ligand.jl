function window_ligand()
  check_entries1()
  check_entries2()
  check_entries3(v2)
  global check_location = true

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
    if(mod(i,2)==1)
      entries3=[entries3,Entry(ctrls3,"0.0")]
      formlayout(entries3[i],string(prompts3[i],": "))
    else
      entries3=[entries3,Entry(ctrls3,"$((i-2)/(2*v2[7]-2)*v[4])")]
      formlayout(entries3[i],string(prompts3[i],": "))
    end

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

  b = Button(ctrls3, "Ok")
  # displays the button
  formlayout(b, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
     bind(b,i,path -> destroy_ligand_window(v2))
  end
end
##########################################################################################################
function check_entries3(v2)
  if(!check_location)
	check_entries1()
	check_entries2()
	v3=Array(Float64,2*int(v2[7]))
	v4=Array(Float64,3*int(v2[7]))
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
  return v3,v4
end
##########################################################################################################
function destroy_ligand_window(v2)
  check_entries3(v2)
  destroy(w3)
end
