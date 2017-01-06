local M = {};

function M:Contains(unit, item, hasToBeActiveSlot)
  local slots = (hasToBeActiveSlot and 6 or 9);
  for i = 1, slots do
    local slot = unit:GetItemInSlot(i);
    if (slot and slot:GetName() == item) then
      return true;
    end
  end
  return false;
end

return M;
