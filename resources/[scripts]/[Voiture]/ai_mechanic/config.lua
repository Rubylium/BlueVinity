-------------------
-- C o n f i g s --
-------------------


companyName = "LsMécano"       
companyIcon = "CHAR_LS_CUSTOMS" -- https://wiki.gtanet.work/index.php?title=Notification_Pictures
spawnRadius = 100               -- Default Value: 
drivingStyle = 786603           -- Default Value: 786603
simplerRepair = false           -- When enabled, instead of getting out of the vehicle to repair, the mechanic stops his vehicle and the repair happens automatically.
repairComsticDamage = true     -- When enabled, the vehicle's cosmetic damage gets reset.
flipVehicle = true             -- When enabled, the vehicle will be flipped if on roof or side after repair.
 
-- To change the chat command (def. /mechanic), see line 1 of client.lua

-- Edit / Add Drivers and their information here!

mechPeds = {
                --  * Find the icons here:      https://wiki.gtanet.work/index.php?title=Notification_Pictures
                --  * Find the ped models here: https://wiki.gtanet.work/index.php?title=Peds
                --  * Find the vehicles here    https://wiki.gtanet.work/index.php?title=Vehicle_Models
                --  * Find the colours here:    https://wiki.gtanet.work/index.php?title=Vehicle_Colors

                [1] = {name = "Mécano Dave", icon = "CHAR_MP_MECHANIC", model = "s_m_m_autoshop_02", vehicle = 'UtilliTruck3', colour = 49, 
                                ['lines'] = {
                                        "Elle est comme neuve.",
                                        "Terminé.",
                                        "Ouais, ça devrais etre ok.",
                                        "Finit.",
                                        "Bingo, comme neuf!.",
                                        "J'ai du faire un peu de magie mais elle marche!",
                                        "C'est bon, rappel moi encore!",
                                        "Super simple!",
                                        "Plus doucement sur l'accelérateur la prochaine hein ?",
                                        "La seul chose que je peux pas réparer c'est mon mariage ...",
                                        "C'est bon. Rouler doucement !",
                                        "Bon, c'est limite mais sa roule!",}},

                --[2] = {name = "Mécano Miles", icon = "CHAR_MP_BIKER_MECHANIC", model = "S_M_Y_Construct_01", vehicle = 'BobcatXL', colour = 118, 
                --                ['lines'] = {
                --                        "Yeehaw, now she's fresher than a pillow with a mint on it!",
                --                        "All done here.",
                --                        "Job done.",
                --                        "I've done everything I could.",
                --                        "I hit it with a wrench a couple times and I think it worked!",
                --                        "Our company takes no responsibilities for spontanious combustions of the engine.",
                --                        "Sometimes I don't really think I know what I'm doing. Anyway, here's your car!",
                --                        "Ahh, yes... The water pipe needed to be replaced. All good now.",
                --                        "She's in perfect condition.",
                --                        "*slaps roof of the car* This bad boy can fit so many screws in it.",
                --                        "Should work now."}},

                -- You can use this template to make your own driver.

                --  * Find the icons here:      https://wiki.gtanet.work/index.php?title=Notification_Pictures
                --  * Find the ped models here: https://wiki.gtanet.work/index.php?title=Peds
                --  * Find the colours here:    https://wiki.gtanet.work/index.php?title=Vehicle_Colors
                --  * Driver ID needs to be a number (in sequential order from the previous one. In this example it would be 3).
                --[[
                
                --Edit the NAME, ICON, PED MODEL and TRUCK COLOUR here:
                [driver_ID] = {name = "driver_name", icon = "driver_icon", model = "ped_model", vehicle = 'vehicle_model' colour = 'driver_colour',

                                --You can add or edit any existing vehicle fix lines here:
                                [1] = {"Sample text 1","Sample text 2",}}, -- lines of dialogue.

                  
                ]]
                }
