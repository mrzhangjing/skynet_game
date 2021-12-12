local skynet = require "skynet"

local debugPort = tonumber(skynet.getenv("debugPort"))

skynet.start(
    function()
        print("------------------------------------")

        skynet.newservice("debug_console", debugPort)
        print(string.format("[DebugConsole] Port : %s", debugPort))

        local centerSvc = skynet.newservice("center")
        skynet.call(centerSvc, "lua", "getRoleBaseInfo", 1)
        -- skynet.newservice("gate_mgr")
        -- skynet.newservice("auth")

        -- skynet.newservice("gate_mgr")
        -- skynet.newservice("gamelog")
        -- local datacenterd = skynet.newservice("datacenterd")
        -- skynet.name(SERVICE.DATACENTER, datacenterd)
        -- skynet.newservice("main_db")

        -- skynet.newservice("agent_mgr")
        -- skynet.newservice("sys_storage")

        -- skynet.newservice("simple_http")
        -- skynet.newservice("channel_svc")
        -- skynet.newservice("marquee")
        -- skynet.newservice("record")
        -- skynet.newservice("chat")
        -- skynet.newservice("statistic")
        -- skynet.newservice("mail_svc")
        -- skynet.newservice("perfor_monitor")
        -- skynet.newservice("word_filter")

        -- skynet.newservice("activity")

        -- skynet.newservice("game_center")
        -- skynet.newservice("game_center_pool")
        -- skynet.newservice("sys_open")
        -- skynet.newservice("pvp")

        skynet.exit()
    end
)
