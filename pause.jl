function pause(time,message::String = "anykey to advance timestep")
  if time==0
    println(message)
    junk = readline(STDIN)
  else
    sleep(time)
  end
end


