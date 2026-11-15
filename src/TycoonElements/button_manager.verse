using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/Characters }
using { Persistence }
using { Utility }
using { Config }
using { UserInterface }

buyable_props<public>:= class:
    @editable
    PropId:string=""
    @editable
    BeaconDevice:beacon_device=beacon_device{}
    @editable
    PropTrigger:trigger_device = trigger_device{}
    @editable
    PropBuyButton:creative_prop=creative_prop{}
    @editable
    PropText:creative_prop=creative_prop{}
    @editable
    BuyableProp:[]creative_prop=array{}
    @editable
    PropDisplayIndex:int=0
    @editable
    var IsBought:logic=false
    
button_manager<public>:= class(creative_device):

    var RootPlayer : ?player = false

    var UIManager<public>:ui_manager = ui_manager{}

    var PurchaseSuccessfulHudMessage<public>:hud_message_device=hud_message_device{}
    var PurchaseFailedHudMessage<public>:hud_message_device=hud_message_device{}

    @editable
    RebirthButton:button_device=button_device{}

    @editable
    LeaveTycoonButton:button_device=button_device{}

    @editable
    HitBoxManager<public>:hitbox_manager=hitbox_manager{}

    @editable
    PurchasableProps:[]buyable_props=array{}

    RevealDuration : float = 1.0
    HiddenOffset : float = -2500.0
    
    var MoneyCollected:float=0.0
    @editable
    MoneyCollectedBillboard:[]billboard_device=array{}
    @editable
    MoneyCollectedTrigger:[]trigger_device=array{}
    var MoneyCollectedAudio<public>:audio_player_device=audio_player_device{}

    var ItemPurchaseAccolade<public>:accolades_device=accolades_device{}
    var MoneyCollectedAccolade<public>:accolades_device=accolades_device{}
    var RebirthedAccolade<public>:accolades_device=accolades_device{}

    var BarrierState:logic=false

    @editable
    PlotBarrier:barrier_device=barrier_device{}

    @editable
    BarrierButtonSwitch:button_device=button_device{}

    @editable
    ParkourMutatorZone:mutator_zone_device=mutator_zone_device{}

    @editable
    ParkourTeleporter:teleporter_device=teleporter_device{}

    # Weapon Shop Buttons
    # Uncommon
    @editable
    UncommonWeaponShop:button_device=button_device{}
    # Common
    @editable
    CommonWeaponShop:button_device=button_device{}
    # Rare
    @editable
    RareWeaponShop:button_device=button_device{}
    # Epic
    @editable
    EpicWeaponShop:button_device=button_device{}
    # Item Granters
    # Uncommon
    var MonarchPistol_ItemGranter<public>:item_granter_device=item_granter_device{}
    var LeverActionShotgun_ItemGranter<public>:item_granter_device=item_granter_device{}
    var BoltActionSniperRifle_ItemGranter<public>:item_granter_device=item_granter_device{}
    # Common
    var CombatPistol_ItemGranter<public>:item_granter_device=item_granter_device{}
    var SovereignShotgun_ItemGranter<public>:item_granter_device=item_granter_device{}
    var RedEyeAssaultRifle_ItemGranter<public>:item_granter_device=item_granter_device{}
    # Rare
    var BigShield_ItemGranter<public>:item_granter_device=item_granter_device{}
    var PumpShotgun_ItemGranter<public>:item_granter_device=item_granter_device{}
    var AssaultRifle_ItemGranter<public>:item_granter_device=item_granter_device{}
    # Epic
    var StingerSMG_ItemGranter<public>:item_granter_device=item_granter_device{}
    var SentinelPumpShotgun_ItemGranter<public>:item_granter_device=item_granter_device{}
    var OXRRifle_ItemGranter<public>:item_granter_device=item_granter_device{}

    var PopUpUI<public>:player_money_popup_device_system=player_money_popup_device_system{}

    # Events
    HitBoxEvent<public> : event() = event(){}
    MoneyCollectorEvent<public> : event() = event(){}
    WatchTower1Event<public> : event() = event(){}
    WatchTower2Event<public> : event() = event(){}
    WatchTower3Event<public> : event() = event(){}
    WatchTower4Event<public>: event() = event(){}
    ArmoryStand1Event<public> : event() = event(){}

    OnBegin<override>()<suspends>:void=
        UncommonWeaponShop.Disable()
        CommonWeaponShop.Disable()
        RareWeaponShop.Disable()
        EpicWeaponShop.Disable()
        # Disable Everything
        RebirthButton.Disable()
        # LeaveTycoonButton.InteractedWithEvent.Subscribe(PlayerLeaves)
        UncommonWeaponShop.InteractedWithEvent.Subscribe(ShowUnCommonWeaponShopUI)
        CommonWeaponShop.InteractedWithEvent.Subscribe(ShowCommonWeaponShopUI)
        RareWeaponShop.InteractedWithEvent.Subscribe(ShowRareWeaponShopUI)
        EpicWeaponShop.InteractedWithEvent.Subscribe(ShowEpicWeaponShopUI)
        BarrierButtonSwitch.InteractedWithEvent.Subscribe(BarrierOn)
        for(MoneyCollectedTriggers:MoneyCollectedTrigger):
            MoneyCollectedTriggers.TriggeredEvent.Subscribe(OnMoneyCollected)
        ParkourMutatorZone.AgentEntersEvent.Subscribe(PlayerEntersParkour)
        for(MoneyCollectedTriggers:MoneyCollectedTrigger):
            MoneyCollectedTriggers.Disable()
        for(MoneyCollectedBillboards:MoneyCollectedBillboard):
            MoneyCollectedBillboards.HideText()
        PlotBarrier.Disable()
        BarrierButtonSwitch.Disable()
        ParkourMutatorZone.Disable()
        for (BuyableProps : PurchasableProps):
            BuyableProps.PropTrigger.TriggeredEvent.SubscribeAgent(OnPropPurchased, BuyableProps)
            BuyableProps.PropTrigger.Disable()
            BuyableProps.PropText.Hide()
            BuyableProps.PropBuyButton.Hide()
            BuyableProps.BeaconDevice.Disable()
            for (Prop:BuyableProps.BuyableProp):
                StartTransform := Prop.GetTransform()
                # Create new transform with lowered position
                HiddenTransform := transform{
                    Translation := StartTransform.Translation + vector3{X := 0.0, Y := 0.0, Z := HiddenOffset},
                    Rotation := StartTransform.Rotation,
                    Scale := StartTransform.Scale
                }
                # Use TeleportTo for instant movement
                if (Prop.TeleportTo[HiddenTransform]):

    MonitorPropButtonAvailability()<suspends>:void=
        loop:
            if (RootPlayer = false):
                break
            var TestProps : []buyable_props = array{}
            var ArrayCount : float = 0.0
            var TrueCount : float = 0.0

            if (ActualPlayer:=RootPlayer?, PlayerAgent:=agent[ActualPlayer], TheCurresada := GetPlayersCurrentPropIndex[ActualPlayer]):
                for (BuyableProps : PurchasableProps):
                    if (BuyableProps.PropDisplayIndex < TheCurresada):
                        if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, BuyableProps.PropId]}, IsPropBought = false):
                            BuyableProps.PropBuyButton.Show()
                            BuyableProps.PropText.Show()
                            BuyableProps.PropTrigger.Enable()
                            BuyableProps.BeaconDevice.Enable()
                            BuyableProps.BeaconDevice.AddToShowList(PlayerAgent)
                        else:
                            BuyableProps.PropBuyButton.Hide()
                            BuyableProps.PropText.Hide()
                            BuyableProps.PropTrigger.Disable()
                            BuyableProps.BeaconDevice.Disable()
                            BuyableProps.BeaconDevice.RemoveFromShowList(PlayerAgent)

                # 1️⃣ Collect props belonging to the current prop index
                for (BuyableProps : PurchasableProps):
                    if (BuyableProps.PropDisplayIndex = TheCurresada):
                        set TestProps += array{BuyableProps}
                        if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, BuyableProps.PropId]}, IsPropBought = false):
                            BuyableProps.PropBuyButton.Show()
                            BuyableProps.PropText.Show()
                            BuyableProps.PropTrigger.Enable()
                            BuyableProps.BeaconDevice.Enable()
                            BuyableProps.BeaconDevice.AddToShowList(PlayerAgent)
                        else:
                            BuyableProps.PropBuyButton.Hide()
                            BuyableProps.PropText.Hide()
                            BuyableProps.PropTrigger.Disable()
                            BuyableProps.BeaconDevice.Disable()
                            BuyableProps.BeaconDevice.RemoveFromShowList(PlayerAgent)

                # 2️⃣ Count how many are bought
                Random1 := TestProps.Length
                set ArrayCount = Random1 * 1.0
                for (Prop : TestProps):
                    if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, Prop.PropId]}, IsPropBought = true):
                        set TrueCount += 1.0

                # 3️⃣ Check completion ratio
                if (ArrayCount > 0.0):
                    CompletionRatio := TrueCount / ArrayCount

                    # 4️⃣ If at least 50% are bought AND not already completed
                    if (CompletionRatio >= 0.50):
                        # Progress to next index
                        if(IncrementPlayersCurrentPropIndex[ActualPlayer]){}
                        # Reset after moving to next stage
                        set TestProps = array{}
                        set ArrayCount = 0.0
                        set TrueCount = 0.0
            Sleep(0.4)

    BarrierOn(Agent:agent):void=
        if (ActualPlayer:=RootPlayer?, PlayerAgent:=agent[ActualPlayer], PlayerAgent=Agent):
            if(BarrierState = false):
                PlotBarrier.Enable()
                set BarrierState = true
            else if(BarrierState = true):
                PlotBarrier.Disable()
                set BarrierState = false

    PlayerEntersParkour(Agent:agent):void=
        if (ActualPlayer:=RootPlayer?, PlayerAgent:=agent[ActualPlayer], PlayerAgent=Agent):
            ParkourTeleporter.Teleport(PlayerAgent)
        
    PlayerLeaves(Agent:agent):void=
        HitBoxManager.PlayerLeaves(Agent)
        if (ActualPlayer:=RootPlayer?, PlayerAgent:=agent[ActualPlayer], PlayerAgent=Agent):
            for (BuyableProps : PurchasableProps):
                BuyableProps.PropTrigger.Disable()
                BuyableProps.PropText.Hide()
                BuyableProps.PropBuyButton.Hide()
                BuyableProps.BeaconDevice.Disable()
                if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, BuyableProps.PropId]}, IsPropBought = true):
                    for (Prop:BuyableProps.BuyableProp):
                        StartTransform := Prop.GetTransform()
                        HiddenTransform := transform{
                            Translation := StartTransform.Translation + vector3{X := 0.0, Y := 0.0, Z := HiddenOffset},
                            Rotation := StartTransform.Rotation,
                            Scale := StartTransform.Scale
                        }
                        if (Prop.TeleportTo[HiddenTransform]){}
            UncommonWeaponShop.Disable()
            CommonWeaponShop.Disable()
            RareWeaponShop.Disable()
            EpicWeaponShop.Disable()
            PlotBarrier.Disable()
            PlotBarrier.RemoveFromIgnoreList(PlayerAgent)
            BarrierButtonSwitch.Disable()
            ParkourMutatorZone.Disable()
            UIManager.CloseMoneyResourceUI(ActualPlayer)
            for(MoneyCollectedTriggers:MoneyCollectedTrigger):
                MoneyCollectedTriggers.Disable()
            for(MoneyCollectedBillboards:MoneyCollectedBillboard):
                MoneyCollectedBillboards.HideText()
            RebirthButton.Disable()
            set MoneyCollected = 0.0
            set RootPlayer = false

    OnPropPurchased(Agent : ?agent, BuyableProp:buyable_props) : void =
        for (PropPriceInfo : GetPropPriceArray(), PropPriceInfo.PropId = BuyableProp.PropId):
            if:
                ActualAgent := Agent? 
                Player := player[ActualAgent] 
                ActualPlayer:=RootPlayer?
                Player = ActualPlayer
                Price := PropPriceInfo.Price
                PlayersGold := GetMoney[Player]
                PlayersGold >= Price
                SpendMoney[Player, Price]
                IncrementMoneyCollectorLevel[ActualPlayer]
            then:
                ItemPurchaseAccolade.Award(ActualAgent)
                CheckIfHitBox(BuyableProp)
                if(SetPropInfoBoughtTrue[Player, BuyableProp.PropId]){}
                if (SetTutorialInfoBoughtTrue[Player, BuyableProp.PropId]){}
                SignalTutorialCompleted(BuyableProp.PropId)
                UIManager.UpdatePlayersResourceUIs(Player)
                PurchaseSuccessfulHudMessage.Show(ActualAgent)
                BuyableProp.PropBuyButton.Hide()
                BuyableProp.PropBuyButton.Hide()
                BuyableProp.PropText.Hide()
                spawn. RevealPlot(BuyableProp.BuyableProp)
                BuyableProp.PropTrigger.Disable()
            else:
                if(ActualAgent := Agent?):
                    PurchaseFailedHudMessage.Show(ActualAgent)
      
    RevealPlot(Props:[]creative_prop)<suspends> : void =
        # Animate each prop up to its original position
        for (Prop : Props):
            StartTransform := Prop.GetTransform()
            EndTransform := transform{
                Translation := StartTransform.Translation + vector3{X := 0.0, Y := 0.0, Z := -HiddenOffset},
                Rotation := StartTransform.Rotation,
                Scale := StartTransform.Scale
            }
            # Use MoveTo for smooth animation
            spawn{Prop.MoveTo(EndTransform, RevealDuration)}
  
    CheckPlayersPlot():void=
        if(ActualPlayer := RootPlayer?): 
            for(Props:PurchasableProps):
                if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, Props.PropId]}, IsPropBought = true):
                    spawn. RevealPlot(Props.BuyableProp)
                    CheckIfHitBox(Props)

    CheckIfHitBox(BuyableProp:buyable_props):void=
        if(BuyableProp.PropId = "PlotShield"):
            EnablePlotShield() 
        if(BuyableProp.PropId = "Rebirth"):
            EnableRebirth()
        if(BuyableProp.PropId = "MoneyCollector"):
           spawn. MoneyCollection()
        if(BuyableProp.PropId = "HousesHitBox"):
            HitBoxManager.InitHousesHitBox()
        if(BuyableProp.PropId = "FarmHitBox"):
            HitBoxManager.InitFarmHitBox()
        if(BuyableProp.PropId = "MarketHitBox"):
            HitBoxManager.InitMarketsHitBox()
        if(BuyableProp.PropId = "TrainingHitBox"):
            HitBoxManager.InitTrainingGroundsHitBox()
        if(BuyableProp.PropId = "TempleHitBox"):
            HitBoxManager.InitTempleHitBox()
        if(BuyableProp.PropId = "QuarryHitBox"):
            HitBoxManager.InitQuarryHitBox()
        if(BuyableProp.PropId = "BarracksHitBox"):
            HitBoxManager.InitBarracksHitBox()
        if(BuyableProp.PropId = "WoodHitBox"):
            HitBoxManager.InitWoodHitBox()
        if(BuyableProp.PropId = "ArmoryStand1"):
            UncommonWeaponShop.Enable()
        if(BuyableProp.PropId = "ArmoryStand2"):
            CommonWeaponShop.Enable()
        if(BuyableProp.PropId = "ArmoryStand3"):
            RareWeaponShop.Enable()
        if(BuyableProp.PropId = "ArmoryStand4"):
            EpicWeaponShop.Enable()

    EnablePlotShield():void=
        BarrierButtonSwitch.Enable()

    EnableRebirth():void=
        RebirthButton.Enable()
    
    OnMoneyCollected(Agent : ?agent):void=
        if:
            ActualAgent := Agent? 
            Player := player[ActualAgent] 
            ActualPlayer:=RootPlayer?
            Player = ActualPlayer
            GrantMoney[Player, MoneyCollected]
        then:
            MoneyCollectedAccolade.Award(ActualAgent)
            MoneyCollectedAudio.Play(Player)
            set MoneyCollected = 0.0
            UIManager.UpdatePlayersResourceUIs(Player)
            for(MoneyCollectedBillboards:MoneyCollectedBillboard):
                MoneyCollectedBillboards.SetText(StringToMessage(AbbreviateNumber(MoneyCollected)))

    MoneyCollection()<suspends>:void=
        loop:
            if (RootPlayer = false):
                break
            if:
                ActualPlayer:=RootPlayer?
                PlayerMoneyCollectionAmount := GetMoneyCollectorAmounts[ActualPlayer]
                RebirthOnce := logic{HasPlayerRebirthedOnce[ActualPlayer]}
                RebirthTwice := logic{HasPlayerRebirthedTwice[ActualPlayer]}
                var RebirthBoost : float = 0.0
            then:
                if(RebirthOnce = true and RebirthTwice = false):
                    set RebirthBoost = 0.20
                else if(RebirthOnce = true and RebirthTwice = true):
                    set RebirthBoost = 0.40

                set MoneyCollected += PlayerMoneyCollectionAmount * (1.0 + RebirthBoost)
                if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, "MoneyCollector"]}, IsPropBought = true):
                    if (MoneyCollectedBillboard0 := MoneyCollectedBillboard[0], MoneyCollectedTrigger0 := MoneyCollectedTrigger[0]):
                        MoneyCollectedBillboard0.ShowText()
                        MoneyCollectedTrigger0.Enable()
                        MoneyCollectedBillboard0.SetText(StringToMessage(AbbreviateNumber(MoneyCollected)))
                if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, "MoneyCollector2"]}, IsPropBought = true):
                    if (MoneyCollectedBillboard0 := MoneyCollectedBillboard[1], MoneyCollectedTrigger0 := MoneyCollectedTrigger[1]):
                        MoneyCollectedBillboard0.ShowText()
                        MoneyCollectedTrigger0.Enable()
                        MoneyCollectedBillboard0.SetText(StringToMessage(AbbreviateNumber(MoneyCollected)))
                if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, "MoneyCollector3"]}, IsPropBought = true):
                    if (MoneyCollectedBillboard0 := MoneyCollectedBillboard[2], MoneyCollectedTrigger0 := MoneyCollectedTrigger[2]):
                        MoneyCollectedBillboard0.ShowText()
                        MoneyCollectedTrigger0.Enable()
                        MoneyCollectedBillboard0.SetText(StringToMessage(AbbreviateNumber(MoneyCollected)))
                if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, "MoneyCollector4"]}, IsPropBought = true):
                    if (MoneyCollectedBillboard0 := MoneyCollectedBillboard[3], MoneyCollectedTrigger0 := MoneyCollectedTrigger[3]):
                        MoneyCollectedBillboard0.ShowText()
                        MoneyCollectedTrigger0.Enable()
                        MoneyCollectedBillboard0.SetText(StringToMessage(AbbreviateNumber(MoneyCollected)))
                if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, "MoneyCollector5"]}, IsPropBought = true):
                    if (MoneyCollectedBillboard0 := MoneyCollectedBillboard[4], MoneyCollectedTrigger0 := MoneyCollectedTrigger[4]):
                        MoneyCollectedBillboard0.ShowText()
                        MoneyCollectedTrigger0.Enable()
                        MoneyCollectedBillboard0.SetText(StringToMessage(AbbreviateNumber(MoneyCollected)))
                if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, "MoneyCollector6"]}, IsPropBought = true):
                    if (MoneyCollectedBillboard0 := MoneyCollectedBillboard[5], MoneyCollectedTrigger0 := MoneyCollectedTrigger[5]):
                        MoneyCollectedBillboard0.ShowText()
                        MoneyCollectedTrigger0.Enable()
                        MoneyCollectedBillboard0.SetText(StringToMessage(AbbreviateNumber(MoneyCollected)))
                if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, "MoneyCollector7"]}, IsPropBought = true):
                    if (MoneyCollectedBillboard0 := MoneyCollectedBillboard[6], MoneyCollectedTrigger0 := MoneyCollectedTrigger[6]):
                        MoneyCollectedBillboard0.ShowText()
                        MoneyCollectedTrigger0.Enable()
                        MoneyCollectedBillboard0.SetText(StringToMessage(AbbreviateNumber(MoneyCollected)))
                if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, "MoneyCollector8"]}, IsPropBought = true):
                    if (MoneyCollectedBillboard0 := MoneyCollectedBillboard[7], MoneyCollectedTrigger0 := MoneyCollectedTrigger[7]):
                        MoneyCollectedBillboard0.ShowText()
                        MoneyCollectedTrigger0.Enable()
                        MoneyCollectedBillboard0.SetText(StringToMessage(AbbreviateNumber(MoneyCollected)))
            Sleep(1.4)

    SignalTutorialCompleted(StepId:string):void=
        if(StepId = "HousesHitBox"):
            HitBoxEvent.Signal()
        if(StepId = "MoneyCollector"):
            MoneyCollectorEvent.Signal()
        if(StepId = "WatchTower1"):
            WatchTower1Event.Signal()
        if(StepId = "WatchTower2"):
            WatchTower2Event.Signal()
        if(StepId = "WatchTower3"):
            WatchTower3Event.Signal()
        if(StepId = "WatchTower4"):
            WatchTower4Event.Signal()
        if(StepId = "ArmoryStand1"):
            ArmoryStand1Event.Signal()

    RebirthPlayerFunction(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?

            PlayerAgent:=agent[ActualPlayer]

            PlayerAgent=Agent

            PlayersRebirthLevel := GetPlayerRebirthLevel[ActualPlayer]
            if(PlayersRebirthLevel = 0):
                if (not HasPlayerRebirthedOnce[ActualPlayer]):
                    RebirthPlayer[ActualPlayer]
                    RebirthPlayerOnce[ActualPlayer]
                    IncrementPlayerRebirthLevel[ActualPlayer]
            else if (PlayersRebirthLevel = 1):
                if (not HasPlayerRebirthedTwice[ActualPlayer]):
                    RebirthPlayer[ActualPlayer]
                    RebirthPlayerTwice[ActualPlayer]
                    IncrementPlayerRebirthLevel[ActualPlayer]
            else:
                RebirthPlayer[ActualPlayer]
                IncrementPlayerRebirthLevel[ActualPlayer]
            Character := ActualPlayer.GetFortCharacter[]
        then:
            UncommonWeaponShop.Disable()
            CommonWeaponShop.Disable()
            RareWeaponShop.Disable()
            EpicWeaponShop.Disable()
            PlotBarrier.Disable()
            PlotBarrier.RemoveFromIgnoreList(PlayerAgent)
            BarrierButtonSwitch.Disable()
            ParkourMutatorZone.Disable()
            RebirthedAccolade.Award(PlayerAgent)
            Character.Damage(100.0)
            UIManager.CloseMoneyResourceUI(ActualPlayer)
            set RootPlayer = false
            for(MoneyCollectedTriggers:MoneyCollectedTrigger):
                MoneyCollectedTriggers.Disable()
            for(MoneyCollectedBillboards:MoneyCollectedBillboard):
                MoneyCollectedBillboards.HideText()
            RebirthButton.Disable()
            set MoneyCollected = 0.0
            
    TestLeave(Agent:agent):void=
        HitBoxManager.PlayerLeaves(Agent)
        if (ActualPlayer:=RootPlayer?, PlayerAgent:=agent[ActualPlayer], PlayerAgent=Agent):
            for (BuyableProps : PurchasableProps):
                BuyableProps.PropTrigger.Disable()
                BuyableProps.PropText.Hide()
                BuyableProps.PropBuyButton.Hide()
                BuyableProps.BeaconDevice.Disable()
                if(IsPropBought := logic{CheckIfPropIsBought[ActualPlayer, BuyableProps.PropId]}, IsPropBought = true):
                    for (Prop:BuyableProps.BuyableProp):
                        StartTransform := Prop.GetTransform()
                        HiddenTransform := transform{
                            Translation := StartTransform.Translation + vector3{X := 0.0, Y := 0.0, Z := HiddenOffset},
                            Rotation := StartTransform.Rotation,
                            Scale := StartTransform.Scale
                        }
                        if (Prop.TeleportTo[HiddenTransform]){}
                else:
        RebirthPlayerFunction(Agent)

    # UnCommon
    ShowUnCommonWeaponShopUI(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowUnCommonWeaponShopUI(ActualPlayer, Self)
    PurchaseMonarchPistol<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 500.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            MonarchPistol_ItemGranter.GrantItem(ActualPlayer)
    PurchaseLeverActionShotgun<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 500.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            LeverActionShotgun_ItemGranter.GrantItem(ActualPlayer)
    PurchaseBoltActionSniperRifle<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 500.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            BoltActionSniperRifle_ItemGranter.GrantItem(ActualPlayer)
    # Common
    ShowCommonWeaponShopUI(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowCommonWeaponShopUI(ActualPlayer, Self)
    PurchaseCombatPistol<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 18000.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            CombatPistol_ItemGranter.GrantItem(ActualPlayer)
    PurchaseSovereignShotgun<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 18000.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            SovereignShotgun_ItemGranter.GrantItem(ActualPlayer)
    PurchaseRedEyeAssaultRifle<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 18000.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            RedEyeAssaultRifle_ItemGranter.GrantItem(ActualPlayer)
    # Rare
    ShowRareWeaponShopUI(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowRareWeaponShopUI(ActualPlayer, Self)
    PurchaseBigShield<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 250000.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            BigShield_ItemGranter.GrantItem(ActualPlayer)
    PurchasePumpShotgun<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 250000.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            PumpShotgun_ItemGranter.GrantItem(ActualPlayer)
    PurchaseAssaultRifle<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 250000.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            AssaultRifle_ItemGranter.GrantItem(ActualPlayer)
    # Epic
    ShowEpicWeaponShopUI(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowEpicWeaponShopUI(ActualPlayer, Self)
    PurchaseStingerSMG<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 3800000.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            StingerSMG_ItemGranter.GrantItem(ActualPlayer)
    PurchaseSentinelPumpShotgun<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 3800000.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            SentinelPumpShotgun_ItemGranter.GrantItem(ActualPlayer)
    PurchaseOXRRifle<public>(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := 3800000.0
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
        then:
            MoneyCollectedAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            OXRRifle_ItemGranter.GrantItem(ActualPlayer)



