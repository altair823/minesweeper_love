Object = {}
Object.__index = Object

function Object:inherit()
    local child = {}
    for k, v in pairs(self) do
        if k:find("__") == 1 then
            child[k] = v
        end
    end
    child.__index = child
    child.super = self
    setmetatable(child, self)
    return child
end
  