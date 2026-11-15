tracker_info<public> := struct:
    id : string
    Title : string
    Description : string

GetTrackerInformation<public>()<transacts>: []tracker_info =
    array{
    tracker_info{id := "HousesHitBox", Title := "Purchase HitBox", Description := "Purchase the HitBox"},
    tracker_info{id := "MoneyCollector", Title := "Money Collector", Description := "Purchase Money\n Collector"},
    tracker_info{id := "WatchTower1", Title := "Purchase Watchtower", Description := "Purchase the\n Watchtower"},
    tracker_info{id := "WatchTower2", Title := "Purchase Watchtower", Description := "Purchase the\n Watchtower"},
    tracker_info{id := "WatchTower3", Title := "Purchase Watchtower", Description := "Purchase the\n Watchtower"},
    tracker_info{id := "WatchTower4", Title := "Purchase Watchtower", Description := "Purchase the\n Watchtower"},
    tracker_info{id := "ArmoryStand1", Title := "Purchase Weapon Shop", Description := "Purchase the\n Weapon Shop"}
    }
