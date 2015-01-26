include("pause.jl")
using Winston

function test_diffusion()
  X = init_diffusion(15,15)
  n_diffusion_and_display!(X,.5,400)
end

function n_diffusion!(X,rate,n)
  # implements diffusion n times
  for i in 1:n
    diffusion!(X,rate)
  end
end

function diffusion!(X, rate)
  #Diffusion iterates one step of diffusive process
  # rate > 0
  X[:,:] = (1-rate)*X + rate * ([X[2:end,:];X[end,:]] + [X[:,1] X[:,1:(end-1)]] + [X[:,2:end] X[:,end]] + [X[1,:];X[1:(end-1),:]])/4
end

function n_diffusion_and_display!(X,rate,n)
  for i in 1:n
    diffusion!(X,rate)
    p = imagesc(X,(0,1))
    display(p)
    pause(.001)
  end
end

function init_diffusion(x,y)
  X = repmat([0:1/int(ceil(x)):1]',int(ceil(y))+1,1)
end


