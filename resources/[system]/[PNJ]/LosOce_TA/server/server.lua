-- 		 LosOceanic_TA =  Traffic / Pedestrian / Parked Cars Adjuster		--
--		Every 5 Minutes, count player total and update the calculation		--
--			By DK - 2019...	Dont forget your Bananas!			--
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Functions																--
------------------------------------------------------------------------------

function ServerTrigger(day, hour, minute)
	TriggerEvent('LosOce_TA:Force')
	print('	^0[^1Alert^0] : | Cron Job: Syncing Client Traffic. H:'..hour..', M: '..minute..'. | : [^1Alert^0] ')
end

------------------------------------------------------------------------------
-- Events															--
------------------------------------------------------------------------------

TriggerEvent('LosOce_Cron:Schedule', 12, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 12, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 12, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 12, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 12, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 12, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 12, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 12, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 12, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 12, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 12, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 01, 00, ServerTrigger)	--

TriggerEvent('LosOce_Cron:Schedule', 01, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 01, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 01, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 01, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 01, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 01, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 01, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 01, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 01, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 01, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 01, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 02, 00, ServerTrigger)	--

TriggerEvent('LosOce_Cron:Schedule', 02, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 02, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 02, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 02, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 02, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 02, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 02, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 02, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 02, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 02, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 02, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 03, 00, ServerTrigger)	--

TriggerEvent('LosOce_Cron:Schedule', 03, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 03, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 03, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 03, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 03, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 03, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 03, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 03, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 03, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 03, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 03, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 04, 00, ServerTrigger)	--

TriggerEvent('LosOce_Cron:Schedule', 04, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 04, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 04, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 04, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 04, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 04, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 04, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 04, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 04, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 04, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 04, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 05, 00, ServerTrigger)	--

TriggerEvent('LosOce_Cron:Schedule', 05, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 05, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 05, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 05, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 05, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 05, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 05, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 05, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 05, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 05, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 05, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 06, 00, ServerTrigger)	-- 

TriggerEvent('LosOce_Cron:Schedule', 06, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 06, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 06, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 06, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 06, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 06, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 06, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 06, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 06, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 06, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 06, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 07, 00, ServerTrigger)	--

TriggerEvent('LosOce_Cron:Schedule', 07, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 07, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 07, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 07, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 07, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 07, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 07, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 07, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 07, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 07, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 07, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 08, 00, ServerTrigger)	--

TriggerEvent('LosOce_Cron:Schedule', 08, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 08, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 08, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 08, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 08, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 08, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 08, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 08, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 08, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 08, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 08, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 09, 00, ServerTrigger)	--

TriggerEvent('LosOce_Cron:Schedule', 09, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 09, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 09, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 09, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 09, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 09, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 09, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 09, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 09, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 09, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 09, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 10, 00, ServerTrigger)	--

TriggerEvent('LosOce_Cron:Schedule', 10, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 10, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 10, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 10, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 10, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 10, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 10, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 10, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 10, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 10, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 10, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 11, 00, ServerTrigger)	--

TriggerEvent('LosOce_Cron:Schedule', 11, 05, ServerTrigger)	-- Every Increment of Five Minutes.
TriggerEvent('LosOce_Cron:Schedule', 11, 10, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 11, 15, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 11, 20, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 11, 25, ServerTrigger)	-- 
TriggerEvent('LosOce_Cron:Schedule', 11, 30, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 11, 35, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 11, 40, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 11, 45, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 11, 50, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 11, 55, ServerTrigger)	--
TriggerEvent('LosOce_Cron:Schedule', 12, 00, ServerTrigger)	--

print('	^0[^5Debug^0] : | Added TrafficAdjust Cron(s) to the Queue [Every 5 minutes]. | : [^5Debug^0]')
print('	^0[^5Debug^0] : | Players Counted 	= '..Config.iPlayers..'. | : [^5Debug^0]')
print('	^0[^5Debug^0] : | Total Traffic 	= '..Config.TrafficX..'. | : [^5Debug^0]')
print('	^0[^5Debug^0] : | Parked Traffic 	= '..Config.ParkedX..'. | : [^5Debug^0]')	
print('	^0[^5Debug^0] : | Total Peds 		= '..Config.PedestrianX..'. | : [^5Debug^0]')
