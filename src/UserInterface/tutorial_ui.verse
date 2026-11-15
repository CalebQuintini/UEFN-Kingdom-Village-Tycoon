using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Utility }
using { Config }

tracker_ui_widgets := struct:
    Canvas<public>:canvas
    # Background
    ColorBackgroundWidget<public>:texture_block
    # Tracker Title
    TrackerTitle_TextWidget<public>:text_block
    # Tracker Description
    TrackerDescription_TextWidget<public>:text_block
    # Tracker Progress
    TrackerProgress_TextWidget<public>:text_block

tracker_ui := class(creative_device):

    # Stores the created tracker UI for each player.
    var UIMap:[player]tracker_ui_widgets = map{}

    # Map the player to the menu device
    var TrackerDeviceMap:[player]tutorial = map{}

    # When a player is added, create the UI.
    PlayerAdded(Player:player):void=
        UIResult := CreateUI()
        if:
            PlayerUI := GetPlayerUI[Player]
            set UIMap[Player] = UIResult

    # When a player is removed, remove the stored data.
    PlayerRemoved(Player:player):void=
        if:
            NewUIMap := UIMap.RemoveKey[Player]
            NewTrackerDeviceMap := TrackerDeviceMap.RemoveKey[Player]
        then:
            set UIMap = NewUIMap
            set TrackerDeviceMap = NewTrackerDeviceMap

    # Create the UI.
    CreateUI():tracker_ui_widgets=
        # Background
        ColorBackgroundWidget := texture_block:
            DefaultImage := Textures.UI_Tutorial
        # Tracker Title
        TrackerTitle_TextWidget := text_block:
            DefaultTextColor:= NamedColors.White
            DefaultJustification:=text_justification.InvariantRight
            DefaultShadowOffset:= option{vector2{X := 2.0, Y := 3.0}}
            DefaultShadowColor:= NamedColors.Black
            DefaultShadowOpacity := 1.0
        # Tracker Description
        TrackerDescription_TextWidget := text_block:
            DefaultTextColor:= NamedColors.White
            DefaultJustification:=text_justification.Left
            DefaultShadowOffset:= option{vector2{X := 2.0, Y := 3.0}}
            DefaultShadowColor:= NamedColors.Black
            DefaultShadowOpacity := 1.0
        # Tracker Progress
        TrackerProgress_TextWidget := text_block:
            DefaultTextColor:= NamedColors.White
            DefaultJustification:=text_justification.InvariantRight
            DefaultShadowOffset:= option{vector2{X := 2.0, Y := 3.0}}
            DefaultShadowColor:= NamedColors.Black
            DefaultShadowOpacity := 1.0

        Canvas := canvas:
            Slots := array:
                # Background
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 1.0, Y := 0.35}, Maximum := vector2{X := 1.0, Y := 0.35}}
                    Offsets := margin{Left := -2322.788574, Top := -240.671173, Right := 2322.846191, Bottom := 1519.88147}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := false
                    Widget := ColorBackgroundWidget
                # Tracker Title
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 1.0, Y := 0.35}, Maximum := vector2{X := 1.0, Y := 0.35}}
                    Offsets := margin{Left := -363.79834, Top := -94.973236, Right := 241.0, Bottom := 39.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := TrackerTitle_TextWidget
                # Tracker Description
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 1.0, Y := 0.35}, Maximum := vector2{X := 1.0, Y := 0.35}}
                    Offsets := margin{Left := -372.0, Top := -31.448914, Right := 295.0, Bottom := 77.999985}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := TrackerDescription_TextWidget
                # Tracker Progress
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 1.0, Y := 0.35}, Maximum := vector2{X := 1.0, Y := 0.35}}
                    Offsets := margin{Left := -249.37146, Top := 99.636444, Right := 63.087017, Bottom := 39.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := TrackerProgress_TextWidget

        return tracker_ui_widgets:
            Canvas := Canvas
            # Background
            ColorBackgroundWidget := ColorBackgroundWidget
            # Tracker Title
            TrackerTitle_TextWidget := TrackerTitle_TextWidget
            # Tracker Description
            TrackerDescription_TextWidget := TrackerDescription_TextWidget
            # Tracker Progress
            TrackerProgress_TextWidget := TrackerProgress_TextWidget

    # Show the UI to the player. The UI will show the menu for the selected player.
    ShowUI(Player:player, TrackerDevice:tutorial, Tracker:tracker_device, Id:string):void=
        if:
            set TrackerDeviceMap[Player] = TrackerDevice
            UI_Info := UIMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:
            UpdateUI(Player, Tracker, Id)
            PlayerUI.AddWidget(UI_Info.Canvas)

    # Update the UI for the player.
    UpdateUI(Player:player, Tracker:tracker_device, Id:string):void=
        if:
            UI_Info := UIMap[Player]
            Agent := agent[Player]
            TrackerValue := Tracker.GetValue(Agent)
            TargetValue := Tracker.GetTarget()
        then:  
            for (Info : GetTrackerInformation(), Info.id = Id):
                TitleMessage := StringToMessage(Info.Title)
                DescriptionMessage := StringToMessage(Info.Description)
                ProgressMessage:= ProgressText(TrackerValue, TargetValue)
                UI_Info.TrackerTitle_TextWidget.SetText(TitleMessage)
                UI_Info.TrackerDescription_TextWidget.SetText(DescriptionMessage)
                if(TrackerValue < TargetValue):
                    UI_Info.TrackerProgress_TextWidget.SetText(ProgressMessage)
                    UI_Info.TrackerProgress_TextWidget.SetTextColor(MakeColorFromHex("FE4D5AFF")) 
                else:
                    UI_Info.TrackerProgress_TextWidget.SetText(ProgressMessage)
                    UI_Info.TrackerProgress_TextWidget.SetTextColor(NamedColors.Green)

    # Close the UI for the player.
    CloseUI<public>(Player:player):void=
        if:
            UI_Info := UIMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:
            PlayerUI.RemoveWidget(UI_Info.Canvas)
