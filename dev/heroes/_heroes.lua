local Heroes = {};
--------------------------------------
function Heroes:GetHero()
  local hero_name = GetBot():GetUnitName();
  local required = require(GetScriptDirectory().."/dev/heroes/"..hero_name)
  return required:new();
end
--------------------------------------
return Heroes;