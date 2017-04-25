local InventoryHelper = {};

function InventoryHelper:Contains(unit, item, hasToBeActiveSlot)
  local slots = (hasToBeActiveSlot and 5 or 8);
  for i = 0, slots do
    local slot = unit:GetItemInSlot(i);
    if (slot and slot:GetName() == item) then
      return true;
    end
  end
  return false;
end

function InventoryHelper:GetItemByName(unit, item_name, hasToBeActiveSlot)
  local slots = (hasToBeActiveSlot and 5 or 8);
  for i = 0, slots do
    local slot = unit:GetItemInSlot(i);
    if (slot and slot:GetName() == item_name) then
      return slot;
    end
  end
  return nil;
end

function InventoryHelper:WorthOfItemsCanBeBought(build)
  local gold = GetBot():GetGold();
  local goldLeft = gold;
  local worth = 0;
  for i = 1, #build do
    local cost = GetItemCost(build[i]);
    if (goldLeft >= cost) then
      goldLeft = goldLeft - cost;
      worth = worth + cost;
    else
      return worth;
    end
  end
  return 0;
end

function InventoryHelper:HasSpareSlot(unit, hasToBeActiveSlot)
  local slots = (hasToBeActiveSlot and 5 or 8);
  for i = 0, slots do
    local slot = unit:GetItemInSlot(i);
    if (not slot) then
      return true
    end
  end
  return false;
end

function InventoryHelper:IsBackpackEmpty(unit)
  for i = 6, 8 do
    local slot = unit:GetItemInSlot(i);
    if (slot) then
      return false
    end
  end
  return true;
end

function InventoryHelper:MostValuableItemSlot(unit, slot_from, slot_to)
  local most_value = VERY_LOW_INT;
  local most = nil;
  for i = slot_from, slot_to do
    local item = unit:GetItemInSlot(i);
    if (item and self:Value(item:GetName()) > most_value) then
      most_value = self:Value(item:GetName());
      most = i;
    end
  end
  local hash = {};
  hash.slot = most;
  hash.value = most_value
  return hash;
end

function InventoryHelper:LeastValuableItemSlot(unit, slot_from, slot_to)
  local least_value = VERY_HIGH_INT;
  local least = nil;
  for i = slot_from, slot_to do
    local item = unit:GetItemInSlot(i);
    if (item) then
      if (self:Value(item:GetName()) < least_value) then
        least_value = self:Value(item:GetName());
        least = i;
      end
    else
      least_value = 0;
      least = i;
    end
  end
  local hash = {};
  hash.slot = least;
  hash.value = least_value
  return hash;
end

function InventoryHelper:Value(item)
  return GetItemCost(item);
end

function InventoryHelper:HealthConsumables( hHero )
  local health = 0;
  for i = 0, 5 do
    local item = hHero:GetItemInSlot(i);
    if (item) then
      if (item:GetName() == "item_tango") then
        health = health + 115 * item:GetCurrentCharges();
      elseif(item:GetName() == "item_flask") then
        health = health + 400 * item:GetCurrentCharges();
      end
    end
  end
  return health;
end

return InventoryHelper;
