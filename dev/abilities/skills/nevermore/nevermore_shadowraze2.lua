local Shadowraze = require(GetScriptDirectory().."/dev/abilities/_templates/shadowraze");
local NevermoreShadowraze = Shadowraze:new();
-------------------------------------
function NevermoreShadowraze:new()
    raze = {};
    setmetatable(raze, self);
    self.__index = self;
    raze.name = "nevermore_shadowraze2";
    raze.range = 450;
    return raze;
end
------------------------------------
return NevermoreShadowraze;
