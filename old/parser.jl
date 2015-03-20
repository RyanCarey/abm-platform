# Parses output file and seperates into each cell in order to graph


function parse_output(input_file::String, output_file::String)
	input = open(input_file)
	output = open(output_file, "a")
	write(output, "Name,X,Y,Radius,Angle,Speed,State,Offspring\n")
	lines = readlines(input)
	i = 1
	# Iterate through until at the starting cell matrix
	while lines[i] != ">Starting Cell Matrix\n"
		i += 1
	end
	i += 1
	already_extracted = String[]
	end_of_name = search(lines[i], ',') - 1
	number = lines[i][1 : end_of_name]
	
	extract_all(input_file, output, number, end_of_name)
	push!(already_extracted, number)
	
	for i in i : length(lines)
		if !contains(lines[i], ">")
			end_of_name = search(lines[i], ',') - 1
			number = lines[i][1 : end_of_name]
			
			if !present(already_extracted, number)
				extract_all(input_file, output, number, end_of_name)
				push!(already_extracted, number)
			end
		end
	end
	close(output)
end

function extract_all(input::String, output_file, name::String, end_of_name::Int)
	input_file = open(input)
	print("> New Cell\n")
	for line in eachline(input_file)
		if line[1 : end_of_name] == name
			
			write(output_file, line)
			print(line)
		end		
	end
	
end

function present(arr::Array, name::String)
	for i in 1:length(arr)
		if arr[i] == name
			return true
		end
	end
	return false
end
		
