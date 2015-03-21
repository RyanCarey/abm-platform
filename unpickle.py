
import pickle
def unpickle(filename):
  # pulls pickled file into a list of dictionaries
  contents = []
  with open(filename, "rb") as f:
    while True:
      try:
        print('unpickle')
        contents.append(pickle.load(f))
      except EOFError:
        break
  return contents

def get_coords(arr):
  out = list(arr)
  for i in range(len(arr)):
    out[i] = [arr[i][1],arr[i][2],arr[i][-1]]
  return out

def get_alive_coords(arr):
  return array(get_coords(arr['alive_cells']))

def get_alive_coords_turns(arr):
  out = list(arr)
  for i in range(len(arr)):
    out[i] = get_alive_coords(arr[i])
  return out

def get_all(filenames):
  out = list(filenames)
  for i in range(len(filenames)):
    out[i] = get_alive_coords_turns(load(filenames[i]))
  return out

def get_all2(filenames):
  out = list(filenames)
  for i in range(len(filenames)):
    out[i] = get_alive_coords_turns(unpickle(filenames[i]))
  return out

def stack(arr):
  # takes array of lots of simulations and organizes them by turn
  lengths = [len(i) for i in arr]
  arr = [i for i in arr if len(i)==max(lengths)]  #remove truncated simulations
  out = [vstack([i[j] for i in arr]) for j in range(max(lengths))] # stack first timestep from each simulation
  print('lengths of initial arrays: ',lengths)
  return out

