resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

data_file 'VEHICLE_LAYOUTS_FILE' 'data/vehiclelayouts.meta'
data_file 'HANDLING_FILE' 'data/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'

files {
  'data/vehiclelayouts.meta',
  'data/handling.meta',
  'data/vehicles.meta',
  'data/carcols.meta',
  'data/carvariations.meta',
}

client_script 'vehicle_names.lua'

-- Skyline

files {
	'stream/SkyLine/carvariations.meta',
	'stream/SkyLine/dlctext.meta',
	'stream/SkyLine/handling.meta',
  'stream/SkyLine/vehicles.meta',
  'stream/SkyLine/vehiclelayouts.meta',
	'stream/SkyLine/carcontentunlocks.meta'
}

data_file 'VEHICLE_LAYOUTS_FILE' 'stream/SkyLine/vehiclelayouts.meta'
data_file 'VEHICLE_VARIATION_FILE' 'stream/SkyLine/carvariations.meta'
data_file 'DLCTEXT_FILE' 'stream/SkyLine/dlctext.meta'
data_file 'HANDLING_FILE' 'stream/SkyLine/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/SkyLine/vehicles.meta'
data_file 'CARCONTENTUNLOCKS_FILE' 'stream/SkyLine/carcontentunlocks.meta'

client_scripts 'stream/SkyLine/vehicle_names.lua'

files {
	'stream/mitsu/handling.meta'
}

data_file 'HANDLING_FILE' 'stream/mitsu/handling.meta'

-- Supra fast

files {
	'stream/Aventador/carvariations.meta',
	'stream/Aventador/handling.meta',
  'stream/Aventador/vehicles.meta',
  'stream/Aventador/alexmodscontentunlocks.meta',
  'stream/Aventador/dlctext.meta',
	'stream/Aventador/carcols.meta'
}

data_file 'VEHICLE_VARIATION_FILE' 'stream/Aventador/carvariations.meta'
data_file 'DLCTEXT_FILE' 'stream/Aventador/dlctext.meta'
data_file 'HANDLING_FILE' 'stream/Aventador/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/Aventador/vehicles.meta'
data_file 'CARCOLS_FILE' 'stream/Aventador/carcols.meta'
data_file 'CARCONTENTUNLOCKS_FILE' 'stream/Aventador/alexmodscontentunlocks.meta'
data_file 'DLCTEXT_FILE' 'stream/Aventador/dlctext.meta'


-- 16m5


files {
  'stream/16m5/data/vehicles.meta',
  'stream/16m5/data/carvariations.meta',
  'stream/16m5/data/carcols.meta',
  'stream/16m5/data/handling.meta',
}

data_file 'HANDLING_FILE' 'stream/16m5/data/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/16m5/data/vehicles.meta'
data_file 'CARCOLS_FILE' 'stream/16m5/data/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'stream/16m5/data/carvariations.meta'

-- gtr


files {
  'stream/gtr/data/vehicles.meta',
  'stream/gtr/data/carvariations.meta',
  'stream/gtr/data/carcols.meta',
  'stream/gtr/data/handling.meta',
}

data_file 'HANDLING_FILE' 'stream/gtr/data/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/gtr/data/vehicles.meta'
data_file 'CARCOLS_FILE' 'stream/gtr/data/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'stream/gtr/data/carvariations.meta'

-- pack


files {
  'stream/stews_car_pack/vehicles.meta',
  'stream/stews_car_pack/carvariations.meta',
  'stream/stews_car_pack/carcols.meta',
  'stream/stews_car_pack/handling.meta',
  --'vehiclelayouts.meta',
}

data_file 'HANDLING_FILE' 'stream/stews_car_pack/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/stews_car_pack/vehicles.meta'
data_file 'CARCOLS_FILE' 'stream/stews_car_pack/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'stream/stews_car_pack/carvariations.meta'
--data_file 'VEHICLE_LAYOUTS_FILE' 'vehiclelayouts.meta'

client_script 'vehiclenames.lua' 

-- pack super sportive


files {
  'stream/SuperSportive/vehicles.meta',
  'stream/SuperSportive/carvariations.meta',
  'stream/SuperSportive/carcols.meta',
  'stream/SuperSportive/handling.meta',
  'stream/SuperSportive/vehiclelayouts.meta',    -- Not Required
}

data_file 'HANDLING_FILE' 'stream/SuperSportive/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/SuperSportive/vehicles.meta'
data_file 'CARCOLS_FILE' 'stream/SuperSportive/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'stream/SuperSportive/carvariations.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'stream/SuperSportive/vehiclelayouts.meta'   -- Not Required


client_script {
  'stream/SuperSportive/vehicle_names.lua'    -- Not Required
}