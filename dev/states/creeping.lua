local M = {};
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
----------------------------------------------
-- Some Shitty CONSTANTS I made up
local TOWER_POWER = 200;
local ENEMY_RANGE_REWARD = 50;
local ENEMY_MELEE_REWARD = 40;
local ALLY_RANGE_DENY_REWARD = 20;
local ALLY_MELEE_DENY_REWARD = 10;
----------------------------------------------

function M:GetComfortPoint(BotInfo)
  -- Takes Into Account:
  --    - Creeps positions and their priority
  --    - Hero range
  --    - Ally tower position
  --    - Enemy positions and their power (TODO)
  --    - Ally positions and their power (TODO)
  local bot = GetBot();
  local pos = bot:GetLocation();
  local new_pos_x = 0;
  local new_pos_y = 0;
  local allNil = true;

  local enemy_creeps = bot:GetNearbyCreeps(1500, true);
  local ally_creeps = bot:GetNearbyCreeps(1500, false);
  local range  = bot:GetAttackRange();
  local towers = bot:GetNearbyTowers(1000, false);
  local tower  = nil
  if (towers ~= nil) then
    for _,t in pairs(towers)
    do
      tower = t;
    end
  end
  local positions_count = 0;
  -- Take Enemy Creeps Into Account
  for _,creep in pairs(enemy_creeps)
  do
    allNil = false;
    local isMelee = (string.find(creep:GetUnitName(), "melee") ~= nil);
    local reward = isMelee and ENEMY_MELEE_REWARD or ENEMY_RANGE_REWARD;
    local creep_pos = creep:GetLocation();
    new_pos_x = new_pos_x + reward * creep_pos[1];
    new_pos_y = new_pos_y + reward * creep_pos[2];
    positions_count = positions_count + reward;
  end
  -- Take Ally Creeps Into Account
  for _,creep in pairs(ally_creeps)
  do
    allNil = false;
    local isMelee = (string.find(creep:GetUnitName(), "melee") ~= nil);
    local reward = isMelee and ALLY_MELEE_DENY_REWARD or ALLY_RANGE_DENY_REWARD;
    local creep_pos = creep:GetLocation();
    new_pos_x = new_pos_x + reward * creep_pos[1];
    new_pos_y = new_pos_y + reward * creep_pos[2];
    positions_count = positions_count + reward;
  end
  -- Take Tower Into Account
  if (tower ~= nil) then
    -- allNil = false;
    -- local tower_pos = tower:GetLocation();
    -- local reward = TOWER_POWER;
    -- new_pos_x = new_pos_x + reward * tower_pos[1];
    -- new_pos_y = new_pos_y + reward * tower_pos[2];
    -- positions_count = positions_count + reward;
  end
  -- result pos
  local res_x = new_pos_x / positions_count;
  local res_y = new_pos_y / positions_count;
  local res_vec = Vector(res_x, res_y);
  if (allNil) then
    return nil;
  else
    return res_vec;
  end
end

return M;
