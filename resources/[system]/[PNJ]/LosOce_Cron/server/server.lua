local Queue     = {}
local LastTime = nil

function Schedule(hour, minute, callback)

	table.insert(Queue, {
		hour  		= hour,
		minute  	= minute,
		callback 	= callback
	})

end

function GetTime()

	local timestamp = os.time()
	local day	= os.date('*t', timestamp).wday			-- 0 = Everyday, 1 = Sunday, 2 = Monday and so on. 
	local hour	= tonumber(os.date('%I', timestamp))		-- 12 hour time [01-12] (Use %H for 24 hour time [00-23])
	local minute	= tonumber(os.date('%M', timestamp))		-- Minutes. [00-59]

	return {day = day, hour = hour, minute = minute}

end

function OnTime(day, hour, minute)

	for i=1, #Queue, 1 do
		if Queue[i].hour == hour and Queue[i].minute == minute then
			Queue[i].callback(day, hour, minute)
		end
	end

end

function Tick()

	local time = GetTime()

	if time.hour ~= LastTime.hour or time.minute ~= LastTime.minute then
		OnTime(time.day, time.hour, time.minute)
		LastTime = time
	end

	SetTimeout(60000, Tick)
end

LastTime = GetTime()

Tick()

AddEventHandler('LosOce_Cron:Schedule', function(hour, minute, callback)
	Schedule(hour, minute, callback)
end)
