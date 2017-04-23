local RewardRune = {}
---------------------------------------------------
local Game = require(GetScriptDirectory().."/dev/game");
----------------------------------------------------
function RewardRune:Generic(Rune, Mode, BotInfo)
  if (Rune ~= RUNE_POWERUP_1 and Rune ~= RUNE_POWERUP_2) then
    return self:Bounty(Rune, Mode, BotInfo);
  else
    return self:Powerup(Rune, Mode, BotInfo);
  end
end

function RewardRune:Powerup(Rune, Mode, BotInfo)
  return 30; -- todo
end

function RewardRune:Bounty(Rune, Mode, BotInfo)
  local basic_reward = 60 + DotaTime()/60;  -- bounty gives ~60 gold
  if (DotaTime() < 1) then
    basic_reward = 100; -- first rune gives 100 gold
  end
  return basic_reward + self:LaningReward(Rune, Mode, BotInfo);
end

function RewardRune:LaningReward(Rune, Mode, BotInfo)
  if (Mode == MODE_LANING) then
    if (GetTeam() == TEAM_RADIANT) then
      if (BotInfo.LANE == LANE_TOP or BotInfo.LANE == LANE_MID) then
        return ((Rune == RUNE_BOUNTY_1) and 0 or -30);
      else
        return ((Rune == RUNE_BOUNTY_2) and 0 or -30);
      end
    else
      if (BotInfo.LANE == LANE_BOT or BotInfo.LANE == LANE_MID) then
        return ((Rune == RUNE_BOUNTY_4) and 0 or -30);
      else
        return ((Rune == RUNE_BOUNTY_3) and 0 or -30);
      end
    end
  else
    return 0;
  end
end
----------------------------------------------------
return RewardRune;
