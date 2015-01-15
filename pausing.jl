module Pausing
export pausing

function pausing(prompt = true)
  if prompt
    println("anykey to advance timestep")
    junk = readline(STDIN)
  else
    sleep(.005)
  end
end


end

