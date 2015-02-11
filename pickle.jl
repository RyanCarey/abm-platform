using PyCall
@pyimport pickle

function pickle_save(filename,dict)
  binary_dict = pickle.dumps(dict)
  f = open(filename,"a")
  write(f, binary_dict)
  close(f)
end

function pickle_load(filename)
  binary_dict = readall(dump.pickle)
  dict pickle.loads(binary_dict)
  return dict


