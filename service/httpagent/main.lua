local skynet = require "skynet"
local socket = require "skynet.socket"
local httpd = require "http.httpd"
local sockethelper = require "http.sockethelper"
local urllib = require "http.url"
local handler = require "handler"
local cjson = require "cjson"

local function response(id, ...)
    local ok, err = httpd.write_response(sockethelper.writefunc(id), ...)
    if not ok then
        -- if err == sockethelper.socket_error , that means socket closed.
        skynet.error(string.format("fd = %d, %s", id, err))
    end
end

local function handle(id, addr)
    skynet.error("handle http request from "..addr)
    socket.start(id)
    -- limit request body size to 8192 (you can pass nil to unlimit)
    local code, url, method, header, body = httpd.read_request(sockethelper.readfunc(id), 8192)
    if not code or code ~= 200 then
        response(id, code)
        return
    end

    local tmp = {}
    if header.host then
        table.insert(tmp, string.format("host: %s", header.host))
    end
    local path, query = urllib.parse(url)
    table.insert(tmp, string.format("path: %s", path))
    if #path <= 1 or not query then
        return
    end

    local q = urllib.parse_query(query)
    local f = handler[string.sub(path,2)]
    if not f then
        return
    end
    local ret = f(q)
    if ret then
        response(id, code, cjson.encode(ret))
    end
end

skynet.start(function()
    skynet.dispatch("lua", function (_, _, id, addr)
        local ret = xpcall(function () handle(id, addr) end, function (msg) print(debug.traceback(msg)) end, 33)
        socket.close(id)
    end)
end)
