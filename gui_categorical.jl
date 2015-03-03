# GUI for program that simulates stem cells via categorical locations
@everywhere include("main_v2.jl")
@everywhere include("new_types.jl")
@everywhere include("functions.jl")
using Tk
using Cairo

global win = Toplevel("Categorical Simulator", 250, 300)
global frame = Frame(win); pack(frame, expand=true, fill="both")

prompts = ["Amount of Cells: ", "Time Steps: "]
amt_cells = Entry(frame, "1000")
timesteps = Entry(frame, "1000")
ok_button = Button(frame, "OK")

formlayout(amt_cells, prompts[1])
formlayout(timesteps, prompts[2])
formlayout(ok_button, nothing)

bind(ok_button, "command", path -> run(int(get_value(amt_cells)), int(get_value(timesteps))))

function run(cells::Int, tsteps::Int)
	main(tsteps, cells)
end

if !isinteractive()
    while true
      a = readline(STDIN)
      if a == "exit"
        return
      end
    end
end
