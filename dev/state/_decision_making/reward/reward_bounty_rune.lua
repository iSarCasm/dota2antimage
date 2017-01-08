local RewardBountyRune = {}
----------------------------------------------------
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
local Game    = require(GetScriptDirectory().."/dev/game");
----------------------------------------------------
function RewardBountyRune:Generic(Rune, Mode)
  return 60 + self:LaningReward(Rune, Mode); -- bounty gives ~60 gold
end

function RewardBountyRune:LaningReward(Rune, Mode)
  if (Mode == MODE_LANING) then
    if (GetTeam() == TEAM_RADIANT) then
      if (BotInfo:Me().LANE == LANE_TOP or BotInfo:Me().LANE == LANE_MID) then
        return ((Rune == RUNE_BOUNTY_1) and 100 or 0);
      else
        return ((Rune == RUNE_BOUNTY_2) and 100 or 0);
      end
    else
      if (BotInfo:Me().LANE == LANE_BOT or BotInfo:Me().LANE == LANE_MID) then
        return ((Rune == RUNE_BOUNTY_4) and 100 or 0);
      else
        return ((Rune == RUNE_BOUNTY_3) and 100 or 0);
      end
    end
  else
    return 0;
  end
end
----------------------------------------------------
return RewardBountyRune;
