local M = {}
local InventoryHelper = require(GetScriptDirectory().."/dev/helper/inventory_helper")
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");

-------------------------------------------------
M.Potential = {};
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  if (not InventoryHelper:IsBackpackEmpty(bot)) then
    local swap_1 = InventoryHelper:MostValuableItemSlot(bot, 6, 8);
    local swap_2 = InventoryHelper:LeastValuableItemSlot(bot, 0, 5);
    if (swap_1.value > swap_2.value) then
      self.swap_1 = swap_1.slot;
      self.swap_2 = swap_2.slot;
      return 999;
    end
  end
  return -999;
end
-------------------------------------------------
-------------------------------------------------
function M.SwapItems(self, BotInfo, Mode, Strategy)
  GetBot():ActionImmediate_SwapItems(self.swap_1, self.swap_2);
end
-------------------------------------------------
-------------------------------------------------
function M:Reset()
  -- wat?
end
M:Reset();
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self:SwapItems(self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
