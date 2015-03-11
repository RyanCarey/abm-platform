from numpy import *
import matplotlib.pyplot as plt
exec(open('unpickle.py').read())

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
  ax.set_ylabel('Horizontal distance from source') 
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
'''bias laceration
['out_04 Mar 2015 10:53:29 AM.pickle','out_11 Mar 2015 10:21:53 AM.pickle',
'out_11 Mar 2015 10:28:43 AM.pickle','out_11 Mar 2015 10:37:30 AM.pickle',
'out_04 Mar 2015 10:55:05 AM.pickle','out_11 Mar 2015 10:22:55 AM.pickle',
'out_11 Mar 2015 10:30:00 AM.pickle','out_11 Mar 2015 10:39:40 AM.pickle',
'out_11 Mar 2015 10:10:23 AM.pickle','out_11 Mar 2015 10:24:10 AM.pickle',
'out_11 Mar 2015 10:32:47 AM.pickle','out_11 Mar 2015 10:40:48 AM.pickle',
'out_11 Mar 2015 10:18:16 AM.pickle','out_11 Mar 2015 10:25:48 AM.pickle',
'out_11 Mar 2015 10:34:01 AM.pickle','out_11 Mar 2015 10:42:07 AM.pickle',
'out_11 Mar 2015 10:20:53 AM.pickle','out_11 Mar 2015 10:27:35 AM.pickle',
'out_11 Mar 2015 10:35:38 AM.pickle','out_11 Mar 2015 10:43:46 AM.pickle']
'''
'''bias laceration
['out_11 Mar 2015 12:23:09 PM.pickle',
'out_11 Mar 2015 12:24:13 PM.pickle',
'out_11 Mar 2015 12:25:15 PM.pickle']
'''

filenames = ['out_11 Mar 2015 12:28:06 PM.pickle',
'out_11 Mar 2015 12:23:09 PM.pickle','out_11 Mar 2015 12:32:18 PM.pickle',
'out_11 Mar 2015 12:24:13 PM.pickle','out_11 Mar 2015 12:34:16 PM.pickle',
'out_11 Mar 2015 12:25:15 PM.pickle','out_11 Mar 2015 12:35:46 PM.pickle',
'out_11 Mar 2015 12:26:42 PM.pickle',
'out_11 Mar 2015 12:28:06 PM.pickle',
'out_11 Mar 2015 12:32:18 PM.pickle',
'out_11 Mar 2015 12:34:16 PM.pickle',
'out_11 Mar 2015 12:35:46 PM.pickle',
'out_11 Mar 2015 12:38:21 PM.pickle']
