from numpy import *
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
exec(open('unpickle.py').read())

def load_turn(filenames,turn):
  filenames = list(copy(filenames))
  positions = []
  while filenames:
    data = load(filenames.pop())
    if len(data)==10:     # check that data has reached full length without error
      cells = array(data[turn]['alive_cells'])
      positions.append(cells[:,[1,2,-1]])
  return positions

def load_all_turns(filenames):
  # prevent mutation of filenames list
  filenames = list(copy(filenames))
  b = []
  for i in range(10):
    b.append(load_turn(filenames,i))
  return b

def load_all(filenames):
  data = []
  for name in filenames:
    data.append(load(name))

  #extract cell information
  for i in range(len(data)):
    for j in range(len(data[i])):
      data[i][j] = data[i][j]['alive_cells']
  for i in range(len(data)):
    for j in range(len(data[i])):
      for k in range(len(data[i][j])):
        # extract positions
        data[i][j][k] = array(data[i][j][k][1:3])
        data[i][j] = vstack(data[i][j])


  return data

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

def histogram(stems, progs):
  #plots histogram of cell locations

  bins = linspace(0,30,30)

  # the histogram of the data
  plt.hist(stems, bins, alpha=0.5, label='stem cells')
  plt.hist(progs, bins, alpha=0.5, label='progenitor cells')
  plt.legend(loc='upper right')

  plt.xlabel('X-ordinate')
  plt.ylabel('Probability')
  plt.title('Location after 5000 turns, from 15 iterations')


  plt.axis([0, 30, 0, 150])
  plt.grid(True)
  plt.show()

'''
['out_09 Mar 2015 03:13:37 PM.pickle','out_09 Mar 2015 03:23:19 PM.pickle','out_09 Mar 2015 03:31:09 PM.pickle','out_09 Mar 2015 03:39:53 PM.pickle',
'out_09 Mar 2015 03:15:23 PM.pickle','out_09 Mar 2015 03:24:02 PM.pickle','out_09 Mar 2015 03:31:58 PM.pickle','out_09 Mar 2015 03:41:15 PM.pickle',
'out_09 Mar 2015 03:16:40 PM.pickle','out_09 Mar 2015 03:25:04 PM.pickle','out_09 Mar 2015 03:32:57 PM.pickle','out_09 Mar 2015 12:03:12 PM.pickle',
'out_09 Mar 2015 03:16:44 PM.pickle','out_09 Mar 2015 03:25:45 PM.pickle','out_09 Mar 2015 03:35:10 PM.pickle','out_09 Mar 2015 12:03:53 PM.pickle',
'out_09 Mar 2015 03:17:23 PM.pickle','out_09 Mar 2015 03:29:29 PM.pickle','out_09 Mar 2015 03:35:37 PM.pickle',
'out_09 Mar 2015 03:22:38 PM.pickle','out_09 Mar 2015 03:30:13 PM.pickle','out_09 Mar 2015 03:37:07 PM.pickle']


  filenames = ['out_09 Mar 2015 12:18:09 PM.pickle',
    'out_09 Mar 2015 12:21:55 PM.pickle','out_09 Mar 2015 12:21:57 PM.pickle',
    'out_09 Mar 2015 12:24:13 PM.pickle','out_09 Mar 2015 12:25:45 PM.pickle',
    'out_04 Mar 2015 10:53:29 AM.pickle','out_09 Mar 2015 12:28:18 PM.pickle',
    'out_04 Mar 2015 10:55:05 AM.pickle','out_09 Mar 2015 12:29:29 PM.pickle',
    'out_04 Mar 2015 11:22:18 AM.pickle','out_09 Mar 2015 12:32:04 PM.pickle',
    'out_04 Mar 2015 11:25:32 AM.pickle','out_09 Mar 2015 12:34:08 PM.pickle',
    'out_09 Mar 2015 12:02:40 PM.pickle','out_09 Mar 2015 12:36:11 PM.pickle',
    'out_09 Mar 2015 12:03:12 PM.pickle','out_09 Mar 2015 12:38:41 PM.pickle',
    'out_09 Mar 2015 12:03:53 PM.pickle','out_09 Mar 2015 12:41:54 PM.pickle',
    'out_09 Mar 2015 12:14:55 PM.pickle','out_09 Mar 2015 12:46:42 PM.pickle']
 '''

