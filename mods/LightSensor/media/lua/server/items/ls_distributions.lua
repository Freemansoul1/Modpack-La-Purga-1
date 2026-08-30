--------------------------------  PATCH -------------------------------------
require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"
require "Items/ItemPicker"	

table.insert(ProceduralDistributions.list["ShelfGeneric"].items, "LightSensors.LSElectronicsMag");
table.insert(ProceduralDistributions.list["ShelfGeneric"].items, 0.2);
table.insert(ProceduralDistributions.list["BookstoreBooks"].items, "LightSensors.LSElectronicsMag");
table.insert(ProceduralDistributions.list["BookstoreBooks"].items, 2);
table.insert(ProceduralDistributions.list["PostOfficeMagazines"].items, "LightSensors.LSElectronicsMag");
table.insert(ProceduralDistributions.list["PostOfficeMagazines"].items, 1);
table.insert(SuburbsDistributions["all"]["sidetable"].items, "LightSensors.LSElectronicsMag");
table.insert(SuburbsDistributions["all"]["sidetable"].items, 0.3);

table.insert(ProceduralDistributions.list["ShelfGeneric"].items, "LightSensors.LSElectronicsMagTraps");
table.insert(ProceduralDistributions.list["ShelfGeneric"].items, 0.2);
table.insert(ProceduralDistributions.list["BookstoreBooks"].items, "LightSensors.LSElectronicsMagTraps");
table.insert(ProceduralDistributions.list["BookstoreBooks"].items, 2);
table.insert(ProceduralDistributions.list["PostOfficeMagazines"].items, "LightSensors.LSElectronicsMagTraps");
table.insert(ProceduralDistributions.list["PostOfficeMagazines"].items, 1);
table.insert(SuburbsDistributions["all"]["sidetable"].items, "LightSensors.LSElectronicsMagTraps");
table.insert(SuburbsDistributions["all"]["sidetable"].items, 0.3);