local RewardKillTower = {};
-----------------------------------------
function RewardKillTower:Tower(tower)
  return 1000 + 5000; -- bounty is ~1000 gold + ~5000 map control
end
-----------------------------------------
return RewardKillTower;
