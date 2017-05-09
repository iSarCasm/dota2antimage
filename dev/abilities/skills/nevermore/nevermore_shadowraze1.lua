local Shadowraze = require(GetScriptDirectory().."/dev/abilities/_templates/shadowraze");
local NevermoreShadowraze = Shadowraze:new();
-------------------------------------
function NevermoreShadowraze:new()
    raze = {};
    setmetatable(raze, self);
    self.__index = self;
    raze.name = "nevermore_shadowraze1";
    raze.range = 200;
    raze.base_effort = 0.1;
    return raze;
end
------------------------------------
return NevermoreShadowraze;
