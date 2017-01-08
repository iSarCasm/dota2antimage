local M = {}
local BotActions      = require(GetScriptDirectory().."/dev/bot_actions");
local RewardBuyItems  = require(GetScriptDirectory().."/dev/state/_decision_making/reward/reward_buy_items");
local EffortWalk      = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_walk");
local EffortDanger    = require(GetScriptDirectory().."/dev/state/_decision_making/effort/effort_danger");
-------------------------------------------------
M.STATE_WALK_TO_SHOP  = "STATE_WALK_TO_SHOP";
M.STATE_BUY           = "STATE_BUY"
-------------------------------------------------
M.Potential = {};
M.Shop = SHOP_SIDE_TOP;
-------------------------------------------------
function M:ArgumentString()
  return "("..self.Shop..")";
end
-------------------------------------------------
function M:EvaluatePotential(BotInfo, Mode, Strategy)
  local item = BotInfo.itemBuild[1];
  local reward = RewardBuyItems:Item(item);
  if (reward < 0) then return reward end;
  local secret = IsItemPurchasedFromSecretShop(item);
  local side = IsItemPurchasedFromSideShop(item);
  local fountain = (not secret);
  -- print("item is "..item);
  -- print("secret: "..(secret and "YES" or "NO ").."side: "..(side and "YES" or "NO ").." fountain: "..(fountain and "YES" or "NO "));
  local shops = {};
  if (secret) then
    shops = {SHOP_SECRET_RADIANT, SHOP_SECRET_RADIANT};
  elseif (side and fountain) then
    shops = {SHOP_SIDE_BOT, SHOP_SIDE_TOP, SHOP_RADIANT, SHOP_DIRE};
  elseif (fountain) then
    shops = {SHOP_RADIANT, SHOP_DIRE};
  end

  local highest = VERY_LOW_INT;
  for i = 1, #shops do
    shop = shops[i];
    -- print("the shop is "..shop.." "..EffortWalk:ToLocation(SHOP[shop]).." + "..EffortDanger:OfLocation(SHOP[shop]));
    local effort = EffortWalk:ToLocation(SHOP[shop]) + EffortDanger:OfLocation(SHOP[shop]);
    if (fountain and (not side) and shop == GetShop()) then
      effort = 1; -- fountain only? insta buy
    end
    local potential = reward / effort;

    self.Potential[shop] = potential;
    if (potential > highest) then
      self.Shop = shop;
      highest = potential;
    end
  end
  return self.Potential[self.Shop];
end
-------------------------------------------------
-------------------------------------------------
function M.StateWalkToShop(self, BotInfo, Mode, Strategy)
  local bot = GetBot();
  local loc = SHOP[self.Shop];
  if (self:ShopDistance(self.Shop) < 10 or (self.Shop == GetShop())) then
    self.StateMachine.State = self.STATE_BUY;
  else
    BotActions.ActionMoveToLocation:Call(loc);
  end
end

function M.StateBuy(self, BotInfo, Mode, Strategy)
  BotActions.ActionPurchaseItem:Call(BotInfo.itemBuild[1]);
end
-------------------------------------------------
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
