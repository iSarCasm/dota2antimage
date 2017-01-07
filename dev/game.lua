local M = {};
----------------------------------------------
----------------------------------------------
M.RuneStates = {}
M.RuneStates[RUNE_BOUNTY_1] = RUNE_STATUS_MISSING;
M.RuneStates[RUNE_BOUNTY_2] = RUNE_STATUS_MISSING;
M.RuneStates[RUNE_BOUNTY_3] = RUNE_STATUS_MISSING;
M.RuneStates[RUNE_BOUNTY_4] = RUNE_STATUS_MISSING;
----------------------------------------------
----------------------------------------------
function M:TimeToRune(rune)
  if (self.RuneStates[rune] == RUNE_STATUS_MISSING) then
    if (DotaTime() < 0) then
      return -DotaTime();
    else
      return 120 - math.mod(DotaTime(), 120);
    end
  else
    return 0;
  end
end
----------------------------------------------
----------------------------------------------
function M:UpdateRunes()
  local runes = { RUNE_BOUNTY_1, RUNE_BOUNTY_2, RUNE_BOUNTY_3, RUNE_BOUNTY_4 }
  for i = 1, #runes do
    local rune = runes[i];

    if (DotaTime() >=0 and (math.mod(math.floor(DotaTime()), 120) == 0)) then
      self.RuneStates[rune] = RUNE_STATUS_UNKNOWN;
    end

    local status = GetRuneStatus(rune);
    if (status ~= RUNE_STATUS_UNKNOWN) then
      self.RuneStates[rune] = status;
    end

    DebugDrawText(25, 700 + i*20, "Rune "..rune.." status is: "..self.RuneStates[rune], 255, 255, 255);
  end
end
----------------------------------------------
function M:Update()
  self:UpdateRunes();
end
----------------------------------------------
----------------------------------------------
return M;
