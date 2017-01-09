local RewardBuyItems = {}
----------------------------------------------------
local BotInfo = require(GetScriptDirectory().."/dev/bot_info")
----------------------------------------------------
function RewardBuyItems:Item(item)
  if (not item) then return -999 end;
  local bot = GetBot();
  local gold = bot:GetGold();
  local cost = GetItemCost(item);
  if (gold < cost) then
    return -999;
  else
    return cost;
  end
end
----------------------------------------------------
return RewardBuyItems;
