function pickle_dict(filename::String,dict::Dict)
  pickle_string = pickle.dumps(dict)
  f = open(filename, "a")
  write(f, pickle_string)
  close(f)
end

function unpickle_from_pointer(filename::String, pointer::Int=1)
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

function unpickle(filename::String)
  pointer = 1
  output = []
  while pointer >= 0
    input_dict, pointer = unpickle_from_pointer(filename,pointer)
    output = push!(output, input_dict)
  end
  return output
end

function pickle_out(filename::String,i::Int, alive_cells::Array{Cell}, dead_cells::Array{Cell})
  output = Dict("iteration"=>i,"alive_cells"=>cells_to_matrix(alive_cells), "dead_cells"=> cells_to_matrix(dead_cells))
  pickle_dict(filename,output)
end

function pickle_start(filename::String, t::String, n_cell::Real, steps::Int, x_size::Real, y_size::Real, 
                      nb_ligands::Int, nb_source::Int, source_abscisse_ligand::Array,
                      source_ordinate_ligand::Array,
                      v3p::Array, v3l::Array, v4::Array, v8::Array, v9::Array,
                      border_settings::Array, alive_cells::Array)
  alive_cell_matrix = cells_to_matrix(alive_cells)
  output = Dict("simulation_start_time"=>t, "n_cell"=>n_cell, "steps"=>steps, "x_size"=>x_size,"y_size"=>y_size, 
                "probability_persistent"=>probability_persistent, "nb_ligands"=>nb_ligands, "nb_source"=>nb_source,
                "source_abscisse_ligand"=>source_abscisse_ligand, "source_ordinate_ligand"=>source_ordinate_ligand,
                "v3p"=>v3p, "v3l"=>v3l, "v4"=>v4,"v8"=>v8,"v9"=>v9, "border_settings"=>border_settings, "alive_cells"=>alive_cells,
                "alive_cells"=>alive_cell_matrix)
  pickle_dict(filename,output)
end

          #=
  global categories = Cell_type[
          Cell_type(v8[1,1], v8[1,2], v8[1,3], v8[1,4], v8[1,5], v8[1,6], v8[1,7], v8[1,8], v8[1,9], v8[1,10], v9[1,1], v9[1,2], v9[1,3]),
          Cell_type(v8[2,1], v8[2,2], v8[2,3], v8[2,4], v8[2,5], v8[2,6], v8[2,7], v8[2,8], v8[2,9], v8[2,10], v9[2,1], v9[2,2], v9[2,3]),
          Cell_type(v8[3,1], v8[3,2], v8[3,3], v8[3,4], v8[3,5], v8[3,6], v8[3,7], v8[3,8], v8[3,9], v8[3,10], v9[3,1], v9[3,2], v9[3,3]),
          Cell_type(v8[4,1], v8[4,2], v8[4,3], v8[4,4], v8[4,5], v8[4,6], v8[4,7], v8[4,8], v8[4,9], v8[4,10], v9[4,1], v9[4,2], false)]
  global Diffusion_coefficient = Array(Float64,nb_source)
  global A_coefficient= Array(Float64,nb_source)
  global tau0 = Array(Float64,nb_source)
  global diffusion_maximum = Array(Float64,nb_source)
  global diffusion_coefficient = Array(Float64,nb_source)
  global type_source=rb_value[1]
  global type_diffusion=diff_type
  =#

function cells_to_matrix(cells::Array{Cell})
  # turns array of cell objects into matrix of strings and floats, facilitating pickling
  cell_matrix = Array(Any,length(cells),8)
  for (i,j) in enumerate(cells)
    cell_matrix[i,1:end] =  [j.name j.x j.y j.r j.angle j.speed j.offspring j.cell_type]
  end
  return cell_matrix::Array{Any}
end

