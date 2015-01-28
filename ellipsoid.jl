# find whether a circle is entirely contained within an ellipse


function circle_inside_ellipse(circle::Array,ellipse::Array)
  xo = circle[1]
  yo = circle[2]
  r = circle[3]
  a = ellipse[1]
  b = ellipse[2]
  return xo^2/(a-r)^2 + yo^2/(b-r) < 1
end

circle = [1.,1.,1.]
ellipse = [2.,1.]
