local M = {}
local DotaBotUtility  = require(GetScriptDirectory().."/dev/utility");
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.STATE_WALK_TO_SHOP = "STATE_WALK_TO_SHOP";
M.STATE_BUY = "STATE_BUY"
-------------------------------------------------
-------------------------------------------------
function M.StateWalkToShop(self, BotInfo, Mode, Strategy)
  self.StateMachine.State = self.STATE_BUY;
end

function M.StateBuy(self, BotInfo, Mode, Strategy)
  BotActions.ActionPurchaseNextItem:Call();
end
-------------------------------------------------
-------------------------------------------------
M.StateMachine = {}
M.StateMachine.State = M.STATE_WALK_TO_SHOP;
M.StateMachine[M.STATE_WALK_TO_SHOP] = M.StateWalkToShop;
M.StateMachine[M.STATE_BUY]          = M.StateBuy;
-------------------------------------------------
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
