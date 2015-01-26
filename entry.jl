using Tk
include("pause.jl")
include("master_file.jl")

function store_vars(path)
  n = length(prompts)
  for i in 1:n
    try
      v[i] = float(get_value(entries[i]))
    catch
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts[i])[1:end-2]))
      return
    end
  end
  println("variables stored")
  recieved_entry = true
  main()
end

function init_window()
global entries = []
global prompts = ["Number of cells: ", "Speed of cells: ", "Average cell radius: ", "Number of timesteps: ", 
"Width of environment: ", "Height of environment: "]
field_length = length(prompts)
global v = zeros(field_length,1)
  w = Toplevel()
  f = Frame(w); pack(f, expand=true, fill="both")

  n = length(prompts)

  for i in 1:n
    push!(entries, Entry(f))
  end
  b = Button(f, "Ok")

  for i in 1:n
    formlayout(entries[i],prompts[i])
  end
  formlayout(b, nothing)
  focus(entries[1])



  bind(b,"command", store_vars)
  bind(b,"<Return>", store_vars)
  bind(b,"<KP_Enter>", store_vars)
  for i in 1:n
    bind(entries[i], "<Return>", store_vars)
    bind(entries[i], "<KP_Enter>", store_vars)
  end

  if !isinteractive()
    pause(0,"any key to close program")
  end
end

init_window()
