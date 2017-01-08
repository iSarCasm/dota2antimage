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

return InventoryHelper;
