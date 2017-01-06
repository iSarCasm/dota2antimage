local M = {}
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
-------------------------------------------------
M.STATE_WALK_TO_SHOP = "STATE_WALK_TO_SHOP";
M.STATE_BUY = "STATE_BUY"
-------------------------------------------------
M.Potential = {};
M.Shop = SHOP_SIDE_TOP;
-------------------------------------------------
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local bot = GetBot();
  local gold = bot:GetGold();
  local item = BotInfo.itemBuild[1];
  local reward = GetItemCost(item);

  if (gold < reward) then
    return 0;
  end

  local secret = IsItemPurchasedFromSecretShop(item);
  local side = IsItemPurchasedFromSideShop(item);
  local fountain = (not secret);
  local shops = {};
  if (secret) then
    shops = {SHOP_SECRET_RADIANT, SHOP_SECRET_RADIANT};
  elseif (side and fountain) then
    shops = {SHOP_SIDE_BOT, SHOP_SIDE_TOP, SHOP_RADIANT, SHOP_DIRE};
  elseif (fountain) then
    shops = {SHOP_RADIANT, SHOP_DIRE};
  end
  local highest = -9999999;
  for i = 1, #shops do
    local walkSpeed = bot:GetCurrentMovementSpeed();
    local walkDistance = GetUnitToLocationDistance(bot, SHOP[shops[i]]);
    local effortWalk = walkDistance / walkSpeed;
    local effort = effortWalk;
    local potential = reward / effort;
    self.Potential[shops[i]] = potential;
    if (potential > highest) then
      self.Shop = shops[i];
      highest = potential;
    end
  end
  return self.Potential[self.Shop];
end

function M:ShopDistance(shop)
  if (shop == SHOP_DIRE or shop == SHOP_RADIANT) then
    return GetBot():DistanceFromFountain();
  elseif (shop == SHOP_SIDE_BOT or shop == SHOP_SIDE_TOP) then
    return GetBot():DistanceFromSideShop();
  else
    return GetBot():DistanceFromSecretShop();
  end
end
-------------------------------------------------
-------------------------------------------------
function M.StateWalkToShop(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local loc = SHOP[self.Shop];
  if (self:ShopDistance(self.Shop) < 10) then
    self.StateMachine.State = self.STATE_BUY;
  else
    BotActions.ActionMoveToLocation:Call(loc);
  end
end

function M.StateBuy(self, BotInfo, Mode, Strategy)
  BotActions.ActionPurchaseNextItem:Call();
end
-------------------------------------------------
-------------------------------------------------
M.StateMachine = {}
M.StateMachine[M.STATE_WALK_TO_SHOP] = M.StateWalkToShop;
M.StateMachine[M.STATE_BUY]          = M.StateBuy;
-------------------------------------------------
function M:Reset()
  self.StateMachine.State = self.STATE_WALK_TO_SHOP;
end
M:Reset();
-------------------------------------------------
function M:Run(BotInfo, Mode, Strategy)
  self.StateMachine[self.StateMachine.State](self, BotInfo, Mode, Strategy);
end
-------------------------------------------------
return M;
