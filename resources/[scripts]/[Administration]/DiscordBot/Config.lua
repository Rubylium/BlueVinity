DiscordWebhookSystemInfos = 'https://discordapp.com/api/webhooks/597370675539214358/quoZDi7LJTqLuVM76zBvlX-Hd9hMG4GMM1oFtieOXgVP_X8pj7ORga_uPYrtmS2Z73vB'
DiscordWebhookKillinglogs = 'https://discordapp.com/api/webhooks/596980622975565825/ldBLFIKqnTpxFbVaikw-ZkD-ztvffAdQjiFk0_bbugYNMeqYRFG4F4pZtZHXpeLETHeF'
DiscordWebhookChat = 'https://discordapp.com/api/webhooks/596980799115624449/u8IOu2LVZuN__vNM4VjLnRHNKyCJbZrsmPCpOySiwlJxHJeNRNjZyNQkvM5AqmUEtQ6g'
DiscordServeurON = 'https://discordapp.com/api/webhooks/606088680607711263/ChHC-FrCqj1RrQy1n2e2BIOFTnqn-Xc7ivzPE20Kfte6TZlx0X76SltQsd0KGZfRwufi'

SystemAvatar = 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png'

UserAvatar = 'https://i.imgur.com/KIcqSYs.png'

SystemName = 'BlueVinity - LOG SYSTEM'


--[[ Special Commands formatting
		 *YOUR_TEXT*			--> Make Text Italics in Discord
		**YOUR_TEXT**			--> Make Text Bold in Discord
	   ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		__YOUR_TEXT__			--> Underline Text in Discord
	   __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	  __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	 __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		~~YOUR_TEXT~~			--> Strikethrough Text in Discord
]]
-- Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
-- Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command


-- These special commands will be printed differently in discord, depending on what you set it to
SpecialCommands = {
				   {'/ooc', '**[OOC]:**'},
				   {'/911', '**[911]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
				  }

						
-- These blacklisted commands will not be printed in discord
BlacklistedCommands = {
					   '/AnyCommand',
					   '/AnyCommand2',
					  }

-- These Commands will use their own webhook
OwnWebhookCommands = {
					  {'/giveweapon', 'https://discordapp.com/api/webhooks/597371062744907786/DMzAW7Vixhp65u3mzEMwcHBAkeIXEec90GK2lt9aTZAiQAZcn6x4MfpTThvfH5p9b2Tz'},
					  {'/AnotherCommand2', 'WEBHOOK_LINK_HERE'},
					 }

-- These Commands will be sent as TTS messages
TTSCommands = {
			   '/Whatever',
			   '/Whatever2',
			  }

