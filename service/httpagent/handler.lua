local skynet = require "skynet"

local M = {}

function M.register(msg)
    local ret = skynet.call("login", "lua", "register", msg)
    return ret
end

function M.login(msg)
    print("处理登陆消息")
    local ret = skynet.call("login", "lua", "login", msg)
    print(ret)
    return ret
end

function M.create_room(msg)
    return skynet.call("player_mgr", "lua", "create_room", msg)
end

function M.join_room(msg)
    local ret = skynet.call("player_mgr", "lua", "join_room", msg)
    return ret
end

return M
