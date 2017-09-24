local skynet = require "skynet"

skynet.start(function()
    skynet.error("server start begin ...")
    
    skynet.newservice("httpserver")
end)
