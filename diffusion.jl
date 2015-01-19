include("await_user.jl")
using Winston

function test_diffusion()
  X = reshape(.01:.01:1,10,10)
  n_diffusion_and_display!(X,.5,100)
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
  m,n = size(X)
  bottom = [X[2:end,:]; zeros(1,n)];
  top = [zeros(1,n);X[1:(end-1),:]];
  right = [X[:,2:end] zeros(m,1)];
  left = [zeros(m,1) X[:,1:(end-1)]];
  X[:,:] = (1-rate)*X + rate * (top + bottom + left + right) / 4;
end

function n_diffusion_and_display!(X,rate,n)
  for i in 1:n
    diffusion!(X,rate)
    p = imagesc(X,(0,1))
    display(p)
    await_user(.1)
  end
end

function init_diffusion(x,y)
  
end


