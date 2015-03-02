# GUI for program that simulates stem cells via categorical locations
include("main_v2.jl")
include("types.jl")
include("functions.jl")
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

bind(ok_button, "command", path -> run(get_value(amt_cells), get_value(timesteps)))

function run(cells::Int, tsteps::Int)
	main(tsteps, cells)
end
