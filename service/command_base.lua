require("functions")

local skynet = require "skynet"
local profile = require "skynet.profile"

local command = {}
local timeStatistics = {}

function command.gc()
    collectgarbage("collect")
end

local function dispatch(session, address, cmd, ...)
    skynet.trace()
    profile.start()

    local func = command[cmd]
    local ret1, ret2, ret3, ret4, ret5
    if func then
        ret1, ret2, ret3, ret4, ret5 = func(...)
    else
        -- logger.Errorf("[0x%x] cmd[%s] from address[0x%0x] is not found.", skynet.self(), cmd, address)
    end

    -- 记录耗时
    local time = profile.stop()
    local p = timeStatistics[cmd]
    if p == nil then
        p = {
            count = 0,
            time = 0,
            max = 0
        }
        timeStatistics[cmd] = p
    end
    p.count = p.count + 1
    p.time = p.time + time
    p.max = math.max(p.max, time)

    if session > 0 then
        local ok, msg =
            xpcall(
            function()
                skynet.ret(skynet.pack(ret1, ret2, ret3, ret4, ret5))
            end,
            debug.traceback
        )
        if not ok then
        -- logger.Errorf("[0x%x] cmd[%s] from address[0x%0x] err. traceback:%s", skynet.self(), cmd, address, msg)
        end
    end
end

skynet.dispatch("lua", dispatch)

skynet.info_func(
    function()
        local timeInfo = ""
        for cmd, p in pairs(timeStatistics) do
            timeInfo = string.format("%s\n[%s][count:%s][time:%s][max:%s]", timeInfo, cmd, p.count, p.time, p.max)
        end
        return {
            mem = collectgarbage("count"),
            profile = timeInfo
        }
    end
)

return command
