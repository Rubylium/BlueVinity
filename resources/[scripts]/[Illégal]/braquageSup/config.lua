Config = {}
Translation = {}

Config.Shopkeeper = 416176080 -- hash of the shopkeeper ped
Config.Locale = 'en' -- 'en', 'sv' or 'custom'

Config.Shops = {
    -- {coords = vector3(x, y, z), heading = peds heading, money = {min, max}, cops = amount of cops required to rob, blip = true: add blip on map false: don't add blip, name = name of the store (when cops get alarm, blip name etc)}
    {coords = vector3(24.03, -1345.63, 29.5-0.98), heading = 266.0, money = {1000, 5000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-705.73, -914.91, 19.22-0.98), heading = 91.0, money = {1500, 5000}, cops = 2, blip = false, name = '7/11', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false}

}

Translation = {
    ['en'] = {
        ['shopkeeper'] = 'Vendeur',
        ['robbed'] = "J'ai déja été braqué! j'ai plus rien!",
        ['cashrecieved'] = 'Vous avez eu:',
        ['currency'] = '$',
        ['scared'] = 'Peur:',
        ['no_cops'] = "Il n'y a ~r~pas~w~ assez de policier!",
        ['cop_msg'] = "Une photo de l'individue à été envoyer à la police!",
        ['set_waypoint'] = 'Mettre un point GPS sur le magasin',
        ['hide_box'] = 'Fermer cette box',
        ['robbery'] = 'Braquage en cours',
        ['walked_too_far'] = 'Tu est partie trop loin!'
    },
    ['sv'] = {
        ['shopkeeper'] = 'butiksbiträde',
        ['robbed'] = 'Jag blev precis rånad och har inga pengar kvar!',
        ['cashrecieved'] = 'Du fick:',
        ['currency'] = 'SEK',
        ['scared'] = 'Rädd:',
        ['no_cops'] = 'Det är inte tillräckligt med poliser online!',
        ['cop_msg'] = 'Vi har skickat en bild på rånaren från övervakningskamerorna!',
        ['set_waypoint'] = 'Sätt GPS punkt på butiken',
        ['hide_box'] = 'Stäng denna rutan',
        ['robbery'] = 'Pågående butiksrån',
        ['walked_too_far'] = 'Du gick för långt bort!'
    },
    ['custom'] = { -- edit this to your language
        ['shopkeeper'] = '',
        ['robbed'] = '',
        ['cashrecieved'] = '',
        ['currency'] = '',
        ['scared'] = '',
        ['no_cops'] = '',
        ['cop_msg'] = '',
        ['set_waypoint'] = '',
        ['hide_box'] = '',
        ['robbery'] = '',
        ['walked_too_far'] = ''
    }
}