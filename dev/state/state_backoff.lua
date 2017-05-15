local M = {}
local BotActions        = require(GetScriptDirectory().."/dev/bot_actions");
local Danger            = require(GetScriptDirectory().."/dev/danger/danger")
local Creeping          = require(GetScriptDirectory().."/dev/state/state_farming_lane/creeping")
local VectorHelper      = require(GetScriptDirectory().."/dev/helper/vector_helper")
-------------------------------------------------
M.Potential = {};
M.REASON_CREEPS = "REASON_CREEPS";
M.REASON_TOWER = "REASON_TOWER";
M.REASON_OTRHER = "REASON_OTRHER";
-------------------------------------------------
function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
--------------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  if (bot.flex_bot.backoff and bot.flex_bot.backoff > DotaTime()) then
    self.Reason = self.REASON_OTRHER;
    return 18;
  else
    if (GetBot():TimeSinceDamagedByTower() < 1) then
      self.Reason = self.REASON_TOWER;
      return 29;
    elseif (GetBot():TimeSinceDamagedByTower() < 2) then
      self.Reason = self.REASON_TOWER;
      return 24;
    elseif (GetBot():TimeSinceDamagedByCreep() < 0.75) then
      self.Reason = self.REASON_CREEPS;
      return 19;
    end
  end
  return 0;
end
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  local bot = GetBot();
  if (self.Reason == self.REASON_TOWER or self.Reason == self.REASON_OTHER) then
    local safest_location = Danger:SafestLocation(bot);
    BotActions.MoveToLocation:Call(safest_location);
  elseif (bot:GetCurrentActionType() ~= BOT_ACTION_TYPE_MOVE_TO) then
    local nearest_ally_creep = Creeping:GetNearestCreep(600, false);
    if (nearest_ally_creep) then
      local move_point = bot:GetLocation() + VectorHelper:Normalize(nearest_ally_creep:GetLocation() - bot:GetLocation()) * 500;
      BotActions.MoveToLocation:Call(move_point);
    else
      local safest_location = Danger:SafestLocation(bot);
      BotActions.MoveToLocation:Call(safest_location);
    end
  end
end
-------------------------------------------------
return M;
