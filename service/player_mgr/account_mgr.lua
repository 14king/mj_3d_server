local skynet = require "skynet"

local M = {}

function M:init()
    self.tbl = {}
    self.loaded = false
end

function M:load()
    print("加载所有帐号数据")
    local accounts = skynet.call("mongo", "lua", "load_all_account")
    if not accounts then
        return
    end

    for _,v in pairs(accounts) do
        self.tbl[v.account] = v
    end
    self.loaded = true
end

function M:get(account)
    return self.tbl[account]
end

function M:register(account, password)
    local info = {
        account = account,
        password = password,
        nickname = "haha"..math.random(1,10000),
        roomcard = 100
    }
    self.tbl[account] = info
    -- 通知mongo存库
    skynet.send("mongo", "lua", "new_account", info)
end

return M
