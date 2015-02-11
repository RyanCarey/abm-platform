using Winston


function integrand(tau)
	result = A_coefficient*exp(-distance_source^2/(4*Diffusion_coefficient*(time_diffusion-tau)))/(4*Diffusion_coefficient*time_diffusion*pi)
	return result
end

function test()

	global Diffusion_coefficient = 10,time_diffusion=30,A_coefficient=100
	res=Array(Float64,100)
	declaration()
	for i in 1:30
		print(i," ")	
		global distance_source = float(i/100)
		(res[i],tmp)=quadgk(integrand,0,30)
	end

display(plot(res))
junk = readline(STDIN)
end



println(test())
