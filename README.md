## Purpose
This is a platform for agent-based modelling developed in Julia for a ten-week bioinformatics project
by Ryan Carey, Lewis Kindeleit and Antoine Messager. Here are the installation instructions. For
usage instructions and more information, refer to the manual (manual.pdf)

## Installation
The CBMP has been developed in Julia 0.4. in RedHat Enterprise Linux 
Workstation release 6.2, and has also been tested on Ubuntu 14.04 in 
Julia 0.3. The platform should run on any operating system 
that has Julia installed, however there may be slight differences 
between them.

To run the CBMP, first Julia must be installed. If this has already been 
done, please skip to the Dependencies section.

### Detailed Instruction
To install Julia, follow the instructions on the website, 
http://julialang.org/downloads/. Similarly,
install Python at www.python.org/downloads if you do not have it already. 
The Julia packages Winston, Tk and PyCall are most easily installed 
using the interactive Julia prompt. The Julia prompt is opened by entering
into the command line: 

   > julia} 

To install the required packages, enter the following into Julia's interactive prompt: 

    > Pkg.add("\,Winston") 

    > Pkg.add("\,Tk") 

    > Pkg.add("\,PyCall")}  

To return to the command line, enter: 

    > exit()} 

You can install the python package {\itshape Pickle} by typing into the command line: 

    > pip install pickle} 

If all of the dependencies are already installed, then all you need to 
do is download the repository and run CBMP.jl.

## Dependencies

The installation depends on:

* Julia 0.3 -- 0.4 with:
  * begin{itemize}
  * Winston
  * Tk
  * PyCall
* Python (tested on 2.8 and 3.4 but it should work for other versions) with:
  * Pickle

Once you have installed the dependencies, all you need to do is download 
the repository and run CBMP.jl. If you have git installed, you do this 
by entering into your command line: 

    > git clone https://github.com/RyanCarey/abm-platform.git 

    > julia CBMP.jl

The software comes with 2 different methods of inputting parameters and 
starting simulations: an easy to use GUI and a command line version. The 
GUI has been created with experiment design in mind; it gives the user 
fine-grained control of all parameters that describe the behaviour of 
cells and the way in which environmental stimuli diffuse through the 
environment, whilst providing immediate feedback.

The command line version, whilst being more complicated to operate, is 
much faster at performing simulations due to the lack of simulation 
display and increased parameter input speed. Parameters are input 
directly into the code and as such requires slightly more expertise to 
use. This option is intended to be used when experimental setup is 
already decided and multiple simulations are required to be run to 
collect data.

For explanation of how to use these versions, refer to the manual (manual.pdf)
