global const aff_min = 0.002 # Minimum affinity
global const aff_max = 1.0 # Maximum affinity
global const regen = 1.1 # Affinity Regeneration Rate
global const degen = 1.05 # Affinity Degeneration Rate
#global cells = SharedArray{Float64}[]
global const TC = 48
global const TS = 8
global const TGM = 8
global const c1 = TC - (TS + TGM)
global const LP = 24 * 8
global const LM = 24 * 20
global const TCD = 24


function init!(n::Int, cells)
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
		cell = [temp_aff temp_env temp_cyc_pos 0.0 0.0]
		cells = vcat(cells, cell)
		#push!(cells, cell)
	end
	return cells
end

function calc_num_cells(cells)
	amt_A = 0
	amt_O = 0
	for i in 1 : size(cells, 1)
		if cells[i, 2] == 1
			amt_A += 1
		end
		if cells[i, 2] == 0
			amt_O += 1
		end
	end
	println("Amount of A: ", amt_A)
	println("Amount of O: ", amt_O)
	return amt_A, amt_O
end

function update_cells!(cells)
	#println("Updating Cells")
	dead_cells = 0
	new_cells = 0
	dead_cell_indexes = SharedArray[]
	@parallel for i in 1 : size(cells, 1)
		#println("In the updating loop")
		#println("Looking at cell: ", cells[i, :])
		# If cell is terminally differentiated
		if cells[i, 4] == 1	
			#println("Cell differentiated")
			# If the cells lifetime is still within the precursor window increase cell cycle position and its lifetime
			if cells[i, 5] <= LP
				#println("Cell still growing")
				cells[i, 3] += 1
				cells[i, 5] += 1
				# If cell cycle position above TCD, create new differentiated cell
				if cells[i, 3] >= TCD
					cells[i, 3] = 0
					new_cells += 1
					new_cell = [0.0 0.0 0.0 1.0 0.0]
					#println("New Cell!")
					cells = vcat(cells, new_cell)
					#push!(cells, new_cell)
				end
			# Else if it's between precursor and max age increase its life
			else LP < cells[i, 5] < (LP + LM)
				cells[i, 5] += 1
			# Else add its index to list in order to remove it later
			end
			if cells[i, 5] >= (LP + LM)
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
	return cells
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
	global cells = SharedArray(Float64, 0, 5)
	cells = init!(start_cells, cells)
	# For each step
	for i in 1 : steps
		cells = dostuff(i, cells)
		cells = update_cells!(cells)
		#println(cells)
	end
end

function dostuff(i::Int, cells)
	println("Step: ", i)
		# Calculate the number of cells in each environment
		amt_A, amt_O = calc_num_cells(cells)
		# For each cell
		@parallel for j in 1 : size(cells, 1)
			#println("In the calculating loop")
			#cell = copy(cells[j, :])
			if cells[j, 4] == 1
				#println("Cell is differentiated")
				continue
			end
			# If cell is in environment A
			if cells[j, 2] == 1
				#println("Cell is in env. A")
				# Calculate the probability of its transition to env. O
				trans_prob = aff_min / cells[j, 1] * f_trans(amt_O, 0.5, 0.3, 0.1, 0.0, 10^5)
				#trans_prob = aff_min / cell.aff * f_trans(amt_O, fw0, fwN2, fwN, fwinf, NW)
				
				# If rand is below, move to O and set cell cycle position to C1 (Beginning of S-phase) and move to next cell
				if rand() < trans_prob
					#println("Moving cell to env. O")
					cells[j, 2] = 0
					cells[j, 3] = c1
					continue
				# If rand is above, check to see if cell affinity * regen rate is above max aff and move to next cell
				elseif cells[j, 1] * regen < aff_max
					cells[j, 1] *= regen
					continue
				else
					cells[j, 1] = aff_max
					continue
				end
			# Else check to see if cell is in environment O
			elseif cells[j, 2] == 0
				#println("Cell is in env. O")
				# If cell is in G1 phase (can only transition to A if in G1)
				if cells[j, 3] < c1
					# Calculate the probability of its transiton to env. A
					
					trans_prob = cells[j, 1] / aff_max * f_trans(amt_A, 0.5, 0.45, 0.05, 0.0, 10^5)
					#trans_prob = cell.aff / aff_max * f_trans(amt_A, fa0, faN2, faN, fainf, NA)
					
					# If rand is below, move to A and move on to next cell
					if rand() < trans_prob
						#println("Moving cell to env. A")
						cells[j, 2]= 1
						continue
					end
				end
				# If cell affinitity is above minimum, increase cell cycle and decrease cell affinity
				if cells[j, 1] > aff_min
					#println("Cell is above min aff.")
					#println("Cell Cycle Position: ", cells[j, 3])
					cells[j, 3] += 1
					cells[j, 1] /= degen
					# If cell cycle is above max duration, create new cell and reset cell cycle position; move to next cell
					if cells[j, 3] > TC
						cells[j, 3] = 0
						new_cell = [cells[j, 1] cells[j, 2] cells[j, 3] 0.0 0.0]
						#println("New Cell!")
						cells = vcat(cells, new_cell)
						#push!(cells, new_cell)
						continue
					else
						continue
					end
				# If cell affinity is below minimum set it to 0 and start cell on terminal differentiation path.
				else
					cells[j, 1] = 0
					if cells[j, 4] == 0
						#println("Differentiating Cell")
						# Start terminal differentiation
						cells[j, 4] = 1
						cells[j, 3] = 0
					end
				end
			end
			#cells[j, :] = copy(cell)
			#println("Cell: ", cell)
			#println("Line in Array: ", cells[j, :])
		end
		return cells
end

#main(1000, 1000)