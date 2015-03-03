using PyCall
@pyimport pickle

function pickle_dict(filename,dict)
  pickle_string = pickle.dumps(dict)
  f = open(filename,"a")
  write(f, pickle_string)
  close(f)
end

function unpickle_from_point(filename::String, pointer::Int=1)
  # unpickles a pickle file starting from a particular character and returns the next unread character
  # this is a workaround for pickle.load, which doesn't work in pycall for julia
  pickle_file = readall(filename)
  target_string = pickle_file[pointer:end]
  dict = pickle.loads(target_string)
  pickle_string_length = pointer + length(pickle.dumps(dict))
  if pickle_string_length > length(pickle_file)
    pickle_string_length = -1
  end
  return dict, pickle_string_length
end

function unpickle_file(filename::String)
  pointer = 1
  output = []
  while pointer >= 0
    input_dict, pointer = unpickle_from_point(filename,pointer)
    output = push!(output, input_dict)
  end
  return output
end

function pickle_out(filename::String, alive_cells::Array, dead_cells::Array)
  output = Dict("alive_cells"=>cells_to_matrix(alive_cells), "dead_cells"=> cells_to_matrix(dead_cells))
  pickle_dict(filename,output)
end

function pickle_start(filename::String, t::String, v::Array, v2::Array, v3::Array, v4::Array, v8::Array, v9::Array,
                      border_settings::Array, alive_cells::Array)
  alive_cell_matrix = cells_to_matrix(alive_cells)
  output = Dict("simulation_start_time"=>t, "global_parameters"=>v, "diffusion_parameters"=>v2, "ligand_parameters"=>v3, 
                            "ligand_diffusion_parameters"=>v4, "cell_type_parameters"=>v8, "more_cell_type_parameters"=>v9, 
                            "border_settings"=>border_settings, "alive_cells"=>alive_cell_matrix)
  pickle_dict(filename,output)
end

function cells_to_matrix(cells)
  # takes array of cell objects and returns matrix of Any (but no Cell types), facilitating pickling
  cell_matrix = fill("",length(cells),8)
  for (i,j) in enumerate(cells)
    cell_matrix[i,1:end] = [string(j.name) string(j.x) string(j.y) string(j.r) string(j.angle) string(j.speed) string(j.offspring) string(j.cell_type)]
  end
  return cell_matrix
end
