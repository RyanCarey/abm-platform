include("import.jl")

  v8 = Float64[1.0 0.05 2.0 1.0 1.0 1.0 1.5 .0001 .5 .5;
               0.0 0.05 2.0 1.0 1.0 -1.0 1.5 .0001 .5 .5;
               0.0 0.05 2.0 1.0 1.0 1.0 1.5 .0001 .5 .5;
               0.0 0.05 2.0 1.0 1.0 1.0 1.5 .0001 .5 .5]
  v9 = ["ro" false true false;"bo" false false false;"mo" false false false;"go" false false false]

  global categories = Cell_type[
          Cell_type(v8[1,1], v8[1,2], v8[1,3], v8[1,4], v8[1,5], v8[1,6], v8[1,7], v8[1,8], v8[1,9], v8[1,10], 
                    v9[1,1], v9[1,2], v9[1,3], v9[1, 4]),
          Cell_type(v8[2,1], v8[2,2], v8[2,3], v8[2,4], v8[2,5], v8[2,6], v8[2,7], v8[2,8], v8[2,9], v8[2,10], 
                    v9[2,1], v9[2,2], v9[2,3], v9[2, 4]),
          Cell_type(v8[3,1], v8[3,2], v8[3,3], v8[3,4], v8[3,5], v8[3,6], v8[3,7], v8[3,8], v8[3,9], v8[3,10], 
                    v9[3,1], v9[3,2], v9[3,3], v9[3, 4]),
          Cell_type(v8[4,1], v8[4,2], v8[4,3], v8[4,4], v8[4,5], v8[4,6], v8[4,7], v8[4,8], v8[4,9], v8[4,10], 
                    v9[4,1], v9[4,2], false, v9[4, 4])]


alive_cells = initial_placement(2,categories, 10,12)

