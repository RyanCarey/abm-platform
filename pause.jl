function pause(time)
  if time==0
    println("anykey to advance timestep")
    junk = readline(STDIN)
  else
    sleep(time)
  end
end


