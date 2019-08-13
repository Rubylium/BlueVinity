Config = {}

-- priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
Config.Priority = {
    ["steam:1100001358dbb4b"] = 10000000, -- Hoyame
    ["steam:11000013cae2393"] = 1000000, -- Alexis Lafaille le dev
    ["steam:110000110762d1e"] = 5000, -- Wendy
    ["steam:1100001128eefaa"] = 5000, -- Damien Dufort
    ["steam:11000010c62e3cb"] = 8000, -- vapckvip soupiro
    ["steam:1100001141bf3a0"] = 5000, -- Hakim Sam
    ["steam:11000010fe2d7e8"] = 5000, -- NESS Amrini
    ["steam:11000011664380f"] = 5000, -- Norbert Deladé
    ["steam:11000013c476b0a"] = 5000, -- Louis De Laroche
    ["steam:11000013c31c8b1"] = 5000, -- NESS Amrini
    ["steam:1100001139ac8fa"] = 5000, -- Paul Corleonne
    ["steam:110000116138b6e"] = 5000, -- Michel
    ["steam:11000010f080b40"] = 5000, -- Paul
-- LA POLICE DU FA POUR QU'il EST UNE PRIO POUR ENTRER SUR LE SERVEUR :
    ["steam:1100001142ea5bc"] = 500, -- Pablolito Rosper
    ["steam:11000010dd4b95a"] = 500, -- Yurik Maktaeïv
    ["steam:11000010cd92361"] = 500, -- William Muller
    ["steam:1100001075ec6b1"] = 500, -- Mike DUBOBH
    ["steam:1100001143cebb4"] = 500, -- Jonh Kennedy
    ["steam:110000111a34fde"] = 500, -- Alexandre Bourbouillon
-- PACK ACHETER
    ["steam:11000010562b65d"] = 5000, -- Annah
    ["steam:110000110ba08ca"] = 5000, -- John Wish
    ["steam:11000010112536a"] = 5000, -- Gibbs844
-- DISCORD NITRO BOOST
    ["steam:11000011085fa20"] = 5000, -- Vito
    ["steam:110000117ac44fd"] = 5000, -- WILLIAM MULLER
    ["steam:1100001375a5be7"] = 5000, -- Julio Gonzalez
    ["steam:11000011acdd873"] = 5000, -- Niko Zika
    ["steam:11000010f12ed4b"] = 5000, -- Jack Bauwer
    ["steam:11000010b40eaa2"] = 5000, -- Lena
    ["steam:110000108154549"] = 5000, -- Hans
    ["steam:11000013bcabf06"] = 5000, -- Mehdi
    ["steam:11000010919daf1"] = 5000, -- Theo Anderson
    ["steam:1100001367bc337"] = 5000, -- Tonny Labouffe
    ["steam:110000111ac735f"] = 5000, -- Joe Marking
}

-- require people to run steam
Config.RequireSteam = true

-- "whitelist" only server
Config.PriorityOnly = false

-- disables hardcap, should keep this true
Config.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
Config.ConnectTimeOut = 1200

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
Config.QueueTimeOut = 60

-- will give players temporary priority when they disconnect and when they start loading in
Config.EnableGrace = true

-- how much priority power grace time will give
Config.GracePower = 5

-- how long grace time lasts in seconds
Config.GraceTime = 200

-- will show how many people have temporary priority in the connection message
Config.ShowTemp = true

-- simple localization
Config.Language = {
    joining = "\xF0\x9F\x8E\x89Connexion...",
    connecting = "\xE2\x8F\xB3Chargement...",
    idrr = "\xE2\x9D\x97Error: Retentez de vous connecter.",
    err = "\xE2\x9D\x97Une erreur est survenue",
    pos = "\xF0\x9F\x90\x8CVous êtes %d/%d en file \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97Une erreur est survenue",
    timedout = "\xE2\x9D\x97Timed out?",
    wlonly = "\xE2\x9D\x97Serveur en maintenance",
    steam = "\xE2\x9D\x97Vous devez lancer Steam"
}