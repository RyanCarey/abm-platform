include("import_no_gui.jl")

function run_simulation(cells::Int64, steps::Int64, x_size::Float64, y_size::Float64, pickle_output::Bool)

##########################################################
##  Use the values under integrative for constant ligand dispersal
##  The 2 values under normal will be used in normal calculations
##      |------Integrative------| |-Normal-|
##      Pts  Conc Grad   T  Srcs Conc Grad
  v2 = [8.0, 100.0, 1.0, 150, 1,  100.0, 1.0]
  global rb_value=["Line"]
    global v3p=Array(Float64,2*int(v2[5]))
  global v3l=Array(Float64,int(v2[5]))
    global v4=Array(Float64,3*int(v2[5]))
    global v5=Array(Float64,2*int(v2[5]))
    for i in 1:v2[5]
      v3p[2*i-1]=0
      v3p[2*i]=0
      v3l[i]=0
      v4[3*i-2]=10
      v4[3*i-1]=100
      v4[3*i]=150 
      v5[2*i-1]=100
      v5[2*i]=1
    end
##########################################################
##            Ratio GR  DT  Sp  Rad Res ST  Death Prst Rand
  v8 = Float64[1.0 0.05 2.0 1.0 1.0 1.0 1.5 .0001 .5 .5;
               0.0 0.05 2.0 1.0 1.0 -1.0 1.5 .0001 .5 .5;
               0.0 0.05 2.0 1.0 1.0 1.0 1.5 .0001 .5 .5;
               0.0 0.05 2.0 1.0 1.0 1.0 1.5 .0001 .5 .5]
##########################################################
##      Color Left  Stem  Stick
  v9 = ["ro" false true false;
        "bo" false false false;
        "mo" false false false;
        "go" false false false]

  global categories = Cell_type[
          Cell_type(v8[1,1], v8[1,2], v8[1,3], v8[1,4], v8[1,5], v8[1,6], v8[1,7], v8[1,8], v8[1,9], v8[1,10], 
                    v9[1,1], v9[1,2], v9[1,3], v9[1, 4]),
          Cell_type(v8[2,1], v8[2,2], v8[2,3], v8[2,4], v8[2,5], v8[2,6], v8[2,7], v8[2,8], v8[2,9], v8[2,10], 
                    v9[2,1], v9[2,2], v9[2,3], v9[2, 4]),
          Cell_type(v8[3,1], v8[3,2], v8[3,3], v8[3,4], v8[3,5], v8[3,6], v8[3,7], v8[3,8], v8[3,9], v8[3,10], 
                    v9[3,1], v9[3,2], v9[3,3], v9[3, 4]),
          Cell_type(v8[4,1], v8[4,2], v8[4,3], v8[4,4], v8[4,5], v8[4,6], v8[4,7], v8[4,8], v8[4,9], v8[4,10], 
                    v9[4,1], v9[4,2], false, v9[4, 4])]

global nb_ligands = int(v2[2])
global nb_source = int(v2[7])
global source_abscisse_ligand = Array(Float64, nb_source)
global source_ordinate_ligand = Array(Float64, nb_source)
global Diffusion_coefficient = Array(Float64, nb_source)
global A_coefficient = Array(Float64, nb_source)
global tau0 = Array(Float64, nb_source)
global diffusion_maximum = Array(Float64, nb_source)
global diffusion_coefficient = Array(Float64, nb_source)
global type_source = rb_value[1]
global type_diffusion = "Integrative"

# Border Settings can be: "Reflecting", "Absorbing", "Removing".
border_settings = ["Reflecting", "Relfecting", "Reflecting", "Reflecting"]
alive_cells = initial_placement(cells, categories, x_size, y_size)
dead_cells = Cell[]
t = strftime(time())[5:27] #store date and time as string
filename = "out_$t.pickle"
simulator(alive_cells, dead_cells, categories, steps, pickle_output, filename, x_size, y_size, border_settings)

end