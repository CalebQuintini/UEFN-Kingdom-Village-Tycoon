# This file contains a tutorial device that guides the player through playing the game.
# The device tracks the player's progress and serves up the next tutorial step using
# tracker_devices to generate explanatory UI and map_indicator_devices to guide the
# player around the map.

using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { Persistence }
using { UserInterface }
using { Utility }
using { TycoonElements }

tutorial := class(creative_device):

    var RootPlayer : ?player = false

    @editable
    AudioDevice : audio_player_device = audio_player_device{}

    @editable
    UIManger:ui_manager=ui_manager{}

    # Step 1 
    # Tracker for tutorial step telling player to Unlock DollarHitBox.
    @editable
    DollarHitBox_Tracker:tracker_device = tracker_device{}
    # Map indicator for above step.
    @editable
    DollarHitBox_MapIndicator:map_indicator_device = map_indicator_device{}
    # Button Manager
    # -----------------------------------
    @editable
    ButtonManagerDevice:button_manager = button_manager{}
    # -----------------------------------
    # Step 2
    # Tracker 
    @editable
    MoneyCollector_Tracker:tracker_device = tracker_device{}
    # Map indicator
    @editable
    MoneyCollector_MapIndicator:map_indicator_device = map_indicator_device{}
    # -----------------------------------
    # Step 3
    # Tracker 
    @editable
    Tree1_Tracker:tracker_device = tracker_device{}
    # Map indicator
    @editable
    Tree1_MapIndicator:map_indicator_device = map_indicator_device{}
    # -----------------------------------
    # Step 4
    # Tracker 
    @editable
    Tree2_Tracker:tracker_device = tracker_device{}
    # Map indicator
    @editable
    Tree2_MapIndicator:map_indicator_device = map_indicator_device{}
    # -----------------------------------
    # Step 5
    # Tracker 
    @editable
    Tree3_Tracker:tracker_device = tracker_device{}
    # Map indicator
    @editable
    Tree3_MapIndicator:map_indicator_device = map_indicator_device{}
    # -----------------------------------
    # Step 6
    # Tracker 
    @editable
    Tree4_Tracker:tracker_device = tracker_device{}
    # Map indicator
    @editable
    Tree4_MapIndicator:map_indicator_device = map_indicator_device{}
    # -----------------------------------
    # Step 7
    # Tracker 
    @editable
    PlotShield_Tracker:tracker_device = tracker_device{}
    # Map indicator
    @editable
    PlotShield_MapIndicator:map_indicator_device = map_indicator_device{}
    # -----------------------------------
    # -----------------------------------

    # Runs when the device is started in a running game.
    OnBegin<override>()<suspends>:void=
        NoMapIndicator : ?map_indicator_device = false 
        # Subscribe callbacks to get notified when a tracker is completed.
        # Step 1
        DollarHitBox_Tracker.CompleteEvent.SubscribeAgent2(OnTutorialStepTrackerComplete, (DollarHitBox_Tracker, option{DollarHitBox_MapIndicator}))
        # Step 2
        MoneyCollector_Tracker.CompleteEvent.SubscribeAgent2(OnTutorialStepTrackerComplete, (MoneyCollector_Tracker, option{MoneyCollector_MapIndicator}))
        # Step 3
        Tree1_Tracker.CompleteEvent.SubscribeAgent2(OnTutorialStepTrackerComplete, (Tree1_Tracker, option{Tree1_MapIndicator}))
        # Step 4
        Tree2_Tracker.CompleteEvent.SubscribeAgent2(OnTutorialStepTrackerComplete, (Tree2_Tracker, option{Tree2_MapIndicator}))
        # Step 5
        Tree3_Tracker.CompleteEvent.SubscribeAgent2(OnTutorialStepTrackerComplete, (Tree3_Tracker, option{Tree3_MapIndicator}))
        # Step 6
        Tree4_Tracker.CompleteEvent.SubscribeAgent2(OnTutorialStepTrackerComplete, (Tree4_Tracker, option{Tree4_MapIndicator}))
        # Step 7
        PlotShield_Tracker.CompleteEvent.SubscribeAgent2(OnTutorialStepTrackerComplete, (PlotShield_Tracker, option{PlotShield_MapIndicator}))

    # When a player is added, determine the tutorial progress.
    PlayerAdded<public>(Player:player):void=
        # Slightly delay determining the initial tutorial progress.
        if:
            ActualPlayer:=RootPlayer?
            ActualPlayer = Player
        then:
            spawn:
                DelayedDetermineTutorialProgress(ActualPlayer, 0.5)

    # Determines the tutorial progress with a slight delay.
    DelayedDetermineTutorialProgress(Player:player, Delay:float)<suspends>:void=
        Sleep(Delay)
        if (Player.IsActive[]):
           DetermineTutorialProgress(Player)

    # Determines the tutorial progress.
    DetermineTutorialProgress(Agent:agent):void=
        if:
            ActualPlayer:=RootPlayer?
            PlayerAgent:=agent[ActualPlayer]
            PlayerAgent=Agent
            # Check Step 1
            HasPlayerUnlockDollarHitBox:=logic{CheckIfTutorialIsCompleted[ActualPlayer, "HousesHitBox"]}
            # Check Step 2
            HasPlayerUnlockMoneyCollector:=logic{CheckIfTutorialIsCompleted[ActualPlayer, "MoneyCollector"]}
            # Check Step 3
            HasPlayerUnlockTree1:=logic{CheckIfTutorialIsCompleted[ActualPlayer, "WatchTower1"]}
            # Check Step 4
            HasPlayerUnlockTree2:=logic{CheckIfTutorialIsCompleted[ActualPlayer, "WatchTower2"]}
            # Check Step 5
            HasPlayerUnlockTree3:=logic{CheckIfTutorialIsCompleted[ActualPlayer, "WatchTower3"]}
            # Check Step 6
            HasPlayerUnlockTree4:=logic{CheckIfTutorialIsCompleted[ActualPlayer, "WatchTower4"]}
            # Check Step 7
            HasPlayerUnlockPlotShield:=logic{CheckIfTutorialIsCompleted[ActualPlayer, "ArmoryStand1"]}
        then:
            # Step 1
            if (not HasPlayerUnlockDollarHitBox?):
                HitBoxStep(Agent, ButtonManagerDevice)
            # Step 2
            else if(not HasPlayerUnlockMoneyCollector?):
                MoneyCollectorStep(Agent, ButtonManagerDevice)
            # Step 3
            else if(not HasPlayerUnlockTree1?):
                Tree1Step(Agent, ButtonManagerDevice)
            # Step 4
            else if(not HasPlayerUnlockTree2?):
                Tree2EventStep(Agent, ButtonManagerDevice)
            # Step 5
            else if(not HasPlayerUnlockTree3?):
                Tree3EventStep(Agent, ButtonManagerDevice)
            # Step 6
            else if(not HasPlayerUnlockTree4?):
                Tree4EventStep(Agent, ButtonManagerDevice)
            # Step 7
            else if(not HasPlayerUnlockPlotShield?):
                PlotShieldEventStep(Agent, ButtonManagerDevice)

    # Step 1
    HitBoxStep(Agent:agent, ButtonManager:button_manager):void=
        if:
            SelectedPlayer := player[Agent]
        then:
            UIManger.ShowTrackerUI(SelectedPlayer, Self, DollarHitBox_Tracker, "HousesHitBox")
            # Reset and assign the tracker to make the UI appear.
            DollarHitBox_Tracker.Reset(Agent)
            DollarHitBox_Tracker.Assign(Agent)
            # Currently, the objective pulse must be activated multiple times for it to work.
            DollarHitBox_MapIndicator.ActivateObjectivePulse(Agent)
            DollarHitBox_MapIndicator.ActivateObjectivePulse(Agent)
            # Continuously monitor.
            spawn:
                MonitorHitBoxBought(Agent, ButtonManager)
    MonitorHitBoxBought(Agent:agent, ButtonManager:button_manager)<suspends>:void=
        if:
            sl := player[Agent]
        then:
            if (Player := player[Agent]):
                race:# Break out if the player leaves or the selected player was reset.
                        loop:
                            if (not Player.IsActive[]):
                                # Remove the current tracker and map indicator.
                                DollarHitBox_Tracker.Remove(Agent)
                                DollarHitBox_MapIndicator.DeactivateObjectivePulse(Agent)
                                # Determine a new tutorial step.
                                DelayedDetermineTutorialProgress(Player, 0.5)
                                break
                            Sleep(0.5)
                        # Break out when completed.s
                        loop:
                            CompletedAgent := DollarHitBox_Tracker.CompleteEvent.Await()
                            if (CompletedAgent = Agent):
                                AudioDevice.Play(Player)
                                if (SetTutorialInfoBoughtTrue[Player, "HousesHitBox"]){}
                                UIManger.CloseTrackerUI(sl)
                                break
                        # Wait for the event and increment the tracker.
                        loop:
                            ButtonManagerDevice.HitBoxEvent.Await()
                            DollarHitBox_Tracker.Increment(Agent)
                            UIManger.UpdateTrackerUI(sl, DollarHitBox_Tracker, "HousesHitBox")
    # Step 2
    MoneyCollectorStep(Agent:agent, ButtonManager:button_manager):void=
        if:
            SelectedPlayer := player[Agent]
        then:
            UIManger.ShowTrackerUI(SelectedPlayer, Self, MoneyCollector_Tracker, "MoneyCollector")
            # Reset and assign the tracker to make the UI appear.
            MoneyCollector_Tracker.Reset(Agent)
            MoneyCollector_Tracker.Assign(Agent)
            # Currently, the objective pulse must be activated multiple times for it to work.
            MoneyCollector_MapIndicator.ActivateObjectivePulse(Agent)
            MoneyCollector_MapIndicator.ActivateObjectivePulse(Agent)
            # Continuously monitor.
            spawn:
                MonitorMoneyCollectorBought(Agent, ButtonManager)
    MonitorMoneyCollectorBought(Agent:agent, ButtonManager:button_manager)<suspends>:void=
        if:
            sl := player[Agent]
        then:
            if (Player := player[Agent]):
                race:# Break out if the player leaves or the selected player was reset.
                        loop:
                            if (not Player.IsActive[]):
                                # Remove the current tracker and map indicator.
                                MoneyCollector_Tracker.Remove(Agent)
                                MoneyCollector_MapIndicator.DeactivateObjectivePulse(Agent)
                                # Determine a new tutorial step.
                                DelayedDetermineTutorialProgress(Player, 0.5)
                                break
                            Sleep(0.5)
                        # Break out when completed.s
                        loop:
                            CompletedAgent := MoneyCollector_Tracker.CompleteEvent.Await()
                            if (CompletedAgent = Agent):
                                AudioDevice.Play(Player)
                                if (SetTutorialInfoBoughtTrue[Player, "MoneyCollector"]){}
                                UIManger.CloseTrackerUI(sl)
                                break
                        # Wait for the event and increment the tracker.
                        loop:
                            ButtonManagerDevice.MoneyCollectorEvent.Await()
                            MoneyCollector_Tracker.Increment(Agent)
                            UIManger.UpdateTrackerUI(sl, MoneyCollector_Tracker, "MoneyCollector")
    # Step 3
    Tree1Step(Agent:agent, ButtonManager:button_manager):void=
        if:
            SelectedPlayer := player[Agent]
        then:
            UIManger.ShowTrackerUI(SelectedPlayer, Self, Tree1_Tracker, "WatchTower1")
            # Reset and assign the tracker to make the UI appear.
            Tree1_Tracker.Reset(Agent)
            Tree1_Tracker.Assign(Agent)
            # Currently, the objective pulse must be activated multiple times for it to work.
            Tree1_MapIndicator.ActivateObjectivePulse(Agent)
            Tree1_MapIndicator.ActivateObjectivePulse(Agent)
            spawn:
                MonitorTree1Bought(Agent, ButtonManager)
    MonitorTree1Bought(Agent:agent, ButtonManager:button_manager)<suspends>:void=
        if:
            sl := player[Agent]
        then:
            if (Player := player[Agent]):
                race:# Break out if the player leaves or the selected player was reset.
                        loop:
                            if (not Player.IsActive[]):
                                # Remove the current tracker and map indicator.
                                Tree1_Tracker.Remove(Agent)
                                Tree1_MapIndicator.DeactivateObjectivePulse(Agent)
                                # Determine a new tutorial step.
                                DelayedDetermineTutorialProgress(Player, 0.5)
                                break
                            Sleep(0.5)
                        # Break out when completed.
                        loop:
                            CompletedAgent := Tree1_Tracker.CompleteEvent.Await()
                            if (CompletedAgent = Agent):
                                AudioDevice.Play(Player)
                                if (SetTutorialInfoBoughtTrue[Player, "WatchTower1"]){}
                                UIManger.CloseTrackerUI(sl)
                                break
                        # Wait for the event and increment the tracker.
                        loop:
                            ButtonManagerDevice.WatchTower1Event.Await()
                            Tree1_Tracker.Increment(Agent)
                            UIManger.UpdateTrackerUI(sl, Tree1_Tracker, "WatchTower1")
    # Step 4
    Tree2EventStep(Agent:agent, ButtonManager:button_manager):void=
        if:
            SelectedPlayer := player[Agent]
        then:
            UIManger.ShowTrackerUI(SelectedPlayer, Self, Tree2_Tracker, "WatchTower2")
            # Reset and assign the tracker to make the UI appear.
            Tree2_Tracker.Reset(Agent)
            Tree2_Tracker.Assign(Agent)
            # Currently, the objective pulse must be activated multiple times for it to work.
            Tree2_MapIndicator.ActivateObjectivePulse(Agent)
            Tree2_MapIndicator.ActivateObjectivePulse(Agent)
            spawn:
                MonitorTree2Bought(Agent, ButtonManager)
    MonitorTree2Bought(Agent:agent, ButtonManager:button_manager)<suspends>:void=
        if:
            sl := player[Agent]
        then:
            if (Player := player[Agent]):
                race:# Break out if the player leaves or the selected player was reset.
                        loop:
                            if (not Player.IsActive[]):
                                # Remove the current tracker and map indicator.
                                Tree2_Tracker.Remove(Agent)
                                Tree2_MapIndicator.DeactivateObjectivePulse(Agent)
                                # Determine a new tutorial step.
                                DelayedDetermineTutorialProgress(Player, 0.5)
                                break
                            Sleep(0.5)
                        # Break out when completed.
                        loop:
                            CompletedAgent := Tree2_Tracker.CompleteEvent.Await()
                            if (CompletedAgent = Agent):
                                AudioDevice.Play(Player)
                                if (SetTutorialInfoBoughtTrue[Player, "WatchTower2"]){}
                                UIManger.CloseTrackerUI(sl)
                                break
                        # Wait for the event and increment the tracker.
                        loop:
                            ButtonManagerDevice.WatchTower2Event.Await()
                            Tree2_Tracker.Increment(Agent)
                            UIManger.UpdateTrackerUI(sl, Tree2_Tracker, "WatchTower2")
    # Step 5
    Tree3EventStep(Agent:agent, ButtonManager:button_manager):void=
        if:
            SelectedPlayer := player[Agent]
        then:
            UIManger.ShowTrackerUI(SelectedPlayer, Self, Tree3_Tracker, "WatchTower3")
            # Reset and assign the tracker to make the UI appear.
            Tree3_Tracker.Reset(Agent)
            Tree3_Tracker.Assign(Agent)
            # Currently, the objective pulse must be activated multiple times for it to work.
            Tree3_MapIndicator.ActivateObjectivePulse(Agent)
            Tree3_MapIndicator.ActivateObjectivePulse(Agent)
            spawn:
                MonitorTree3Bought(Agent, ButtonManager)
    MonitorTree3Bought(Agent:agent, ButtonManager:button_manager)<suspends>:void=
        if:
            sl := player[Agent]
        then:
            if (Player := player[Agent]):
                race:# Break out if the player leaves or the selected player was reset.
                        loop:
                            if (not Player.IsActive[]):
                                # Remove the current tracker and map indicator.
                                Tree3_Tracker.Remove(Agent)
                                Tree3_MapIndicator.DeactivateObjectivePulse(Agent)
                                # Determine a new tutorial step.
                                DelayedDetermineTutorialProgress(Player, 0.5)
                                break
                            Sleep(0.5)
                        # Break out when completed.
                        loop:
                            CompletedAgent := Tree3_Tracker.CompleteEvent.Await()
                            if (CompletedAgent = Agent):
                                AudioDevice.Play(Player)
                                if (SetTutorialInfoBoughtTrue[Player, "WatchTower3"]){}
                                UIManger.CloseTrackerUI(sl)
                                break
                        # Wait for the event and increment the tracker.
                        loop:
                            ButtonManagerDevice.WatchTower3Event.Await()
                            Tree3_Tracker.Increment(Agent)
                            UIManger.UpdateTrackerUI(sl, Tree3_Tracker, "WatchTower3")
    # Step 6
    Tree4EventStep(Agent:agent, ButtonManager:button_manager):void=
        if:
            SelectedPlayer := player[Agent]
        then:
            UIManger.ShowTrackerUI(SelectedPlayer, Self, Tree4_Tracker, "WatchTower4")
            # Reset and assign the tracker to make the UI appear.
            Tree4_Tracker.Reset(Agent)
            Tree4_Tracker.Assign(Agent)
            # Currently, the objective pulse must be activated multiple times for it to work.
            Tree4_MapIndicator.ActivateObjectivePulse(Agent)
            Tree4_MapIndicator.ActivateObjectivePulse(Agent)
            spawn:
                MonitorTree4Bought(Agent, ButtonManager)
    MonitorTree4Bought(Agent:agent, ButtonManager:button_manager)<suspends>:void=
        if:
            sl := player[Agent]
        then:
            if (Player := player[Agent]):
                race:# Break out if the player leaves or the selected player was reset.
                        loop:
                            if (not Player.IsActive[]):
                                # Remove the current tracker and map indicator.
                                Tree4_Tracker.Remove(Agent)
                                Tree4_MapIndicator.DeactivateObjectivePulse(Agent)
                                # Determine a new tutorial step.
                                DelayedDetermineTutorialProgress(Player, 0.5)
                                break
                            Sleep(0.5)
                        # Break out when completed.
                        loop:
                            CompletedAgent := Tree4_Tracker.CompleteEvent.Await()
                            if (CompletedAgent = Agent):
                                AudioDevice.Play(Player)
                                if (SetTutorialInfoBoughtTrue[Player, "WatchTower4"]){}
                                UIManger.CloseTrackerUI(sl)
                                break
                        # Wait for the event and increment the tracker.
                        loop:
                            ButtonManagerDevice.WatchTower4Event.Await()
                            Tree4_Tracker.Increment(Agent)
                            UIManger.UpdateTrackerUI(sl, Tree4_Tracker, "WatchTower4")
    # Step 7
    PlotShieldEventStep(Agent:agent, ButtonManager:button_manager):void=
        if:
            SelectedPlayer := player[Agent]
        then:
            UIManger.ShowTrackerUI(SelectedPlayer, Self, PlotShield_Tracker, "ArmoryStand1")
            # Reset and assign the tracker to make the UI appear.
            PlotShield_Tracker.Reset(Agent)
            PlotShield_Tracker.Assign(Agent)
            # Currently, the objective pulse must be activated multiple times for it to work.
            PlotShield_MapIndicator.ActivateObjectivePulse(Agent)
            PlotShield_MapIndicator.ActivateObjectivePulse(Agent)
            spawn:
                MonitorPlotShieldBought(Agent, ButtonManager)
    MonitorPlotShieldBought(Agent:agent, ButtonManager:button_manager)<suspends>:void=
        if:
            sl := player[Agent]
        then:
            if (Player := player[Agent]):
                race:# Break out if the player leaves or the selected player was reset.
                        loop:
                            if (not Player.IsActive[]):
                                # Remove the current tracker and map indicator.
                                PlotShield_Tracker.Remove(Agent)
                                PlotShield_MapIndicator.DeactivateObjectivePulse(Agent)
                                # Determine a new tutorial step.
                                DelayedDetermineTutorialProgress(Player, 0.5)
                                break
                            Sleep(0.5)
                        # Break out when completed.
                        loop:
                            CompletedAgent := PlotShield_Tracker.CompleteEvent.Await()
                            if (CompletedAgent = Agent):
                                AudioDevice.Play(Player)
                                if (SetTutorialInfoBoughtTrue[Player, "ArmoryStand1"]){}
                                UIManger.CloseTrackerUI(sl)
                                break
                        # Wait for the event and increment the tracker.
                        loop:
                            ButtonManagerDevice.ArmoryStand1Event.Await()
                            PlotShield_Tracker.Increment(Agent)
                            UIManger.UpdateTrackerUI(sl, PlotShield_Tracker, "ArmoryStand1")
         
    MonitorTutorialInterruption(Agent:agent)<suspends>:void=
        if (Player := player[Agent]):
            loop:
                # Break out if the player leaves or the selected player was reset.
                if (not Player.IsActive[]):
                    # Determine a new tutorial step.
                    DelayedDetermineTutorialProgress(Player, 0.5)
                    break
                Sleep(0.5)

    # Handles when the tutorial step tracker is complete.
    OnTutorialStepTrackerComplete(Agent:agent, TrackerAndMaybeMapIndicator:tuple(tracker_device, ?map_indicator_device)):void=
        spawn:
            CompleteTutorialStep(Agent, TrackerAndMaybeMapIndicator(0), TrackerAndMaybeMapIndicator(1))
    
    # Completes the tutorial step by deactivating any map indicator, removing the tracker and determining
    # the next tutorial step.
    CompleteTutorialStep(Agent:agent, Tracker:tracker_device, MaybeMapIndicator:?map_indicator_device)<suspends>:void=
        if:
            MapIndicator := MaybeMapIndicator?
        then:
            MapIndicator.DeactivateObjectivePulse(Agent)

        # Wait a little to allow the tutorial step UI to complete.
        Sleep(0.5)

        Tracker.Remove(Agent)
        Tracker.Complete(Agent)

        # Show next tutorial step.
        DetermineTutorialProgress(Agent)

    PlayerLeaves():void=
        if (ActualPlayer:=RootPlayer?, PlayerAgent:=agent[ActualPlayer]):
            set RootPlayer = false



