local skynet = require "skynet"

skynet.start(function()
    skynet.error("server start begin ...")

    skynet.newservice("mongo")

    skynet.newservice("httpserver")

    skynet.newservice("login")

    skynet.newservice("room_mgr")

    skynet.newservice("player_mgr")
    skynet.call("mongo", "lua", "start")
    skynet.call("login", "lua", "start")
    skynet.call("player_mgr", "lua", "start")
    skynet.call("room_mgr", "lua", "start")
    skynet.exit()
end)
