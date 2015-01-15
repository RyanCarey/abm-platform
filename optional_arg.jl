module Optional_arg
export optional_arg

function optional_arg(arg_index,prompt_text)
  # checks if an arg is present and 
  return length(enumerate(ARGS))>=arg_index ? ARGS[arg_index] : input_prompt(prompt_text)
end

function input_prompt(prompt_text::String)
  println(prompt_text)
  return readline(STDIN)
end

end
