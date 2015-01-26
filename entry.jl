using Tk
include("pause.jl")


function store_vars(path)
  n = length(prompts)
  v = zeros(n,1)
  for i in 1:n
    try
      v[i] = float(get_value(entries[i]))
    catch
      print("entries[i]",entries[i])
      Messagebox(title="Warning", message=string("must enter a numeric for field ", string(prompts[i])[1:end-2]))
      return false, v
    end
  end
  println("variables stored")
  return true, v
end


function init_window()
  w = Toplevel()
  f = Frame(w); pack(f, expand=true, fill="both")

  global entries = []
  global prompts = ["Number of cells: ", "Speed of cells: ", "Average cell radius: ", "Number of timesteps: ", 
  "Width of environment: ", "Height of environment: "]
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

  # add here some metaprogramming to make this file more brief. also add try/catch for non-numeric input

  const diffusion_rate = .1

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
