using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/Characters }
using { TycoonElements }
using { Persistence }
using { UserInterface }

game_manager<public>:= class(creative_device):

    var PlayerStatsMap: [player]?playerstats = map{}

    # @editable
    # SimulatePlayerLeaving:button_device=button_device{}

    @editable
    Bases : []base_manager = array{}

    # HUD MESSSAGE DEVICES
    @editable
    ClaimPlotHudMessage:hud_message_device=hud_message_device{}
    @editable
    PurchaseSuccessfulHudMessage:hud_message_device=hud_message_device{}
    @editable
    PurchaseFailedHudMessage:hud_message_device=hud_message_device{}
    @editable
    MoneyCollectedAudio:audio_player_device=audio_player_device{}

    # Item Granters
    # UnCommon
    @editable
    MonarchPistol_ItemGranter:item_granter_device=item_granter_device{}
    @editable
    LeverActionShotgun_ItemGranter:item_granter_device=item_granter_device{}
    @editable
    BoltActionSniperRifle_ItemGranter:item_granter_device=item_granter_device{}
    # Common
    @editable
    CombatPistol_ItemGranter:item_granter_device=item_granter_device{}
    @editable
    SovereignShotgun_ItemGranter:item_granter_device=item_granter_device{}
    @editable
    RedEyeAssaultRifle_ItemGranter:item_granter_device=item_granter_device{}
    # Rare
    @editable
    BigShield_ItemGranter<public>:item_granter_device=item_granter_device{}
    @editable
    PumpShotgun_ItemGranter<public>:item_granter_device=item_granter_device{}
    @editable
    AssaultRifle_ItemGranter<public>:item_granter_device=item_granter_device{}
    # Epic
    @editable
    StingerSMG_ItemGranter<public>:item_granter_device=item_granter_device{}
    @editable
    SentinelPumpShotgun_ItemGranter<public>:item_granter_device=item_granter_device{}
    @editable
    OXRRifle_ItemGranter<public>:item_granter_device=item_granter_device{}

    # Accolade Devices
    @editable
    ClaimBaseAccolade:accolades_device=accolades_device{}
    @editable
    ItemPurchaseAccolade:accolades_device=accolades_device{}
    @editable
    MoneyCollectedAccolade:accolades_device=accolades_device{}
    @editable
    RebirthedAccolade:accolades_device=accolades_device{}
    @editable
    HitBoxAccolade:accolades_device=accolades_device{}

    PlayerExitsGameEvent : event() = event(){}

    @editable
    UIManager:ui_manager = ui_manager{}

    @editable
    LeavesCollectibles :[]collectible_object_device = array{}
    @editable
    LeavesAccolade : accolades_device = accolades_device{}

    @editable
    GoldCoins :[]collectible_object_device = array{}
    @editable
    GoldCoinAccolade : accolades_device = accolades_device{}

    @editable
    PopUpUI:player_money_popup_device_system=player_money_popup_device_system{}

    @editable
    BackgroundMusicAudioPlayer:audio_player_device = audio_player_device{}

    MusicStoppedEvent<public> : event() = event(){}

    OnBegin<override>()<suspends>:void=
        Playspace := GetPlayspace()
        Playspace.PlayerAddedEvent().Subscribe(OnPlayerAdded)
        for (Player : Playspace.GetPlayers()):
            OnPlayerAdded(Player)
        # SimulatePlayerLeaving.InteractedWithEvent.Subscribe(TEESTPLAYERLEAVING)
        spawn. AsyncManageTempStats()
        for(I -> Base:Bases):
            set Base.selfindex = I
            set Base.Owner = Self
            set Base.UIManager = UIManager
            set Base.ClaimHudMessage = ClaimPlotHudMessage
            set Base.BackgroundMusicAudioPlayer = BackgroundMusicAudioPlayer
            set Base.ButtonManager.PurchaseSuccessfulHudMessage = PurchaseSuccessfulHudMessage
            set Base.ButtonManager.PurchaseFailedHudMessage = PurchaseFailedHudMessage
            set Base.ButtonManager.UIManager = UIManager
            set Base.ButtonManager.HitBoxManager.UIManager = UIManager
            set Base.ButtonManager.MoneyCollectedAudio = MoneyCollectedAudio
            set Base.ClaimBaseAccolade = ClaimBaseAccolade
            set Base.ButtonManager.ItemPurchaseAccolade = ItemPurchaseAccolade
            set Base.ButtonManager.MoneyCollectedAccolade = MoneyCollectedAccolade
            set Base.ButtonManager.RebirthedAccolade = RebirthedAccolade
            set Base.ButtonManager.HitBoxManager.HitBoxAccolade = HitBoxAccolade
            set Base.ButtonManager.HitBoxManager.PopUpUI = PopUpUI
            set Base.ButtonManager.PopUpUI = PopUpUI
            set Base.ButtonManager.MonarchPistol_ItemGranter = MonarchPistol_ItemGranter
            set Base.ButtonManager.LeverActionShotgun_ItemGranter = LeverActionShotgun_ItemGranter
            set Base.ButtonManager.BoltActionSniperRifle_ItemGranter = BoltActionSniperRifle_ItemGranter
            set Base.ButtonManager.CombatPistol_ItemGranter = CombatPistol_ItemGranter
            set Base.ButtonManager.SovereignShotgun_ItemGranter = SovereignShotgun_ItemGranter
            set Base.ButtonManager.RedEyeAssaultRifle_ItemGranter = RedEyeAssaultRifle_ItemGranter
            set Base.ButtonManager.BigShield_ItemGranter = BigShield_ItemGranter
            set Base.ButtonManager.PumpShotgun_ItemGranter = PumpShotgun_ItemGranter
            set Base.ButtonManager.AssaultRifle_ItemGranter = AssaultRifle_ItemGranter
            set Base.ButtonManager.StingerSMG_ItemGranter = StingerSMG_ItemGranter
            set Base.ButtonManager.SentinelPumpShotgun_ItemGranter = SentinelPumpShotgun_ItemGranter
            set Base.ButtonManager.OXRRifle_ItemGranter = OXRRifle_ItemGranter
            Base.InitPlot()

    OnPlayerAdded(Player:player):void=
        if(PlayerAgent:=agent[Player]):
            spawn. TurnMusicOn(Player)

    GetPlayerStats(Player:player)<transacts><decides>:playerstats=
        return PlayerStatsMap[Player]?

    AsyncManageTempStats()<suspends>:void=
        Playspace := GetPlayspace()
        for (Player:Playspace.GetPlayers()):
            if (GiveTemporaryPlayerStats[Player]){}
        loop:
            race:
                block:
                    Player := Playspace.PlayerAddedEvent().Await()
                    if. GiveTemporaryPlayerStats[Player]
                block:
                    Player := Playspace.PlayerRemovedEvent().Await()
                    if:
                        StatsMap := PlayerStatsMap[Player]?
                        ActualBase:= StatsMap.HasClaimedBase?
                    then:
                        ActualBase.OnPlayerRemoved(Player)
                        StatsMap.OnLeave()
                    if. RemoveTemporaryPlayerStats[Player]

    # TEESTPLAYERLEAVING(Agent:agent):void=
    #     if:
    #         Player := player[Agent]
    #         StatsMap := PlayerStatsMap[Player]?
    #         ActualBase:= StatsMap.HasClaimedBase?
    #     then:
    #         ActualBase.OnPlayerRemoved(Player)
    #         StatsMap.OnLeave()
    #         if. RemoveTemporaryPlayerStats[Player]

    TurnMusicOn(Agent:agent)<suspends>:void=
        var ShouldContinue : logic = true
        loop:
            # Use race to determine if music was stopped
            MusicStopped := race:
                block:
                    BackgroundMusicAudioPlayer.Play(Agent)
                    Sleep(185.0)
                    false
                block:
                    MusicStoppedEvent.Await()
                    true
            if (MusicStopped = true):
                set ShouldContinue = false
            if (ShouldContinue = false):
                break

    GiveTemporaryPlayerStats(P:player)<transacts><decides>:void=
        not PlayerStatsMap[P]?
        set PlayerStatsMap[P] = option{playerstats{Player:=P}}
        if(PopUpUI.PlayerAdded[P]){}

    RemoveTemporaryPlayerStats(P:player)<transacts><decides>:void=
        PlayerStatsMap[P]?
        set PlayerStatsMap[P] = false
        if(PopUpUI.PlayerRemoved[P]){}
    
    


    
