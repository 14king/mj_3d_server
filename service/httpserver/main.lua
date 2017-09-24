local skynet = require "skynet"
local socket = require "skynet.socket"

skynet.start(function()
    local agent = {}
    for i= 1, 20 do
        agent[i] = skynet.newservice("httpagent", i)
    end
    local port = skynet.getenv("webport")
    local balance = 1
    local id = socket.listen("0.0.0.0", port)
    skynet.error("Listen web port "..port)
    socket.start(id , function(id, addr)
        skynet.error(string.format("%s connected, pass it to httpagent :%08x", addr, agent[balance]))
        skynet.send(agent[balance], "lua", id, addr)
        balance = balance + 1
        if balance > #agent then
            balance = 1
        end
    end)
end)
