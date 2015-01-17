module Pausing
export pausing

function pausing(prompt = true)
  if prompt
    println("anykey to advance timestep")
    junk = readline(STDIN)
  else
    sleep(.001)
  end
end


end

