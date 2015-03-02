include("types.jl")
include("functions.jl")

global const aff_min = 0.002
global const aff_max = 1.0
global const regen = 1.1
global const degen = 1.05
global cells = Array{Float64}[]
global const TC = 48
global const TS = 8
global const TGM = 8
global const c1 = TC - (TS + TGM)
global const LP = 24 * 2
global const LM = 24 * 2
global const TCD = 24


function init!(n::Int)
	for i in 1 : n
		temp_aff = rand()
		if temp_aff < 0.002
			temp_aff = 0.0025
		end
		if rand() < 0.5
			temp_env = 1
			temp_cyc_pos = 0
		else
			temp_env = 0
			temp_cyc_pos = c1
		end
		cell = Float64[temp_aff, temp_env, temp_cyc_pos, 0.0, 0.0]
		push!(cells, cell)
	end
end

function calc_num_cells(cells::Array)
	amt_A = 0
	amt_O = 0
	for i in 1 : length(cells)
		if cells[i][2] == 1
			amt_A += 1
		end
		if cells[i][2] == 0
			amt_O += 1
		end
	end
	println("Amount of A: ", amt_A)
	println("Amount of O: ", amt_O)
	return amt_A, amt_O
end

function update_cells!(cells::Array)
	dead_cells = 0
	new_cells = 0
	dead_cell_indexes = []
	for i in 1 : length(cells)
		# If cell is terminally differentiated
		if cells[i][4] == 1		
			# If the cells lifetime is still within the precursor window increase cell cycle position and its lifetime
			if cells[i][5] <= LP
				cells[i][3] += 1
				cells[i][5] += 1
				# If cell cycle position above TCD, create new differentiated cell
				if cells[i][3] >= TCD
					cells[i][3] = 0
					new_cells += 1
					new_cell = [0.0, 0.0, 0.0, 1.0, 0.0]
					push!(cells, new_cell)
				end
			# Else if it's between precursor and max age increase its life
			else LP < cells[i][5] < (LP + LM)
				cells[i][5] += 1
			# Else add its index to list in order to remove it later
			end
			if cells[i][5] >= (LP + LM)
				dead_cells += 1
				push!(dead_cell_indexes, i)
			end
		end
	end
	# Remove all cells tagged for death
	for i in 1 : length(dead_cell_indexes)
		splice!(cells, dead_cell_indexes[i])
	end
	println("Cells died this turn: ", dead_cells)
	println("New cells this turn: ", new_cells)
end


function main(steps::Int, start_cells::Int)
	const fa0 = 0.5
	const faN2 = 0.45
	const faN = 0.05
	const fainf = 0.0
	const NA = 10^5

	const fw0 = 0.5
	const fwN2 = 0.3
	const fwN = 0.1
	const fwinf = 0.0
	const NW = 10^5

	init!(start_cells)
	# For each step
	for i in 1 : steps
		dostuff(i, cells)
		update_cells!(cells)
	end
end

function dostuff(i::Int, cells::Array)
	println("Step: ", i)
		# Calculate the number of cells in each environment
		amt_A, amt_O = calc_num_cells(cells)
		# For each cell
		for j in 1 : length(cells)
			cell = cells[j]
			if cell[4] == 1
				continue
			end
			# If cell is in environment A
			if cell[2] == 1
				# Calculate the probability of its transition to env. O
				trans_prob = aff_min / cell[1] * f_trans(amt_O, 0.5, 0.3, 0.1, 0.0, 10^5)
				#trans_prob = aff_min / cell.aff * f_trans(amt_O, fw0, fwN2, fwN, fwinf, NW)
				
				# If rand is below, move to O and set cell cycle position to C1 (Beginning of S-phase) and move to next cell
				if rand() < trans_prob
					#println("Moving cell to O")
					cell[2] = 0
					cell[3] = c1
					continue
				# If rand is above, check to see if cell affinity * regen rate is above max aff and move to next cell
				elseif cell[1] * regen < aff_max
					cell[1] *= regen
					continue
				else
					cell[1] = aff_max
					continue
				end
			# Else check to see if cell is in environment O
			elseif cell[2] == 0
				# If cell is in G1 phase (can only transition to A if in G1)
				if cell[3] < c1
					# Calculate the probability of its transiton to env. A
					
					trans_prob = cell[1] / aff_max * f_trans(amt_A, 0.5, 0.45, 0.05, 0.0, 10^5)
					#trans_prob = cell.aff / aff_max * f_trans(amt_A, fa0, faN2, faN, fainf, NA)
					
					# If rand is below, move to A and move on to next cell
					if rand() < trans_prob
						cell[2]= 1
						continue
					end
				end
				# If cell affinitity is above minimum, increase cell cycle and decrease cell affinity
				if cell[1] > aff_min
						cell[3] += 1
						cell[1] /= degen
						# If cell cycle is above max duration, create new cell and reset cell cycle position; move to next cell
						if cell[3] > TC
							cell[3] = 0
							new_cell = [cell[1], cell[2], cell[3], 0.0, 0.0]
							
							push!(cells, new_cell)
							continue
						else
							continue
						end
				# If cell affinity is below minimum set it to 0 and start cell on terminal differentiation path.
				else
					if cell[4] == 0
						cell[1] = 0
						# Start terminal differentiation
						cell[4] = 1
						cell[3] = 0
					end
				end
			end
		end
end

#main(1000, 1000)