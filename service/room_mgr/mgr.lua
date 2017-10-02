local room = require "room"

local M = {}

function M:init()
    self.account_2_id = {}
    self.tbl = {}
    self.number_2_id = {}
end

function M:get_room_by_number(number)
    local id = self.number_2_id[number]
    return self.tbl[id]
end

function M:get_room_by_player(account)
    local id = self.account_2_id[account]
    return self.tbl[id]
end

function M:create_room(owner, options)
    local id = 1
    local number = 300200
    local port = 3000
    local ip = "222.73.139.48"
    local r = room.new(id, number, ip, port, options, owner)
    self.account_2_id[owner.account] = id
    self.tbl[id] = r
    self.number_2_id[number] = id
    return r
end

function M:join_room(info, r)
    r:add_player(info)
    self.account_2_id[info.account] = r.id
end

return M
