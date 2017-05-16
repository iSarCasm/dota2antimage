local Cache = {
  Data    = {},
  Clock   = {},
  Config  = {
    CACHE_DANGER  = 0.5,
    CACHE_UNITS   = 0
  },
  CacheTypes = {
    CACHE_DANGER
  }
}
-------------------------------
function Cache:GC()
  for i = 1, #self.CacheTypes do
    local cache = self.CacheTypes[i]
    if (self.Clock[cache] == nil or DotaTime() > self.Clock[cache]) then
      self.Data[cache] = {}
      self.Clock[cache] = DotaTime() + self.Config[cache]
    end
  end
end

function Cache:CacheVector(type, vector, value)
  self.Data[type][vector.x+vector.y] = value
end

function Cache:GetCacheVector(type, vector)
  self:GC();
  if (self.Data[type] and self.Data[type][vector.x+vector.y]) then
    return self.Data[type][vector.x+vector.y]
  end
  return nil
end
-------------------------------
return Cache