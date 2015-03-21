#from __future__ import print_function
from numpy import *
import matplotlib.pyplot as plt
exec(open('unpickle.py').read())

### old ### 
def load_turn(filenames,turn, length):
  filenames = list(copy(filenames))
  positions = []
  while filenames:
    data = load(filenames.pop())
    if len(data)==length:     # check that data has reached full length without error
      cells = array(data[turn]['alive_cells'])
      positions.append(cells[:,[1,2,-1]])
  return positions

def load_all_turns(filenames, length):
  # prevent mutation of filenames list
  filenames = list(copy(filenames))
  b = []
  for i in range(length):
    b.append(load_turn(filenames,i, length))
  return b

def load_all(filenames):
  data = []
  for name in filenames:
    data.append(load(name))
  out = [i[1:] for i in data]

  #extract cell information
  for i in range(len(out)):
    for j in range(len(out[i])):
      out[i][j] = out[i][j]['alive_cells']
    for i in range(len(out)):
      for j in range(len(out[i])):
        for k in range(len(out[i][j])):
          # extract positions
          out[i][j][k] = array(out[i][j][k][1:3])
          out[i][j] = vstack(out[i][j])
  return out

def remove_duds(data):
  for i in range(len(data)):
    for j in range(len(data[i])):
      for k in range(len(data[i][j])):
        try:
          out = data[i][j][k][1:3]
        except:
          print(i,j,k)
          break
  return out

def boxplot(data, title, labels):
  fig = plt.figure()
  ax = fig.add_subplot(111)
  bp = ax.boxplot([i[:,0] for i in data])
  ax.set_title(title)
  ax.set_xlabel('Iterations')
  ax.set_ylabel('Horizontal location') 
  ax.set_xticklabels(labels)
  plt.show()
  return

def stacking(data):
  for i in range(len(data)):
    for j in range(len(data[i])):
      data[i][j] = vstack(data[i][j])
  return data

def without_duds(data):
  return data[array([len(i)==10 for i in data])]

def combine(data):
  data = array(data)
  data = vstack((i for i in data)).astype(float)
  return data

def histogram(stems, progs, title):
  #plots histogram of cell locations

  bins = linspace(0,30,30)

  # the histogram of the data
  plt.hist(stems, bins, alpha=0.5, label='stem cells')
  plt.hist(progs, bins, alpha=0.5, label='progenitor cells')
  plt.legend(loc='upper right')

  plt.xlabel('X-ordinate')
  plt.ylabel('Cell count')
  plt.title(title)


  plt.axis([0, 30, 0, 60])
  plt.grid(True)
  plt.show()

def autolabel(rects, ax):
    # attach some text labels
    for rect in rects:
        height = rect.get_height()
        ax.text(rect.get_x()+rect.get_width()/2., 1.05*height, '%d'%int(height),
                ha='center', va='bottom')

def barchart(data):
  ind = np.arange(len(data))  # the x locations for the groups
  width = 0.35       # the width of the bars

  fig, ax = plt.subplots()
  rects1 = ax.bar(ind, menMeans, width, color='r', yerr=menStd)

  # add some text for labels, title and axes ticks
  ax.set_ylabel('Scores')
  ax.set_title('Scores by group and gender')
  ax.set_xticks(ind+width)
  ax.set_xticklabels( ('0', '500', '1000', '1500', '2000','2500') )

  autolabel(rects1,ax)
  plt.show()

def linegraph(stems,progs, title):
  xaxis = arange(0,5250,250)
  fig = plt.figure()
  ax = fig.add_subplot(111)
  plt.plot(xaxis,progs,linewidth=2)
  plt.plot(xaxis,stems,linewidth=2.0)
  ax.set_title(title)
  ax.set_xlabel('Iterations')
  ax.set_ylabel('Population Size') 
  plt.legend(["Stem cells","Progenitor cells"],loc='upper left')
  plt.show()

