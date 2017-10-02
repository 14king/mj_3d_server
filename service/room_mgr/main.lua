local skynet = require "skynet"
require "skynet.manager"
local mgr = require "mgr"

local CMD = {}

function CMD.start()
    mgr:init()
end

-- 查询玩家房间信息
function CMD.query_room_info()

end

-- 创建房间
function CMD.create_room(info, msg)
    local r = mgr:get_room_by_player(info.account)
    -- 已经在房间中
    if r then
        return {errmsg = "already in room"}
    end

    r = mgr:create_room(info, msg.options)
    return {
        id = r.id,
        number = r.number,
        ip = r.ip,
        port = r.port,
        token = r.token
    }
end

-- 加入房间
function CMD.join_room(info, number)
    local r = mgr:get_room_by_player(info.account)
    -- 已经在房间中
    if r then
        return {errmsg = "already in room"}
    end
    print("join room: number=",number)
    r = mgr:get_room_by_number(number)
    if not r then
        return {errmsg = "room not exist"}
    end

    -- 房间已开始
    if r.status == "play" then
        return {errmsg = "game in room already begin"}
    end

    mgr:join_room(info, r)
    print("ip", r.ip)
    return {
        id = r.id,
        number = r.number,
        ip = r.ip,
        port = r.port,
        token = r.token
    }
end

skynet.start(function ()
    skynet.dispatch("lua", function (_, session, cmd, ...)
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

    skynet.register("room_mgr")
end)


