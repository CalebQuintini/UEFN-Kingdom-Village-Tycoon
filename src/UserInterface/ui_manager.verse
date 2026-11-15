using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /Fortnite.com/Characters }
using { TycoonElements }

ui_manager<public> := class(creative_device):

    # Tracker UI
    @editable
    TrackerUI:tracker_ui = tracker_ui{}
    @editable
    MoneyResourceUI:Money_resource_ui = Money_resource_ui{}
    @editable
    HousesHitBoxUpgradesUI:houses_hitbox_upgrades_ui=houses_hitbox_upgrades_ui{}
    @editable
    FarmHitBoxUpgradesUI:farm_hitbox_upgrade_ui=farm_hitbox_upgrade_ui{}
    @editable
    MarketsHitBoxUpgradesUI:markets_hitbox_upgrade_ui=markets_hitbox_upgrade_ui{}
    @editable
    TrainingGroundsHitBoxUpgradesUI:training_grounds_hitbox_upgrade_ui=training_grounds_hitbox_upgrade_ui{}
    @editable
    TempleHitBoxUpgradesUI:temple_hitbox_upgrade_ui=temple_hitbox_upgrade_ui{}
    @editable
    QuarryHitBoxUpgradesUI:quarry_hitbox_upgrade_ui=quarry_hitbox_upgrade_ui{}
    @editable
    BarracksHitBoxUpgradesUI:barracks_hitbox_upgrade_ui=barracks_hitbox_upgrade_ui{}
    @editable
    WoodHitBoxUpgradesUI:wood_hitbox_upgrade_ui=wood_hitbox_upgrade_ui{}
    @editable
    UnCommonWeaponShopUI:uncommon_weaponshop_ui=uncommon_weaponshop_ui{}
    @editable
    CommonWeaponShopUI:common_weaponshop_ui=common_weaponshop_ui{}
    @editable
    RareWeaponShopUI:rare_weaponshop_ui=rare_weaponshop_ui{}
    @editable
    EpicWeaponShopUI:epic_weaponshop_ui=epic_weaponshop_ui{}

    # ------ ADD & REMOVE PLAYER LOGIC------
    PlayerAdded<public>(Player:player):void=
        MoneyResourceUI.PlayerAdded(Player)
        HousesHitBoxUpgradesUI.PlayerAdded(Player)
        FarmHitBoxUpgradesUI.PlayerAdded(Player)
        MarketsHitBoxUpgradesUI.PlayerAdded(Player)
        TrainingGroundsHitBoxUpgradesUI.PlayerAdded(Player)
        TempleHitBoxUpgradesUI.PlayerAdded(Player)
        QuarryHitBoxUpgradesUI.PlayerAdded(Player)
        BarracksHitBoxUpgradesUI.PlayerAdded(Player)
        WoodHitBoxUpgradesUI.PlayerAdded(Player)
        TrackerUI.PlayerAdded(Player)
        UnCommonWeaponShopUI.PlayerAdded(Player)
        CommonWeaponShopUI.PlayerAdded(Player)
        RareWeaponShopUI.PlayerAdded(Player)
        EpicWeaponShopUI.PlayerAdded(Player)
    PlayerRemoved<public>(Player:player):void=
        MoneyResourceUI.PlayerRemoved(Player)
        HousesHitBoxUpgradesUI.PlayerRemoved(Player)
        FarmHitBoxUpgradesUI.PlayerRemoved(Player)
        MarketsHitBoxUpgradesUI.PlayerRemoved(Player)
        TrainingGroundsHitBoxUpgradesUI.PlayerRemoved(Player)
        TempleHitBoxUpgradesUI.PlayerRemoved(Player)
        QuarryHitBoxUpgradesUI.PlayerRemoved(Player)
        BarracksHitBoxUpgradesUI.PlayerRemoved(Player)
        WoodHitBoxUpgradesUI.PlayerRemoved(Player)
        TrackerUI.PlayerRemoved(Player)
        UnCommonWeaponShopUI.PlayerRemoved(Player)
        CommonWeaponShopUI.PlayerRemoved(Player)
        RareWeaponShopUI.PlayerRemoved(Player)
        EpicWeaponShopUI.PlayerRemoved(Player)
    # ----------------------------

    # ------ SHOW LOGIC------
    ShowResourceUI<public>(Player:player):void=
        MoneyResourceUI.ShowUI(Player)
    ShowAllResourceUIs<public>(SelectedPlayer:player):void=
        for(Player : GetPlayspace().GetPlayers()):
            ShowResourceUI(Player)
    ShowUnCommonWeaponShopUI<public>(Player:player, HitBoxManagerDevice:button_manager):void=
        UnCommonWeaponShopUI.ShowUI(Player, HitBoxManagerDevice)
    ShowCommonWeaponShopUI<public>(Player:player, HitBoxManagerDevice:button_manager):void=
        CommonWeaponShopUI.ShowUI(Player, HitBoxManagerDevice)
    ShowRareWeaponShopUI<public>(Player:player, HitBoxManagerDevice:button_manager):void=
        RareWeaponShopUI.ShowUI(Player, HitBoxManagerDevice)
    ShowEpicWeaponShopUI<public>(Player:player, HitBoxManagerDevice:button_manager):void=
        EpicWeaponShopUI.ShowUI(Player, HitBoxManagerDevice)
    ShowHousesHitBoxUpgradesUI<public>(Player:player, HitBoxManagerDevice:hitbox_manager):void=
        HousesHitBoxUpgradesUI.ShowUI(Player, HitBoxManagerDevice)
    ShowFarmHitBoxUpgradesUI<public>(Player:player, HitBoxManagerDevice:hitbox_manager):void=
        FarmHitBoxUpgradesUI.ShowUI(Player, HitBoxManagerDevice)
    ShowMarketsHitBoxUpgradesUI<public>(Player:player, HitBoxManagerDevice:hitbox_manager):void=
        MarketsHitBoxUpgradesUI.ShowUI(Player, HitBoxManagerDevice)
    ShowTrainingGroundsHitBoxUpgradesUI<public>(Player:player, HitBoxManagerDevice:hitbox_manager):void=
        TrainingGroundsHitBoxUpgradesUI.ShowUI(Player, HitBoxManagerDevice)
    ShowTempleHitBoxUpgradesUI<public>(Player:player, HitBoxManagerDevice:hitbox_manager):void=
        TempleHitBoxUpgradesUI.ShowUI(Player, HitBoxManagerDevice)
    ShowQuarryHitBoxUpgradesUI<public>(Player:player, HitBoxManagerDevice:hitbox_manager):void=
        QuarryHitBoxUpgradesUI.ShowUI(Player, HitBoxManagerDevice)
    ShowBarracksHitBoxUpgradesUI<public>(Player:player, HitBoxManagerDevice:hitbox_manager):void=
        BarracksHitBoxUpgradesUI.ShowUI(Player, HitBoxManagerDevice)
    ShowWoodHitBoxUpgradesUI<public>(Player:player, HitBoxManagerDevice:hitbox_manager):void=
        WoodHitBoxUpgradesUI.ShowUI(Player, HitBoxManagerDevice)
    ShowTrackerUI<public>(Player:player, TrackerDevice:tutorial, Tracker:tracker_device, Id:string):void=
        TrackerUI.ShowUI(Player, TrackerDevice, Tracker, Id)
    # ----------------------------
    
    # ------ UPDATE LOGIC------
    UpdatePlayersResourceUIs<public>(Player:player):void=
        MoneyResourceUI.UpdateUI(Player)
    UpdateUnCommonWeaponShopUI<public>(Player:player):void=
        UnCommonWeaponShopUI.UpdateUI(Player)
    UpdateCommonWeaponShopUI<public>(Player:player):void=
        CommonWeaponShopUI.UpdateUI(Player)
    UpdateRareWeaponShopUI<public>(Player:player):void=
        RareWeaponShopUI.UpdateUI(Player)
    UpdateEpicWeaponShopUI<public>(Player:player):void=
        EpicWeaponShopUI.UpdateUI(Player)
    UpdateHousesHitBoxUpgradesUI<public>(Player:player):void=
        HousesHitBoxUpgradesUI.UpdateUI(Player)
    UpdateFarmHitBoxUpgradesUI<public>(Player:player):void=
        FarmHitBoxUpgradesUI.UpdateUI(Player)
    UpdateMarketsHitBoxUpgradesUI<public>(Player:player):void=
        MarketsHitBoxUpgradesUI.UpdateUI(Player)
    UpdateTrainingGroundsHitBoxUpgradesUI<public>(Player:player):void=
        TrainingGroundsHitBoxUpgradesUI.UpdateUI(Player)
    UpdateTempleHitBoxUpgradesUI<public>(Player:player):void=
        TempleHitBoxUpgradesUI.UpdateUI(Player)
    UpdateQuarryHitBoxUpgradesUI<public>(Player:player):void=
        QuarryHitBoxUpgradesUI.UpdateUI(Player)
    UpdateBarracksHitBoxUpgradesUI<public>(Player:player):void=
        BarracksHitBoxUpgradesUI.UpdateUI(Player)
    UpdateWoodHitBoxUpgradesUI<public>(Player:player):void=
        WoodHitBoxUpgradesUI.UpdateUI(Player)
    UpdateTrackerUI<public>(Player:player, Tracker:tracker_device, Id:string):void=
        TrackerUI.UpdateUI(Player, Tracker, Id)
    # ----------------------------

    # ------ CLOSE LOGIC------
    CloseMoneyResourceUI<public>(Player:player):void=
        MoneyResourceUI.CloseUI(Player)
    CloseTrackerUI<public>(Player:player):void=
        TrackerUI.CloseUI(Player)
    # ----------------------------





