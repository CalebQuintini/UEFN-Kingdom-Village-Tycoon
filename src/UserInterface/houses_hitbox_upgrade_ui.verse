using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Config }
using { Persistence }
using { Utility }
using { TycoonElements }

houses_hitbox_upgrades_ui_widgets := struct:
    Canvas<public>:canvas
    # Background
    BackgroundTextureWidget<public>:texture_block
    # Texts
    CurrentLevel_TextWidget<public>:text_block
    MoneyPerHit_TextWidget<public>:text_block
    UpgradePrice_TextWidget<public>:text_block
    # Buttons
    Upgrade_ButtonWidget<public>:button_quiet
    Close_ButtonWidget<public>:button_quiet

houses_hitbox_upgrades_ui := class(creative_device):

    # Stores the created UI for each player.
    var UIMap:[player]houses_hitbox_upgrades_ui_widgets = map{}

    # Map the player to the menu device
    var SecondaryUpgradeDeviceMap:[player]hitbox_manager = map{}

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
        then:
            set UIMap = NewUIMap

    # Create the UI.
    CreateUI():houses_hitbox_upgrades_ui_widgets=
        # Background
        BackgroundTextureWidget := texture_block:
            DefaultImage := Textures.HitboxUpgradeUI
            DefaultDesiredSize:=vector2{X := 2048.0, Y := 2048.0}
        # Texts
        CurrentLevel_TextWidget := text_block:
            DefaultTextColor:= NamedColors.White
            DefaultJustification:=text_justification.InvariantRight
            DefaultShadowOffset:= option{vector2{X := 2.0, Y := 3.0}}
            DefaultShadowColor:= NamedColors.Black
            DefaultShadowOpacity := 1.0
        MoneyPerHit_TextWidget := text_block:
            DefaultTextColor:= NamedColors.White
            DefaultJustification:=text_justification.InvariantRight
            DefaultShadowOffset:= option{vector2{X := 2.0, Y := 3.0}}
            DefaultShadowColor:= NamedColors.Black
            DefaultShadowOpacity := 1.0
        UpgradePrice_TextWidget := text_block:
            DefaultTextColor:= NamedColors.White
            DefaultJustification:=text_justification.InvariantRight
            DefaultShadowOffset:= option{vector2{X := 2.0, Y := 3.0}}
            DefaultShadowColor:= NamedColors.Black
            DefaultShadowOpacity := 1.0
        # Buttons
        Upgrade_ButtonWidget := button_quiet:
            DefaultText:= PlainText("UPGRADE")
        # Close UI Button
        Close_ButtonWidget := button_quiet:
            DefaultText:= PlainText("")

        Canvas := canvas:
            Slots := array:
                # Background
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := -960.022705, Top := 4.979431, Right := 1920.0, Bottom := 1080.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := false
                    Widget := BackgroundTextureWidget
                # Texts
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := 28.0, Top := 388.0, Right := 165.0, Bottom := 41.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := CurrentLevel_TextWidget
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := 28.0, Top := 491.215393, Right := 165.0, Bottom := 41.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := MoneyPerHit_TextWidget
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := 28.0, Top := 606.899597, Right := 165.0, Bottom := 41.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := UpgradePrice_TextWidget
                # Buttons
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := -108.727188, Top := 733.404236, Right := 218.0, Bottom := 60.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := false
                    Widget := Upgrade_ButtonWidget 
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := -150.0, Top := 835.0, Right := 300.666656, Bottom := 101.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := false
                    Widget := Close_ButtonWidget 

        # Subscribe callbacks to get notified when the player clicks the buttons.
        Upgrade_ButtonWidget.OnClick().Subscribe(HitAmount_UpgradeButton)
        Close_ButtonWidget.OnClick().Subscribe(OnCloseButton)

        return houses_hitbox_upgrades_ui_widgets:
            Canvas := Canvas
            # Background
            BackgroundTextureWidget := BackgroundTextureWidget
            # Texts
            CurrentLevel_TextWidget := CurrentLevel_TextWidget
            MoneyPerHit_TextWidget := MoneyPerHit_TextWidget
            UpgradePrice_TextWidget := UpgradePrice_TextWidget
            # Buttons
            Upgrade_ButtonWidget := Upgrade_ButtonWidget
            Close_ButtonWidget := Close_ButtonWidget

    # Show the UI to the player. The UI will show the menu for the selected player.
    ShowUI(Player:player, SecondaryUpgradesDevice:hitbox_manager):void=
        if:
            set SecondaryUpgradeDeviceMap[Player] = SecondaryUpgradesDevice
            UI := UIMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:
            UpdateUI(Player)
            PlayerUI.AddWidget(UI.Canvas, player_ui_slot{ZOrder := 0, InputMode := ui_input_mode.All})

    # Update the UI for the player.
    UpdateUI(Player:player):void=
        if:
            UI := UIMap[Player]
            SecondaryUpgradesDevice := SecondaryUpgradeDeviceMap[Player]
            # HitBox CurrentLevel
            HousesHitBoxLevel := GetHousesHitBoxLevel[Player]
            # Money Per Hit
            MoneyPerHit := GetPlayerHousesHitBoxHitAmount[Player]
            # Upgrade Price
            HitBoxUpgradePrice := GetPlayerHousesHitBoxPriceAmounts[Player]
        then:  
            # Texts
            UI.CurrentLevel_TextWidget.SetText(LevelText(HousesHitBoxLevel, 3))
            UI.MoneyPerHit_TextWidget.SetText(StringToMessage("${AbbreviateNumber(MoneyPerHit)}"))
            UI.UpgradePrice_TextWidget.SetText(StringToMessage("${AbbreviateNumber(HitBoxUpgradePrice)}"))
            # When player reaches the max levels.
            if(HousesHitBoxLevel >= 3):
                UI.UpgradePrice_TextWidget.SetText(StringToMessage(""))
                UI.Upgrade_ButtonWidget.SetEnabled(false)
            
    HitAmount_UpgradeButton(Message:widget_message):void=
        if:
            SecondaryUpgradesDevice := SecondaryUpgradeDeviceMap[Message.Player]
        then:
            SecondaryUpgradesDevice.UpgradeHousesHitBox(Message.Player)

    OnCloseButton(Message:widget_message):void=
        CloseUI(Message.Player)

    # Close the UI for the player.
    CloseUI<public>(Player:player):void=
        if:
            UI := UIMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:
            PlayerUI.RemoveWidget(UI.Canvas)
