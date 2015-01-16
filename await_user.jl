module Await_user
export await_user

function await_user(prompt = true)
  if prompt
    println("anykey to advance timestep")
    junk = readline(STDIN)
  else
    sleep(.4)
  end
end


end

