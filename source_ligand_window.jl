

function window_ligand(path)

  check_entries2()
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
  for i in 1:int(get_value(entries2[6]))
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
	if(!check_location)
		if(mod(i,2)==1)
			entries3=[entries3,Entry(ctrls3,"0.0")]
			formlayout(entries3[i],string(prompts3[i],": "))
		else
			entries3=[entries3,Entry(ctrls3,"$((i-1)/(2*v2[6])*v[6])")]
			formlayout(entries3[i],string(prompts3[i],": "))
		end
	else
		try
		entries3=[entries3,Entry(ctrls3,"$(v3[i])")]
		formlayout(entries3[i],string(prompts3[i],": "))
		catch
		if(mod(i,2)==1)
			entries3=[entries3,Entry(ctrls3,"0.0")]
			formlayout(entries3[i],string(prompts3[i],": "))
		else
			entries3=[entries3,Entry(ctrls3,"$((i-1)/(2*v2[6])*v[6])")]
			formlayout(entries3[i],string(prompts3[i],": "))
		end
		end
	end
	if(mod(i,2)==1)
		if(i!=1)
		l  = Label(ctrls4, " ")
		formlayout(l,nothing)	
		end
		if(!check_location)
			entries4=[entries4,Entry(ctrls4,"10.0")]
			formlayout(entries4[end],string(prompts4[1],": "))
			entries4=[entries4,Entry(ctrls4,"100.0")]
			formlayout(entries4[end],string(prompts4[2],": "))
			entries4=[entries4,Entry(ctrls4,"150.0")]
			formlayout(entries4[end],string(prompts4[3],": "))
		else
			try
			entries4=[entries4,Entry(ctrls4,"$(v4[3*(floor((i+1)/2))-2])")]
			formlayout(entries4[end],string(prompts4[1],": "))
			entries4=[entries4,Entry(ctrls4,"$(v4[3*(floor((i+1)/2))-1])")]
			formlayout(entries4[end],string(prompts4[2],": "))
			entries4=[entries4,Entry(ctrls4,"$(v4[3*(floor((i+1)/2))])")]
			formlayout(entries4[end],string(prompts4[3],": "))
			catch
			entries4=[entries4,Entry(ctrls4,"10.0")]
			formlayout(entries4[end],string(prompts4[1],": "))
			entries4=[entries4,Entry(ctrls4,"100.0")]
			formlayout(entries4[end],string(prompts4[2],": "))
			entries4=[entries4,Entry(ctrls4,"150.0")]
			formlayout(entries4[end],string(prompts4[3],": "))
			end
		end			
	end
  end

  b = Button(ctrls3, "Ok")
  # displays the button
  formlayout(b, nothing)
  for i in ["command","<Return>","<KP_Enter>"] 
     bind(b,i,check_entries3)
  end
end
##########################################################################################################
function check_entries3(path)
  
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

  global check_location = true
  destroy(w3)

end
