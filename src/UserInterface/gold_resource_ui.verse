# This file defines the Money resource UI, which shows how many resources the player has.

using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Persistence }
using { Utility }

# Contains all widgets relevant for showing, closing and updating the UI.
Money_resource_ui_widgets := struct:
    Canvas<public>:canvas
    # Money
    ResourceTextWidget<public>:text_block
    MoneyRebirthtBoostResourceTextWidget<public>:text_block
    MoneyTextureWidget<public>:texture_block
    # Rebirth
    RebirthResourceTextWidget<public>:text_block
    RebirthTextureWidget<public>:texture_block

Money_resource_ui := class(creative_device):

    # Stores the created resource UI for each player.
    var UIMap:[player]Money_resource_ui_widgets = map{}

    # When a player is added, create the resource UI.
    PlayerAdded(Player:player):void=
        UIResult := CreateUI()
        if:
            PlayerUI := GetPlayerUI[Player]
            set UIMap[Player] = UIResult

    # When a player is removed, remove the stored data.
    PlayerRemoved(Player:player):void=
        if:
            NewUIMap := UIMap.RemoveKey[Player]
        then:
            set UIMap = NewUIMap

    # Create the UI.
    CreateUI():Money_resource_ui_widgets=
        # Money
        MoneyRebirthtBoostResourceTextWidget := text_block:
            DefaultTextColor:= NamedColors.White
            DefaultJustification:=text_justification.InvariantRight
            DefaultShadowOffset:= option{vector2{X := 2.0, Y := 3.0}}
            DefaultShadowColor:= NamedColors.Black
            DefaultShadowOpacity := 1.0
        ResourceTextWidget := text_block:
            DefaultTextColor:= NamedColors.White
            DefaultJustification:=text_justification.InvariantRight
            DefaultShadowOffset:= option{vector2{X := 2.0, Y := 3.0}}
            DefaultShadowColor:= NamedColors.Black
            DefaultShadowOpacity := 1.0
        MoneyTextureWidget := texture_block:
            DefaultImage := Textures.UI_Dollars
        # Rebirth
        RebirthResourceTextWidget := text_block:
            DefaultTextColor:= NamedColors.White
            DefaultJustification:=text_justification.InvariantRight
            DefaultShadowOffset:= option{vector2{X := 2.0, Y := 3.0}}
            DefaultShadowColor:= NamedColors.Black
            DefaultShadowOpacity := 1.0
        RebirthTextureWidget := texture_block:
            DefaultImage := Textures.UI_Rebirth

        Canvas := canvas:
            Slots := array:
                # Money
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 4.0, Top := -167.9104, Right := 165.0, Bottom := 40.285706}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := MoneyRebirthtBoostResourceTextWidget
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 100.694756, Top := -105.314079, Right := 167.0, Bottom := 40.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := ResourceTextWidget
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 0.0, Top := -215.573792, Right := 260.0, Bottom := 260.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := false
                    Widget := MoneyTextureWidget
                # Rebirths
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 100.694756, Top := -10.819777, Right := 167.0, Bottom := 40.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := RebirthResourceTextWidget
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 0.0, Top := -119.672165, Right := 260.0, Bottom := 260.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := false
                    Widget := RebirthTextureWidget

        return Money_resource_ui_widgets:
            Canvas := Canvas
            # Money
            MoneyRebirthtBoostResourceTextWidget := MoneyRebirthtBoostResourceTextWidget
            ResourceTextWidget := ResourceTextWidget
            MoneyTextureWidget := MoneyTextureWidget
            # Rebirth
            RebirthResourceTextWidget := RebirthResourceTextWidget
            RebirthTextureWidget := RebirthTextureWidget

    # Show the UI to the player. The UI will show the resources for the selected player.
    ShowUI(Player:player):void=
        if:
            UI := UIMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:
            UpdateUI(Player)
            PlayerUI.AddWidget(UI.Canvas)

    # Update the UI for the player.
    UpdateUI(Player:player):void=
        if:
            UI := UIMap[Player]
            MoneyAmount := GetMoney[Player]
            RebirthAmount := GetPlayerRebirthLevel[Player]
            RebirthOnce := logic{HasPlayerRebirthedOnce[Player]}
            RebirthTwice := logic{HasPlayerRebirthedTwice[Player]}
        then:
            # Money
            UI.ResourceTextWidget.SetText(StringToMessage(AbbreviateNumber(MoneyAmount)))
            # Rebirths
            UI.RebirthResourceTextWidget.SetText(CountText(RebirthAmount))
            if(RebirthOnce = true and RebirthTwice = false):
                UI.MoneyRebirthtBoostResourceTextWidget.SetText(PlainText("+20%"))
            else if(RebirthOnce = true and RebirthTwice = true):
                UI.MoneyRebirthtBoostResourceTextWidget.SetText(PlainText("+40%"))
            else:
                UI.MoneyRebirthtBoostResourceTextWidget.SetText(PlainText(""))

    # Close the UI for the player.
    CloseUI<public>(Player:player):void=
        if:
            UI := UIMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:
            PlayerUI.RemoveWidget(UI.Canvas)
