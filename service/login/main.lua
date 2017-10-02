local skynet = require "skynet"
require "skynet.manager"

local CMD = {}

function CMD.start()
end

function CMD.register(msg)
    return skynet.call("player_mgr", "lua", "register", msg)
end

function CMD.login(msg)
    return skynet.call("player_mgr", "lua", "login", msg)
end


skynet.start(function ()
    skynet.register("login")

    skynet.dispatch("lua", function (_, session, cmd, ...)
        local f = CMD[cmd]
        if not f then
            skynet.error("unknow cmd "..cmd)
            return
        end

        if session == 0 then
            f(...)
        else
            skynet.ret(skynet.pack(f(...)))
        end
    end)
end)
