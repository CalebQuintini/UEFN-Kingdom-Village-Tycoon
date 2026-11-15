using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { Persistence }
using { Utility }
using { UserInterface }

base_manager<public>:= class(creative_device):

    var selfindex<public>:int = -1
    var Status : ClaimStatus = ClaimStatus.Unclaimed
    var Players: []player = array{}
    var RootPlayer : ?player = false

    # Track if plot is revealed
    var IsRevealed : logic = false

    RevealDuration : float = 1.0

    @editable
    ClaimPlotTrigger:trigger_device = trigger_device{}
    @editable
    ClaimPlotButton:creative_prop=creative_prop{}
    @editable
    ClaimPlotText:creative_prop=creative_prop{}
    @editable 
    ClaimPropVFXCyclinder : creative_prop=creative_prop{}

    HiddenOffset : float = -500.0

    var ClaimHudMessage<public>:hud_message_device=hud_message_device{}

    #The basic props that the base has.
    @editable 
    base_props : []creative_prop  = array{}

    # Button To Test What Happens When A Player leaves
    @editable
    LeaveTycoonButton:button_device=button_device{}

    var Owner<public>:game_manager = game_manager{}
    var UIManager<public>:ui_manager = ui_manager{}
    @editable
    ButtonManager<public>:button_manager=button_manager{}

    @editable
    GiftRewardsButton<public>:button_device=button_device{}

    # Tutorial Device
    @editable
    TutorialDevice:tutorial=tutorial{}

    @editable
    PlayerReferenceDevice:player_reference_device=player_reference_device{}

    var ClaimBaseAccolade<public>:accolades_device=accolades_device{}

    @editable
    RebirthFailedHudMessage<public>:hud_message_device=hud_message_device{}

    var MusicLogic:logic=true
    @editable
    MusicOnSign:creative_prop=creative_prop{}
    @editable
    MusicOffSign:creative_prop=creative_prop{}
    @editable
    MusicLogicButton<public>:button_device=button_device{}
    var BackgroundMusicAudioPlayer<public>:audio_player_device = audio_player_device{}

    OnBegin<override>()<suspends>:void=
        MusicOnSign.Hide()
        MusicOffSign.Hide()
        MusicLogicButton.Disable()
        GiftRewardsButton.Disable()
        # Commented out at 10/30/2025 12:35 to test player leaving game through game manager button
        # Playspace := GetPlayspace()
        # Playspace.PlayerRemovedEvent().Subscribe(OnPlayerRemoved)
        ClaimPlotTrigger.TriggeredEvent.Subscribe(OnPlotClaimed)
        LeaveTycoonButton.InteractedWithEvent.Subscribe(AwaitOnLeave)
        MusicLogicButton.InteractedWithEvent.Subscribe(MusicButtonPressed)
        ButtonManager.RebirthButton.InteractedWithEvent.Subscribe(TESTTSET)
        PlayerReferenceDevice.Disable()
        spawn. MonitorMusicLogic()

    OnPlotClaimed(Agent:?agent):void=
        if:
            Status = ClaimStatus.Unclaimed
            ActualAgent := Agent? 
            Player := player[ActualAgent] 
            TempStats := Owner.GetPlayerStats[Player]
            TempStats.ClaimBase[Self]
        then:
            MusicLogicButton.Enable()
            GiftRewardsButton.Enable()
            ClaimBaseAccolade.Award(ActualAgent)
            set RootPlayer = option{Player}
            set ButtonManager.RootPlayer = option{Player}
            set TutorialDevice.RootPlayer = option{Player}
            TutorialDevice.PlayerAdded(Player)
            set ButtonManager.HitBoxManager.RootPlayer = option{Player}
            UIManager.PlayerAdded(Player)
            UIManager.ShowResourceUI(Player)
            set Status = ClaimStatus.Claimed
            ClaimPlotTrigger.Disable()
            ClaimPlotButton.Hide()
            ClaimPlotText.Hide()
            ClaimPropVFXCyclinder.Hide()
            spawn. RevealPlot()
            ClaimHudMessage.Show(ActualAgent)
            PlayerReferenceDevice.Enable()
            PlayerReferenceDevice.Register(ActualAgent)
            spawn. ButtonManager.MonitorPropButtonAvailability()
            ButtonManager.PlotBarrier.AddToIgnoreList(ActualAgent)
            ButtonManager.CheckPlayersPlot()
            if (ButtonManager.HitBoxManager.PopUpUI.PlayerAdded[Player]){}

    InitPlot<public>():void=
         # Move all props down at start
        for (Prop : base_props):
            StartTransform := Prop.GetTransform()
            # Create new transform with lowered position
            HiddenTransform := transform{
                Translation := StartTransform.Translation + vector3{X := 0.0, Y := 0.0, Z := HiddenOffset},
                Rotation := StartTransform.Rotation,
                Scale := StartTransform.Scale
            }
            # Use TeleportTo for instant movement
            if (Prop.TeleportTo[HiddenTransform]):

    MonitorMusicLogic()<suspends>:void=
        loop:
            if(IsRevealed = true):
                if(MusicLogic = true):
                    MusicOnSign.Hide()
                    MusicOffSign.Show()
                    MusicLogicButton.SetInteractionText(PlainText("Turn Off Music"))
                else:
                    MusicOnSign.Show()
                    MusicOffSign.Hide()
                    MusicLogicButton.SetInteractionText(PlainText("Turn On Music"))
            Sleep(1.0)
    MusicButtonPressed(Agent:agent):void=
        if (ActualPlayer:=RootPlayer?, PlayerAgent:=agent[ActualPlayer], PlayerAgent=Agent):
            if(MusicLogic = true):
                set MusicLogic = false
                Owner.MusicStoppedEvent.Signal()
                Owner.BackgroundMusicAudioPlayer.Stop(Agent)
            else:
                set MusicLogic = true
                spawn. Owner.TurnMusicOn(Agent)

    RevealPlot()<suspends> : void =
        if (IsRevealed = false):
            set IsRevealed = true
            # Animate each prop up to its original position
            for (Prop : base_props):
                StartTransform := Prop.GetTransform()
                EndTransform := transform{
                    Translation := StartTransform.Translation + vector3{X := 0.0, Y := 0.0, Z := -HiddenOffset},
                    Rotation := StartTransform.Rotation,
                    Scale := StartTransform.Scale
                }
                # Use MoveTo for smooth animation
                spawn{Prop.MoveTo(EndTransform, RevealDuration)}

    OnPlayerRemoved<public>(Player:player):void=
        if:
            ActuallPlayer:=RootPlayer?
            ActuallPlayer = Player
            StatsMap := Owner.PlayerStatsMap[Player]?
            Agent:=agent[Player]
        then:
            set MusicLogic = true
            MusicOnSign.Hide()
            MusicOffSign.Hide()
            MusicLogicButton.Disable()
            TutorialDevice.PlayerLeaves()
            GiftRewardsButton.Disable()
            set IsRevealed = false
            set RootPlayer = false
            PlayerReferenceDevice.Disable()
            PlayerReferenceDevice.Clear()
            UIManager.PlayerRemoved(Player)
            UIManager.CloseMoneyResourceUI(Player)
            StatsMap.OnLeave()
            set Status = ClaimStatus.Unclaimed
            ClaimPlotTrigger.Enable()
            ClaimPlotButton.Show()
            ClaimPlotText.Show()
            ClaimPropVFXCyclinder.Show()
            ButtonManager.PlayerLeaves(Agent)
            for (Prop : base_props):
                StartTransform := Prop.GetTransform()
                # Create new transform with lowered position
                HiddenTransform := transform{
                    Translation := StartTransform.Translation + vector3{X := 0.0, Y := 0.0, Z := HiddenOffset},
                    Rotation := StartTransform.Rotation,
                    Scale := StartTransform.Scale
                }
                # Use TeleportTo for instant movement
                if (Prop.TeleportTo[HiddenTransform]){}

    AwaitOnLeave(Agent:agent):void=
        if:
            Player := player[Agent]
            StatsMap := Owner.PlayerStatsMap[Player]?
        then:
            set MusicLogic = true
            MusicOnSign.Hide()
            MusicOffSign.Hide()
            MusicLogicButton.Disable()
            GiftRewardsButton.Disable()
            set IsRevealed = false
            set RootPlayer = false
            UIManager.PlayerRemoved(Player)
            UIManager.CloseMoneyResourceUI(Player)
            StatsMap.OnLeave()
            set Status = ClaimStatus.Unclaimed
            ClaimPlotTrigger.Enable()
            ClaimPlotButton.Show()
            ClaimPlotText.Show()
            ClaimPropVFXCyclinder.Show()
            ButtonManager.PlayerLeaves(Agent)
            for (Prop : base_props):
                StartTransform := Prop.GetTransform()
                # Create new transform with lowered position
                HiddenTransform := transform{
                    Translation := StartTransform.Translation + vector3{X := 0.0, Y := 0.0, Z := HiddenOffset},
                    Rotation := StartTransform.Rotation,
                    Scale := StartTransform.Scale
                }
                # Use TeleportTo for instant movement
                if (Prop.TeleportTo[HiddenTransform]){}

    TESTTSET(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
            StatsMap := Owner.PlayerStatsMap[ActualPlayer]?
            CheckUnlocked:=logic{CheckRebirth[ActualPlayer]}
            CheckUnlocked = true
        then:
            set MusicLogic = true
            MusicOnSign.Hide()
            MusicOffSign.Hide()
            MusicLogicButton.Disable()
            # ButtonManager.CheckIfPlayerHasUnlockedAllItems(ActualPlayer)
            TutorialDevice.PlayerLeaves()
            GiftRewardsButton.Disable()
            UIManager.CloseMoneyResourceUI(ActualPlayer)
            set IsRevealed = false
            set RootPlayer = false
            PlayerReferenceDevice.Disable()
            PlayerReferenceDevice.Clear()
            UIManager.PlayerRemoved(ActualPlayer)
            StatsMap.OnLeave()
            set Status = ClaimStatus.Unclaimed
            ClaimPlotTrigger.Enable()
            ClaimPlotButton.Show()
            ClaimPlotText.Show()
            ClaimPropVFXCyclinder.Show()
            # ButtonManager.PlayerLeaves(Agent)
            ButtonManager.TestLeave(Agent)
            for (Prop : base_props):
                StartTransform := Prop.GetTransform()
                # Create new transform with lowered position
                HiddenTransform := transform{
                    Translation := StartTransform.Translation + vector3{X := 0.0, Y := 0.0, Z := HiddenOffset},
                    Rotation := StartTransform.Rotation,
                    Scale := StartTransform.Scale
                }
                # Use TeleportTo for instant movement
                if (Prop.TeleportTo[HiddenTransform]){}
        else:
            if(ActualPlayer:=RootPlayer?, PlayerAgent:=agent[ActualPlayer], PlayerAgent=Agent):
                RebirthFailedHudMessage.Show(PlayerAgent)
