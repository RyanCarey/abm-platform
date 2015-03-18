import pickle
def load(filename):
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


