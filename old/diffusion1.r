




integrand <- function(tau,D,t,x,A){
	
	result = A*exp(-x**2/(4*D*(t-tau)))/(4.0*D*t*pi)
	
	return(result)
	
}

A = 100
D = 10
t = 30
x1 = seq(0.1,100,1)

tau0 = 30

res = rep(NA,length(x1))

for(i in 1:length(x1)){
	
	res[i] = integrate(integrand,lower=0, upper=min(tau0,t),D,t,x1[i],A)[[1]]


}

plot(x1,res,type="l",main=paste("gradient at time:",t,"min"),ylab="concentration",xlab="distance from source")