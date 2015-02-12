using PyCall
@pyimport pickle

## must set it up to turn cell lists into matrices


function pickle_to_file(filename,dict)
  binary_dict = pickle.dumps(dict)
  f = open(filename,"a")
  write(f, binary_dict)
  close(f)
end

function unpickle_from_file(filename)
  binary_dict = readall(filename)
  dict = pickle.loads(binary_dict)
  return dict
end

function start_output(filename::String, t::String, v::Array, alive_cells::Array)
  labels = ["t",prompts,"alive_cells","dead_cells"]
  values = [t,v,alive_cells,dead_cells]
  output = [zip(labels,values)]
  output_dict = Dict(output)
  f = open(filename,"a")
  pickle_to_file(filename,output_dict)
  close(f)
end

function pickle_out(filename::String, alive_cells::Array, dead_cells::Array)
  labels=["alive_cells","dead_cells"]
  values = [alive_cells, dead_cells]
  output = Dict([zip(labels,values)])
  output_dict = Dict(output)
  f = open(filename,"a")
  pickle_to_file(filename,output_dict)
  close(f)
end
