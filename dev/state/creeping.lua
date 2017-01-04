local M = {};
----------------------------------------------
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
local UnitHelper      = require(GetScriptDirectory().."/dev/helper/unit_helper");
local VectorHelper    = require(GetScriptDirectory().."/dev/helper/vector_helper");
----------------------------------------------
function M:CreepWithNHitsOfHealth(range, enemy, ally, hits)
  if ((enemy and ally) == false) then return nil end;
  local bot = GetBot();
  local pos = bot:GetLocation();
  local range  = bot:GetAttackRange();
  local bot_damage = bot:GetBaseDamage();

  if (enemy) then
    local enemy_creeps = bot:GetNearbyCreeps(range, true);
    for _,creep in pairs(enemy_creeps)
    do
      if (creep:IsAlive()) then
        if (creep:GetHealth() < creep:GetActualDamage(bot_damage, DAMAGE_TYPE_PHYSICAL) * hits) then
          return creep;
        end
      end
    end
  end

  if (ally) then
    local ally_creeps = bot:GetNearbyCreeps(range, false);
    for _,creep in pairs(ally_creeps)
    do
      if (creep:IsAlive()) then
        if (creep:GetHealth() < creep:GetActualDamage(bot_damage, DAMAGE_TYPE_PHYSICAL) * hits) then
          return creep;
        end
      end
    end
  end

  return nil;
end

function M:AgroOffVec()
  local bot = GetBot();
  local lane = UnitHelper:GetUnitLane(bot);
  local tower = DotaBotUtility:GetFrontTowerAt(lane);
  return tower:GetLocation();
end

function M:isAttackedByCreeps(BotInfo)
  return (BotInfo.healthDelta < 0); -- bad
end

function M:WeakestCreep(range, ally)
  local bot = GetBot();
  local creeps = bot:GetNearbyCreeps(range, true);
  if (ally) then
    local ally_creeps = bot:GetNearbyCreeps(range, false);
    for k,v in pairs(ally_creeps) do creeps[k] = v end
  end
  local lowest_hp = 100000;
  local weakest_creep = nil;
  for creep_k,creep in pairs(creeps)
  do
      if(creep:IsAlive()) then
          local creep_hp = creep:GetHealth();
          if(lowest_hp > creep_hp) then
               lowest_hp = creep_hp;
               weakest_creep = creep;
          end
      end
  end
  return weakest_creep;
end

return M;
