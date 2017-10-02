local skynet = require "skynet"
require "skynet.manager"
local account_mgr = require "account_mgr"

local CMD = {}

function CMD.start()
    account_mgr:init()
    account_mgr:load()
end

function CMD.register(msg)
    local acc = account_mgr:get(msg.account)
    if acc then
        return {errmsg = "account exist"}
    end

    account_mgr:register(msg.account, msg.password)
    return {errmsg = "success", token="token"}
end

function CMD.login(msg)
    local acc = account_mgr:get(msg.account)
    if not acc then
        return {errmsg = "account not exist"}
    end

    if msg.password ~= acc.password then
        return {errmsg = "wrong password"}
    end

    return {errmsg = "success", token="token"}
end

function CMD.create_room(msg)
    local player = account_mgr:get(msg.account)
    if not player then
        return {errmsg = "invalid request"}
    end

    local info = {
        account = player.account,
        nickname = player.nickname,
        roomcard = player.roomcard
    }
    local ret = skynet.call("room_mgr", "lua", "create_room", info, msg.options)

    local ret_msg = {
        errmsg = "success",
        id = ret.id,
        number = ret.number,
        ip = ret.ip,
        port = ret.port,
        token = ret.token
    }

    return ret_msg
end

function CMD.join_room(msg)
    local player = account_mgr:get(msg.account)
    if not player then
        return {errmsg = "invalid request"}
    end

    local info = {
        account = player.account,
        nickname = player.nickname,
        roomcard = player.roomcard
    }
    local ret = skynet.call("room_mgr", "lua", "join_room", info, tonumber(msg.number))

    if ret.errmsg ~= "sucess" then
        return ret
    end
    local ret_msg = {
        errmsg = "success",
        id = ret.id,
        number = ret.number,
        ip = ret.ip,
        port = ret.port,
        token = ret.token
    }

    return ret_msg
end

skynet.start(function()
    skynet.dispatch("lua", function(_, session, cmd, ...)
        local f = CMD[cmd]
        if not f then
            return
        end

        if session == 0 then
            f(...)
        else
            skynet.ret(skynet.pack(f(...)))
        end
    end)

    skynet.register("player_mgr")
end)

