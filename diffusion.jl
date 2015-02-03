include("pause.jl")
using Winston

#Returns the ligand's concentration of one point thanks to an ODE
#
# time
# i,j coordinates of the points where we want the concentration
# source abscisse of the source (1D at the moment)
# tau must be linked to a possible delay
# D is the diffusion coefficient
# A is another coefficient
# tau0 is the number of steps possible
#=
#!!!!!!!!!!!!!!!!CHOICE OF THE PARAMETERS!!!!!!!!!!!!!!!!!!!!!!!!!#
=#
function ligand_concentration_onesource(abscisse_ligand,iter,source_abscisse_ligand=0,A=100,D=10,tau0=30)

	global Diffusion_coefficient = D,time_diffusion=iter,A_coefficient=A, distance_source = abs(source_abscisse_ligand-abscisse_ligand)
	(res,tmp)=quadgk(integrand,0,min(iter,tau0))
	return res

end

#Ligand initiation for a rectangle
function ligand_initiation(x=X_SIZE/2)
	j=int(floor(x))+1
	ligand_matrix=zeros(Y_size,X_SIZE)
	ligand_matrix[:,j]=1.+ligand_matrix[:,j]
	return ligand_matrix
end

#fucntion to integrate when running the diffusion
function integrand(tau)
	result = A_coefficient*exp(-distance_source^2/(4*Diffusion_coefficient*(time_diffusion-tau)))/(4*Diffusion_coefficient*time_diffusion*pi)
	return result
end



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


function n_diffusion_and_display!(X,rate,n)
  for i in 1:n
    diffusion!(X,rate)
    p = imagesc(X,(0,1))
    display(p)
    pause(.001)
  end
end

function init_diffusion(x=50,y=50)
  X = repmat([100/ceil(x):100/ceil(x):100]',int(ceil(y)),1)
  #X=ones(x,y)*x
  #for i in 1:x
  #X[i,:]=X[i,:]-(i-1)*ones(y,1)'
  #end
  return X
end

#this function takes a matrix as an input and return an array of 3 columns x,y,value

function matrix_list(M)
  L=Array(Float64,size(M,2)*size(M,1),3)
  for i in 1:size(M,1)
    for j in  1:size(M,2)
      L[(i-1)*size(M,1)+j,1]=j
      L[(i-1)*size(M,1)+j,2]=size(M,1)-i+1
      L[(i-1)*size(M,1)+j,3]=M[i,j]
    end
  end
  return L
end

#Diffusion iterates one step of diffusive process
# rate > 0
function diffusion!(X, rate=1)
	X[:,:] = (1-rate)*X + rate * ([X[2:end,:];X[end,:]] + [X[:,1] X[:,1:(end-1)]] + [X[:,2:end] X[:,end]] + [X[1,:];X[1:(end-1),:]])/4
	return X
end







