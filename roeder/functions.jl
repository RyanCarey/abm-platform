

function f_trans(x::Int, f0::Float64, fN2::Float64, fN::Float64, finf::Float64, N::Int)
	h1 = 1 / (f0 - finf)
	h2 = 1 / (fN2 - finf)
	h3 = 1 / (fN - finf)

	v1 = (h1 * h3 - h2 ^ 2) / (h1 + h3 - 2h2)
	v2 = h1 - v1
	v3 = log((h3 - v1) / v2)
	v4 = finf

	f = (1 / ( v1 + v2 * exp( v3 * (x / N)))) + v4

	return f
end