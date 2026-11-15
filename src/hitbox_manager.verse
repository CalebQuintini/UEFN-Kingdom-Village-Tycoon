using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { Persistence }
using { Config }
using { Utility }
using { UserInterface }

hittable_props<public>:= class:
    @editable
    CrateId:string=""
    @editable
    HitboxNumber:int=0
    @editable
    HittablePropManipulator:prop_manipulator_device=prop_manipulator_device{}
    @editable
    LevelTextDisplaysArray:[]creative_prop=array{}
    var HousesHitAmount:int=0
    var IsHitBoxAnimating : logic = false

    @editable
    DollarHitBoxCrate:creative_prop=creative_prop{}

    IncrementHousesHitAmount():void=
        set HousesHitAmount += 1
    ResetHousesHitAmount():void=
        set HousesHitAmount = 0

hitbox_manager := class(creative_device):

    var PopUpUI:player_money_popup_device_system=player_money_popup_device_system{}

    @editable
    HitboxHitAudio:audio_player_device=audio_player_device{}

    @editable
    UpgradeAudio:audio_player_device=audio_player_device{}

    var RootPlayer : ?player = false
    var UIManager<public>:ui_manager = ui_manager{}

    @editable
    HittablePropsArray:[]hittable_props=array{}

    var HitBoxAccolade<public>:accolades_device=accolades_device{}

    var IsHousesHitBoxBought:logic=false
    var IsFarmHitBoxBought:logic=false
    var IsMarketsHitBoxBought:logic=false
    var IsTrainingGroundsHitBoxBought:logic=false
    var IsTempleHitBoxBought:logic=false
    var IsQuarryHitBoxHitBoxBought:logic=false
    var IsBarracksHitBoxBought:logic=false
    var IsWoodHitBoxHitBoxBought:logic=false

    @editable
    ShowHousesHitBoxUpgradeUIButton:button_device=button_device{}
    @editable
    ShowFarmHitBoxUpgradeUIButton:button_device=button_device{}
    @editable
    ShowMarketsHitBoxUpgradeUIButton:button_device=button_device{}
    @editable
    ShowTrainingGroundsHitBoxUpgradeUIButton:button_device=button_device{}
    @editable
    ShowTempleHitBoxUpgradeUIButton:button_device=button_device{}
    @editable
    ShowQuarryHitBoxUpgradeUIButton:button_device=button_device{}
    @editable
    ShowBarracksHitBoxUpgradeUIButton:button_device=button_device{}
    @editable
    ShowWoodHitBoxUpgradeUIButton:button_device=button_device{}
    
    OnBegin<override>()<suspends>:void=
        ShowHousesHitBoxUpgradeUIButton.Disable()
        ShowHousesHitBoxUpgradeUIButton.InteractedWithEvent.Subscribe(ShowHousesHitBoxUpgradesMenu)

        ShowFarmHitBoxUpgradeUIButton.Disable()
        ShowFarmHitBoxUpgradeUIButton.InteractedWithEvent.Subscribe(ShowFarmHitBoxUpgradesMenu)

        ShowMarketsHitBoxUpgradeUIButton.Disable()
        ShowMarketsHitBoxUpgradeUIButton.InteractedWithEvent.Subscribe(ShowMarketsHitBoxUpgradesMenu)

        ShowTrainingGroundsHitBoxUpgradeUIButton.Disable()
        ShowTrainingGroundsHitBoxUpgradeUIButton.InteractedWithEvent.Subscribe(ShowTrainingGroundsHitBoxUpgradesMenu)

        ShowTempleHitBoxUpgradeUIButton.Disable()
        ShowTempleHitBoxUpgradeUIButton.InteractedWithEvent.Subscribe(ShowTempleHitBoxUpgradesMenu)

        ShowQuarryHitBoxUpgradeUIButton.Disable()
        ShowQuarryHitBoxUpgradeUIButton.InteractedWithEvent.Subscribe(ShowQuarryHitBoxUpgradesMenu)

        ShowBarracksHitBoxUpgradeUIButton.Disable()
        ShowBarracksHitBoxUpgradeUIButton.InteractedWithEvent.Subscribe(ShowBarracksHitBoxUpgradesMenu)

        ShowWoodHitBoxUpgradeUIButton.Disable()
        ShowWoodHitBoxUpgradeUIButton.InteractedWithEvent.Subscribe(ShowWoodHitBoxUpgradesMenu)

        for(Props:HittablePropsArray):
            for (Prop:Props.LevelTextDisplaysArray):
                Prop.Hide()
            Props.HittablePropManipulator.Disable()

        spawn. MonitorHitBoxes()

        for(Props:HittablePropsArray):
            Props.HittablePropManipulator.DamagedEvent.SubscribeAgent2(OnDamaged, Props)

    InitHousesHitBox():void=
        set IsHousesHitBoxBought = true
        ShowHousesHitBoxUpgradeUIButton.Enable()
    InitFarmHitBox():void=
        set IsFarmHitBoxBought = true
        ShowFarmHitBoxUpgradeUIButton.Enable()
    InitMarketsHitBox():void=
        set IsMarketsHitBoxBought = true
        ShowMarketsHitBoxUpgradeUIButton.Enable()
    InitTrainingGroundsHitBox():void=
        set IsTrainingGroundsHitBoxBought = true
        ShowTrainingGroundsHitBoxUpgradeUIButton.Enable()
    InitTempleHitBox():void=
        set IsTempleHitBoxBought = true
        ShowTempleHitBoxUpgradeUIButton.Enable()
    InitQuarryHitBox():void=
        set IsQuarryHitBoxHitBoxBought = true
        ShowQuarryHitBoxUpgradeUIButton.Enable()
    InitBarracksHitBox():void=
        set IsBarracksHitBoxBought = true
        ShowBarracksHitBoxUpgradeUIButton.Enable()
    InitWoodHitBox():void=
        set IsWoodHitBoxHitBoxBought = true
        ShowWoodHitBoxUpgradeUIButton.Enable()

    MonitorHitBoxes()<suspends>:void=
        loop:
            if:
                ActualPlayer := RootPlayer?
                HousesHitBoxLevel := GetHousesHitBoxLevel[ActualPlayer]
                FarmHitBoxLevel := GetFarmHitBoxLevel[ActualPlayer]
                MarketsHitBoxLevel := GetMarketsHitBoxLevel[ActualPlayer]
                TrainingGroundsHitBoxLevel := GetTrainingAreaHitBoxLevel[ActualPlayer]
                TempleHitBoxLevel := GetTempleHitBoxLevel[ActualPlayer]
                QuarryHitBoxLevel := GetQuarryHitBoxLevel[ActualPlayer]
                BarracksHitBoxLevel := GetBarracksHitBoxLevel[ActualPlayer]
                WoodHitBoxLevel := GetWoodHitBoxLevel[ActualPlayer]

            then:
                if(IsHousesHitBoxBought = true):
                    for(Props:HittablePropsArray, Props.HitboxNumber=1):
                        spawn. CheckDisplayText(Props, HousesHitBoxLevel)
                if(IsFarmHitBoxBought = true):
                    for(Props:HittablePropsArray, Props.HitboxNumber=2):
                        spawn. CheckDisplayText(Props, FarmHitBoxLevel)
                if(IsMarketsHitBoxBought = true):
                    for(Props:HittablePropsArray, Props.HitboxNumber=3):
                        spawn. CheckDisplayText(Props, MarketsHitBoxLevel)
                if(IsTrainingGroundsHitBoxBought = true):
                    for(Props:HittablePropsArray, Props.HitboxNumber=4):
                        spawn. CheckDisplayText(Props, TrainingGroundsHitBoxLevel)
                if(IsTempleHitBoxBought = true):
                    for(Props:HittablePropsArray, Props.HitboxNumber=5):
                        spawn. CheckDisplayText(Props, TempleHitBoxLevel)
                if(IsQuarryHitBoxHitBoxBought = true):
                    for(Props:HittablePropsArray, Props.HitboxNumber=6):
                        spawn. CheckDisplayText(Props, QuarryHitBoxLevel)
                if(IsBarracksHitBoxBought = true):
                    for(Props:HittablePropsArray, Props.HitboxNumber=7):
                        spawn. CheckDisplayText(Props, BarracksHitBoxLevel)
                if(IsWoodHitBoxHitBoxBought = true):
                    for(Props:HittablePropsArray, Props.HitboxNumber=8):
                        spawn. CheckDisplayText(Props, WoodHitBoxLevel)
            Sleep(1.0)

    OnDamaged(Agent:agent, Crate:hittable_props):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
            HousesHitAmount := GetPlayerHousesHitBoxHitAmount[ActualPlayer]
            FarmHitAmount := GetPlayerFarmHitBoxHitAmount[ActualPlayer]
            MarketsHitAmount := GetPlayerMarketsHitBoxHitAmount[ActualPlayer]
            TrainingGroundsHitAmount := GetPlayerTrainingGroundsHitBoxHitAmount[ActualPlayer]
            TempleHitAmount := GetTempleHitBoxHitAmount[ActualPlayer]
            QuarryHitAmount := GetQuarryHitBoxHitAmount[ActualPlayer]
            BarracksHitAmount := GetBarracksHitBoxHitAmount[ActualPlayer]
            WoodHitAmount := GetWoodHitBoxHitAmount[ActualPlayer]
            RebirthOnce := logic{HasPlayerRebirthedOnce[ActualPlayer]}
            RebirthTwice := logic{HasPlayerRebirthedTwice[ActualPlayer]}
            var RebirthBoost : float = 0.0
            if(RebirthOnce = true and RebirthTwice = false):
                set RebirthBoost = 0.20
            else if(RebirthOnce = true and RebirthTwice = true):
                set RebirthBoost = 0.40
            if(Crate.HitboxNumber = 1):
                GrantMoney[ActualPlayer, HousesHitAmount * (1.0 + RebirthBoost)]
            if(Crate.HitboxNumber = 2):
                GrantMoney[ActualPlayer, FarmHitAmount * (1.0 + RebirthBoost)]
            if(Crate.HitboxNumber = 3):
                GrantMoney[ActualPlayer, MarketsHitAmount * (1.0 + RebirthBoost)]
            if(Crate.HitboxNumber = 4):
                GrantMoney[ActualPlayer, TrainingGroundsHitAmount * (1.0 + RebirthBoost)]
            if(Crate.HitboxNumber = 5):
                GrantMoney[ActualPlayer, TempleHitAmount * (1.0 + RebirthBoost)]
            if(Crate.HitboxNumber = 6):
                GrantMoney[ActualPlayer, QuarryHitAmount * (1.0 + RebirthBoost)]
            if(Crate.HitboxNumber = 7):
                GrantMoney[ActualPlayer, BarracksHitAmount * (1.0 + RebirthBoost)]
            if(Crate.HitboxNumber = 8):
                GrantMoney[ActualPlayer, WoodHitAmount * (1.0 + RebirthBoost)]
        then:
            spawn. PlayAnimation(Crate)
            HitBoxAccolade.Award(PlayerAgent)
            HitboxHitAudio.Play(PlayerAgent)
            UIManager.UpdatePlayersResourceUIs(ActualPlayer)
            if(Crate.HitboxNumber = 1):
                PopUpUI.PopUpActivateProp(ActualPlayer, HousesHitAmount * (1.0 + RebirthBoost))
            if(Crate.HitboxNumber = 2):
                PopUpUI.PopUpActivateProp(ActualPlayer, FarmHitAmount * (1.0 + RebirthBoost))
            if(Crate.HitboxNumber = 3):
                PopUpUI.PopUpActivateProp(ActualPlayer, MarketsHitAmount * (1.0 + RebirthBoost))
            if(Crate.HitboxNumber = 4):
                PopUpUI.PopUpActivateProp(ActualPlayer, TrainingGroundsHitAmount * (1.0 + RebirthBoost))
            if(Crate.HitboxNumber = 5):
                PopUpUI.PopUpActivateProp(ActualPlayer, TempleHitAmount * (1.0 + RebirthBoost))
            if(Crate.HitboxNumber = 6):
                PopUpUI.PopUpActivateProp(ActualPlayer, QuarryHitAmount * (1.0 + RebirthBoost))
            if(Crate.HitboxNumber = 7):
                PopUpUI.PopUpActivateProp(ActualPlayer, BarracksHitAmount * (1.0 + RebirthBoost))
            if(Crate.HitboxNumber = 8):
                PopUpUI.PopUpActivateProp(ActualPlayer, WoodHitAmount * (1.0 + RebirthBoost))
            Crate.IncrementHousesHitAmount()

    PlayAnimation(Crate:hittable_props)<suspends> : void=
        if(not Crate.IsHitBoxAnimating?):
            set Crate.IsHitBoxAnimating = true
            CratePos := Crate.DollarHitBoxCrate.GetTransform().Translation
            CrateRot := Crate.DollarHitBoxCrate.GetTransform().Rotation
            CrateScale := Crate.DollarHitBoxCrate.GetTransform().Scale
            # Smaller Scale
            ScaleOffset := vector3{X := 0.2, Y := 0.2, Z := 0.2}
            NewScale := CrateScale - ScaleOffset
            Crate.DollarHitBoxCrate.MoveTo(transform{Translation := CratePos, Rotation := CrateRot, Scale := NewScale}, 0.1)
            Crate.DollarHitBoxCrate.MoveTo(transform{Translation := CratePos, Rotation := CrateRot, Scale := CrateScale}, 0.1)
            set Crate.IsHitBoxAnimating = false

    UpgradeHousesHitBox(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := GetPlayerHousesHitBoxPriceAmounts[Player]
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
            IncrementHousesHitBoxLevelLevel[ActualPlayer]
        then:
            UpgradeAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            UIManager.UpdateHousesHitBoxUpgradesUI(Player)
    UpgradeFarmHitBox(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := GetPlayerFarmHitBoxPriceAmounts[Player]
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
            IncrementFarmHitBoxLevel[ActualPlayer]
        then:
            UpgradeAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            UIManager.UpdateFarmHitBoxUpgradesUI(Player)
    UpgradeMarketsHitBox(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := GetPlayerMarketsHitBoxPriceAmounts[Player]
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
            IncrementMarketsHitBoxLevel[ActualPlayer]
        then:
            UpgradeAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            UIManager.UpdateMarketsHitBoxUpgradesUI(Player)
    UpgradeTrainingGroundsHitBox(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := GetPlayerTrainingGroundsHitBoxPriceAmounts[Player]
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
            IncrementTrainingAreaHitBoxLevel[ActualPlayer]
        then:
            UpgradeAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            UIManager.UpdateTrainingGroundsHitBoxUpgradesUI(Player)
    UpgradeTempleHitBox(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := GetTempleHitBoxPriceAmounts[Player]
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
            IncrementTempleHitBoxLevel[ActualPlayer]
        then:
            UpgradeAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            UIManager.UpdateTempleHitBoxUpgradesUI(Player)
    UpgradeQuarryHitBox(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := GetQuarryHitBoxPriceAmounts[Player]
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
            IncrementQuarryHitBoxLevel[ActualPlayer]
        then:
            UpgradeAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            UIManager.UpdateQuarryHitBoxUpgradesUI(Player)
    UpgradeBarracksHitBox(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := GetBarracksHitBoxPriceAmounts[Player]
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
            IncrementBarracksHitBoxLevel[ActualPlayer]
        then:
            UpgradeAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            UIManager.UpdateBarracksHitBoxUpgradesUI(Player)
    UpgradeWoodHitBox(Player:player):void=
        if:
            ActualPlayer := RootPlayer?
            ActualPlayer = Player
            Price := GetWoodHitBoxPriceAmounts[Player]
            PlayersGold := GetMoney[Player]
            PlayersGold >= Price
            SpendMoney[Player, Price]
            IncrementWoodHitBoxLevel[ActualPlayer]
        then:
            UpgradeAudio.Play(Player)
            UIManager.UpdatePlayersResourceUIs(Player)
            UIManager.UpdateWoodHitBoxUpgradesUI(Player)

    ShowHousesHitBoxUpgradesMenu(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowHousesHitBoxUpgradesUI(ActualPlayer, Self)
    ShowFarmHitBoxUpgradesMenu(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowFarmHitBoxUpgradesUI(ActualPlayer, Self)
    ShowMarketsHitBoxUpgradesMenu(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowMarketsHitBoxUpgradesUI(ActualPlayer, Self)
    ShowTrainingGroundsHitBoxUpgradesMenu(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowTrainingGroundsHitBoxUpgradesUI(ActualPlayer, Self)
    ShowTempleHitBoxUpgradesMenu(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowTempleHitBoxUpgradesUI(ActualPlayer, Self)
    ShowQuarryHitBoxUpgradesMenu(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowQuarryHitBoxUpgradesUI(ActualPlayer, Self)
    ShowBarracksHitBoxUpgradesMenu(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowBarracksHitBoxUpgradesUI(ActualPlayer, Self)
    ShowWoodHitBoxUpgradesMenu(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
        then:
            UIManager.ShowWoodHitBoxUpgradesUI(ActualPlayer, Self)

    PlayerLeaves(Agent:agent):void=
        if (ActualPlayer:=RootPlayer?, PlayerAgent:=agent[ActualPlayer], PlayerAgent=Agent):
            if(PopUpUI.PlayerRemoved[ActualPlayer]){}
            set RootPlayer = false
            set IsHousesHitBoxBought = false
            set  IsFarmHitBoxBought = false
            set IsMarketsHitBoxBought = false
            set  IsTrainingGroundsHitBoxBought = false
            set IsTempleHitBoxBought = false
            set  IsQuarryHitBoxHitBoxBought = false
            set IsBarracksHitBoxBought = false
            set  IsWoodHitBoxHitBoxBought = false
            ShowHousesHitBoxUpgradeUIButton.Disable()
            ShowFarmHitBoxUpgradeUIButton.Disable()
            ShowMarketsHitBoxUpgradeUIButton.Disable()
            ShowTrainingGroundsHitBoxUpgradeUIButton.Disable()
            ShowTempleHitBoxUpgradeUIButton.Disable()
            ShowQuarryHitBoxUpgradeUIButton.Disable()
            ShowBarracksHitBoxUpgradeUIButton.Disable()
            ShowWoodHitBoxUpgradeUIButton.Disable()
            for(Props:HittablePropsArray):
                for (Prop:Props.LevelTextDisplaysArray):
                    Prop.Hide()
                Props.HittablePropManipulator.Disable()

    CheckDisplayText(Props:hittable_props, HousesHitBoxLevel:int)<suspends>:void=
        Props.HittablePropManipulator.Enable()
        if(HousesHitBoxLevel = 0):
            if (DisplayText0 := Props.LevelTextDisplaysArray[0], DisplayText1 := Props.LevelTextDisplaysArray[1], DisplayText2 := Props.LevelTextDisplaysArray[2], DisplayText3 := Props.LevelTextDisplaysArray[3]):
                DisplayText0.Show()
                DisplayText1.Hide()
                DisplayText2.Hide()
                DisplayText3.Hide()
        else if(HousesHitBoxLevel = 1):
            if (DisplayText0 := Props.LevelTextDisplaysArray[1], DisplayText1 := Props.LevelTextDisplaysArray[0], DisplayText2 := Props.LevelTextDisplaysArray[2], DisplayText3 := Props.LevelTextDisplaysArray[3]):
                DisplayText0.Show()
                DisplayText1.Hide()
                DisplayText2.Hide()
                DisplayText3.Hide()
        else if(HousesHitBoxLevel = 2):
            if (DisplayText0 := Props.LevelTextDisplaysArray[2], DisplayText1 := Props.LevelTextDisplaysArray[1], DisplayText2 := Props.LevelTextDisplaysArray[0], DisplayText3 := Props.LevelTextDisplaysArray[3]):
                DisplayText0.Show()
                DisplayText1.Hide()
                DisplayText2.Hide()
                DisplayText3.Hide()
        else if(HousesHitBoxLevel = 3):
            if (DisplayText0 := Props.LevelTextDisplaysArray[3], DisplayText1 := Props.LevelTextDisplaysArray[1], DisplayText2 := Props.LevelTextDisplaysArray[0], DisplayText3 := Props.LevelTextDisplaysArray[2]):
                DisplayText0.Show()
                DisplayText1.Hide()
                DisplayText2.Hide()
                DisplayText3.Hide()



