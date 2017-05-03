local M = {}

M["PointsOnLane"] = {}

local function InitPointsOnLane(PointsOnLane)
    for i = 1, 3, 1 do
        PointsOnLane[i] = {};
        for j = 0, 100, 1 do
            PointsOnLane[i][j] = GetLocationAlongLane(i,j / 100.0);
        end
    end
end

InitPointsOnLane(M["PointsOnLane"]);

function M:GetNearByPrecursorPointOnLane(Lane,Location)
    local npcBot = GetBot();
    local Pos = npcBot:GetLocation();
    if Location ~= nil then
        Pos = Location;
    end

    local PointsOnLane =  self["PointsOnLane"][Lane];
    local prevDist = (Pos - PointsOnLane[0]):Length2D();
    for i = 1,100,1 do
        local d = (Pos - PointsOnLane[i]):Length2D();
        if(d > prevDist) then
            if i >= 4 then
                return PointsOnLane[i - 4] + RandomVector(50);
            else
                return PointsOnLane[i - 1];
            end
        else
            prevDist = d;
        end
    end

    return PointsOnLane[100];
end

function M:GetNearBySuccessorPointOnLane(Lane,Location)
    local npcBot = GetBot();
    local Pos = npcBot:GetLocation();
    if Location ~= nil then
        Pos = Location;
    end

    local PointsOnLane =  self["PointsOnLane"][Lane];
    local prevDist = (Pos - PointsOnLane[100]):Length2D();
    for i = 100,0,-1 do
        local d = (Pos - PointsOnLane[i]):Length2D();
        if(d > prevDist) then
            if i <= 96 then
                return PointsOnLane[i + 4] + RandomVector(100);
            else
                return PointsOnLane[i + 1];
            end
        else
            prevDist = d;
        end
    end

    return PointsOnLane[0];
end

function M:CreepGC()
    -- does it works? i don't know
    print("CreepGC");
    local swp_table = {}
    for handle,time_health in pairs(self["creeps"])
    do
        local rm = false;
        for t,_ in pairs(time_health)
        do
            if(GameTime() - t > 20) then
                rm = true;
            end
            break;
        end
        if not rm then
            swp_table[handle] = time_health;
        end
    end
    self["creeps"] = swp_table;
end

function M:UpdateCreepHealth(creep)
    if self["creeps"] == nil then
        self["creeps"] = {};
    end

    if(self["creeps"][creep] == nil) then
        self["creeps"][creep] = {};
    end
    if(creep:GetHealth() < creep:GetMaxHealth()) then
        self["creeps"][creep][GameTime()] = creep:GetHealth();
    end

    if(#self["creeps"] > 200) then
        self:CreepGC();
    end
end

function pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0                 -- iterator variable
    local iter = function ()    -- iterator function
       i = i + 1
       if a[i] == nil then return nil
       else return a[i], t[a[i]]
       end
    end
    return iter
end

function sortFunc(a , b)
    if a < b then
        return true
    end
end

function M:GetCreepHealthDeltaPerSec(creep, time)
    if self["creeps"] == nil then
        self["creeps"] = {};
    end

    if(self["creeps"][creep] == nil) then
        return 0;
    else
        print ("GetCreepHealthDeltaPerSec "..#self["creeps"].."  "..#self["creeps"][creep]);
        for _time,_health in pairsByKeys(self["creeps"][creep],sortFunc)
        do
            -- only Consider very recent datas
            if(GameTime() - _time < time) then
                local e = (_health - creep:GetHealth()) / (GameTime() - _time);
                return e;
            end
        end
        return 0;
    end

end

function M:GetEnemyBots()
    local myteam = GetTeam();
    if myteam == TEAM_DIRE then
        return GetTeamPlayers(TEAM_RADIANT);
    else
        return GetTeamPlayers(TEAM_DIRE);
    end
end

function M:GetEnemyTeam()
    local myteam = GetTeam();
    if myteam == TEAM_DIRE then
        return TEAM_RADIANT;
    else
        return TEAM_DIRE;
    end
end

return M;
