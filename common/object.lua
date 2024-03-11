--[[
    Object class
    This is a simple class that can be inherited by other classes
    It provides a simple inheritance mechanism and a super method for OOP.
]]--

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
