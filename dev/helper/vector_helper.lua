local M = {}

function M:Normalize(vec)
  local x = vec[1];
  local y = vec[2];
  local vec_length = math.pow(x*x+y*y, 0.5);
  return Vector(x/vec_length, y/vec_length);
end

return M;
