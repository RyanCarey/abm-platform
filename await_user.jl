
function await_user(prompt = true)
  if prompt
    println("anykey to advance timestep")
    junk = readline(STDIN)
  else
    sleep(.1)
  end
end

