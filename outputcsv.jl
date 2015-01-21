function output_csv(filename::String, out::Array)
  #@assert size(out,1)=5
  f = open(filename,"a")
  for i in 1:size(out,1)
    h,b,c,d,e = out[i,:]
    g = (h,b,c,d,e)
    write(f,join(g,","),"\n")
  end
  close(f)
end
