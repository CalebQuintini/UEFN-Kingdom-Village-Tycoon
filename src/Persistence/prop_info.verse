tycoonprops<public> := struct<persistable>:
    PropId : string = ""
    IsPropBought : logic = false

prop_info<public> := class<final><persistable>:
    PropBoughtArray<public>:[]tycoonprops =
        array{
            # Houses
            tycoonprops{PropId := "HousesHitBox", IsPropBought := false},
            tycoonprops{PropId := "MoneyCollector", IsPropBought := false},
            tycoonprops{PropId := "WatchTower1", IsPropBought := false},
            tycoonprops{PropId := "WatchTower2", IsPropBought := false},
            tycoonprops{PropId := "WatchTower3", IsPropBought := false},
            tycoonprops{PropId := "WatchTower4", IsPropBought := false},
            tycoonprops{PropId := "ArmoryStand1", IsPropBought := false},
            tycoonprops{PropId := "House1", IsPropBought := false},
            tycoonprops{PropId := "House2", IsPropBought := false},
            tycoonprops{PropId := "House3", IsPropBought := false},
            tycoonprops{PropId := "House4", IsPropBought := false},
            tycoonprops{PropId := "House5", IsPropBought := false},
            tycoonprops{PropId := "House6", IsPropBought := false},
            tycoonprops{PropId := "House7", IsPropBought := false},
            tycoonprops{PropId := "House8", IsPropBought := false},
            tycoonprops{PropId := "House9", IsPropBought := false},
            tycoonprops{PropId := "House10", IsPropBought := false},
            tycoonprops{PropId := "House11", IsPropBought := false},
            tycoonprops{PropId := "House12", IsPropBought := false},
            tycoonprops{PropId := "House13", IsPropBought := false},
            tycoonprops{PropId := "House14", IsPropBought := false},
            tycoonprops{PropId := "House15", IsPropBought := false},
            tycoonprops{PropId := "House16", IsPropBought := false},
            tycoonprops{PropId := "House17", IsPropBought := false},
            tycoonprops{PropId := "House18", IsPropBought := false},
            tycoonprops{PropId := "House19", IsPropBought := false},
            tycoonprops{PropId := "House20", IsPropBought := false},
            tycoonprops{PropId := "House21", IsPropBought := false},

            # Farm
            tycoonprops{PropId := "FarmHitBox", IsPropBought := false},
            tycoonprops{PropId := "MoneyCollector2", IsPropBought := false},
            tycoonprops{PropId := "WatchTower5", IsPropBought := false},
            tycoonprops{PropId := "WatchTower6", IsPropBought := false},
            tycoonprops{PropId := "WatchTower7", IsPropBought := false},
            tycoonprops{PropId := "WatchTower8", IsPropBought := false},
            tycoonprops{PropId := "ArmoryStand2", IsPropBought := false},
            tycoonprops{PropId := "FarmHouse1", IsPropBought := false},
            tycoonprops{PropId := "FarmHouse2", IsPropBought := false},
            tycoonprops{PropId := "FarmHouse3", IsPropBought := false},
            tycoonprops{PropId := "FarmDirt1", IsPropBought := false},
            tycoonprops{PropId := "FarmDirt2", IsPropBought := false},
            tycoonprops{PropId := "FarmDirt3", IsPropBought := false},
            tycoonprops{PropId := "FarmHouse4", IsPropBought := false},
            tycoonprops{PropId := "FarmHouse5", IsPropBought := false},
            tycoonprops{PropId := "FarmHouse6", IsPropBought := false},

            # Markets
            tycoonprops{PropId := "MarketHitBox", IsPropBought := false},
            tycoonprops{PropId := "MoneyCollector3", IsPropBought := false},
            tycoonprops{PropId := "WatchTower9", IsPropBought := false},
            tycoonprops{PropId := "MarketStall1", IsPropBought := false},
            tycoonprops{PropId := "MarketStall2", IsPropBought := false},
            tycoonprops{PropId := "MarketStall3", IsPropBought := false},
            tycoonprops{PropId := "MarketStall4", IsPropBought := false},
            tycoonprops{PropId := "MarketStall5", IsPropBought := false},
            tycoonprops{PropId := "MarketStall6", IsPropBought := false},
            tycoonprops{PropId := "MarketStall7", IsPropBought := false},
            tycoonprops{PropId := "TownCentre", IsPropBought := false},
            tycoonprops{PropId := "ArmoryStand3", IsPropBought := false},

            # Training Area
            tycoonprops{PropId := "TrainingHitBox", IsPropBought := false},
            tycoonprops{PropId := "MoneyCollector4", IsPropBought := false},
            tycoonprops{PropId := "WatchTower10", IsPropBought := false},
            tycoonprops{PropId := "Walls1", IsPropBought := false},
            tycoonprops{PropId := "Walls2", IsPropBought := false},
            tycoonprops{PropId := "Walls3", IsPropBought := false},
            tycoonprops{PropId := "Walls4", IsPropBought := false},
            tycoonprops{PropId := "Gravel", IsPropBought := false},
            tycoonprops{PropId := "ArcheryBuilding1", IsPropBought := false},
            tycoonprops{PropId := "ArcheryBuilding2", IsPropBought := false},
            tycoonprops{PropId := "ArcheryBuilding3", IsPropBought := false},
            tycoonprops{PropId := "ArcheryBuilding4", IsPropBought := false},
            tycoonprops{PropId := "ArcheryBuilding5", IsPropBought := false},
            tycoonprops{PropId := "StorageHouse1", IsPropBought := false},
            tycoonprops{PropId := "StorageHouse2", IsPropBought := false},
            tycoonprops{PropId := "ArmoryStand4", IsPropBought := false},

            # Temples
            tycoonprops{PropId := "TempleHitBox", IsPropBought := false},
            tycoonprops{PropId := "MoneyCollector5", IsPropBought := false},
            tycoonprops{PropId := "WatchTower11", IsPropBought := false},
            tycoonprops{PropId := "Temple1", IsPropBought := false},
            tycoonprops{PropId := "Temple2", IsPropBought := false},
            tycoonprops{PropId := "Temple3", IsPropBought := false},
            tycoonprops{PropId := "Temple4", IsPropBought := false},
            tycoonprops{PropId := "MainTemple", IsPropBought := false},

            # WindMills
            tycoonprops{PropId := "WatchTower12", IsPropBought := false},
            tycoonprops{PropId := "WindMill1", IsPropBought := false},
            tycoonprops{PropId := "WindMill2", IsPropBought := false},
            tycoonprops{PropId := "WindMill3", IsPropBought := false},
            tycoonprops{PropId := "WindMill4", IsPropBought := false},
            tycoonprops{PropId := "WindMill5", IsPropBought := false},
            tycoonprops{PropId := "WindMill6", IsPropBought := false},

            # Quarry
            tycoonprops{PropId := "QuarryDirt", IsPropBought := false},
            tycoonprops{PropId := "QuarryHitBox", IsPropBought := false},
            tycoonprops{PropId := "MoneyCollector6", IsPropBought := false},
            tycoonprops{PropId := "WatchTower13", IsPropBought := false},
            tycoonprops{PropId := "QuarryWall1", IsPropBought := false},
            tycoonprops{PropId := "QuarryWall2", IsPropBought := false},
            tycoonprops{PropId := "QuarryWall3", IsPropBought := false},
            tycoonprops{PropId := "QuarryWall4", IsPropBought := false},
            tycoonprops{PropId := "QuarryMine1", IsPropBought := false},
            tycoonprops{PropId := "QuarryMine2", IsPropBought := false},
            tycoonprops{PropId := "QuarryMine3", IsPropBought := false},
            tycoonprops{PropId := "QuarryRock1", IsPropBought := false},
            tycoonprops{PropId := "QuarryRock2", IsPropBought := false},
            tycoonprops{PropId := "QuarryRock3", IsPropBought := false},
            tycoonprops{PropId := "QuarryRock4", IsPropBought := false},
            tycoonprops{PropId := "QuarryRock5", IsPropBought := false},
            tycoonprops{PropId := "QuarryRock6", IsPropBought := false},
            tycoonprops{PropId := "QuarryRock7", IsPropBought := false},
            tycoonprops{PropId := "QuarryRock8", IsPropBought := false},
            tycoonprops{PropId := "QuarryStorage1", IsPropBought := false},
            tycoonprops{PropId := "QuarryStorage2", IsPropBought := false},

            # Barracks
            tycoonprops{PropId := "BarracksHitBox", IsPropBought := false},
            tycoonprops{PropId := "MoneyCollector7", IsPropBought := false},
            tycoonprops{PropId := "WatchTower14", IsPropBought := false},
            tycoonprops{PropId := "WatchTower15", IsPropBought := false},
            tycoonprops{PropId := "WatchTower16", IsPropBought := false},
            tycoonprops{PropId := "WatchTower17", IsPropBought := false},
            tycoonprops{PropId := "Barracks", IsPropBought := false},

            # Wood
            tycoonprops{PropId := "WoodHitBox", IsPropBought := false},
            tycoonprops{PropId := "MoneyCollector8", IsPropBought := false},
            tycoonprops{PropId := "WatchTower18", IsPropBought := false},
            tycoonprops{PropId := "WatchTower19", IsPropBought := false},
            tycoonprops{PropId := "WatchTower20", IsPropBought := false},
            tycoonprops{PropId := "WatchTower21", IsPropBought := false},
            tycoonprops{PropId := "Wood1", IsPropBought := false},
            tycoonprops{PropId := "Wood2", IsPropBought := false},
            tycoonprops{PropId := "Wood3", IsPropBought := false},
            tycoonprops{PropId := "Wood4", IsPropBought := false},
            tycoonprops{PropId := "Wood5", IsPropBought := false},
            tycoonprops{PropId := "Wood6", IsPropBought := false},

            # Castle
            tycoonprops{PropId := "Castle", IsPropBought := false},
            tycoonprops{PropId := "Rebirth", IsPropBought := false}
        }

MakePropBoughttInfo<constructor>(Src:prop_info)<transacts> := prop_info:
    PropBoughtArray := Src.PropBoughtArray
