resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "LosOce_Cron"

-- Client Side Files --
client_scripts {
}

-- Server Side Files --
server_scripts {
	"server/server.lua",
}

-- Client Side Exported Functions --
exports {
	"Schedule"		-- exports.LosOce_Cron:Schedule(hour, minute, callback)
}					-- TriggerEvent('LosOce_Cron:Schedule', hour, minute, callback)

-- Server Side Exported Functions --	
server_exports {
	"Schedule"		-- exports.LosOce_Cron:Schedule(hour, minute, callback)
}					-- TriggerEvent('LosOce_Cron:Schedule', hour, minute, callback)

-- Prequisites --
dependencies {
}


--	local day		= os.date('*t', timestamp).wday			-- 0 = Everyday, 1 = Sunday, 2 = Monday and so on. 
--	local hour		= tonumber(os.date('%I', timestamp))	-- 12 hour time [01-12]  ( Use %H for 24 hour itme [00-23] )
--	local minute	= tonumber(os.date('%M', timestamp))	-- Minutes. [00-59]

---------------------------------------------
--  Execute task 05:10 & 17:10, every day  --

--  function CronTask(day, hour, minute)
--  if day ~= nil then
--  	print('Task done')
--  end

--  TriggerEvent('LosOce_Cron:Schedule', 5, 10, CronTask)
