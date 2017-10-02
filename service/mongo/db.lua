local mongo = require "skynet.db.mongo"

local M = {}

function M:init()
    self.client = mongo.client({host = "127.0.0.1"})
    self.db = self.client["mj_3d_server"]
end

function M:insert(collection_name, obj)
    self.db[collection_name]:insert(obj)
end

function M:find_all(collection_name)
    local ret = self.db[collection_name]:find({})

    if not ret then
        return
    end

    local accounts = {}

    while ret:hasNext() do
        local acc = ret:next()
        accounts[acc.account] = acc
    end

    return accounts
end

return M
