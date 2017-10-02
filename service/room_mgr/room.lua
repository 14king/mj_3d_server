local M = {}

M.__index = M

function M.new(...)
    local o = {}
    setmetatable(o, M)
    o:init(...)
    return o
end

function M:init(id, number, ip, port, options, owner)
    self.id = id
    self.number = number
    self.ip = ip
    self.port = port
    self.options = options
    self.owner = owner
    self.players = {owner}
end

-- 加入玩家
function M:add_player(info)
    table.insert(self.players, info)
end

return M
