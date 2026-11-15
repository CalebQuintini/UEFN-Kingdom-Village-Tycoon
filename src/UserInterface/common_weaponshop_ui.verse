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

common_weaponshop_ui_widgets := struct:
    Canvas<public>:canvas
    # Background
    BackgroundTextureWidget<public>:texture_block
    # Buttons
    CombatPistol_ButtonWidget<public>:button_quiet
    SovereignShotgun_ButtonWidget<public>:button_quiet
    RedEyeAssaultRifle_ButtonWidget<public>:button_quiet
    Close_ButtonWidget<public>:button_quiet

common_weaponshop_ui := class(creative_device):

    # Stores the created UI for each player.
    var UIMap:[player]common_weaponshop_ui_widgets = map{}

    # Map the player to the menu device
    var SecondaryUpgradeDeviceMap:[player]button_manager = map{}

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
    CreateUI():common_weaponshop_ui_widgets=
        # Background
        BackgroundTextureWidget := texture_block:
            DefaultImage := Textures._2_Common_WeaponShop
            DefaultDesiredSize:=vector2{X := 2048.0, Y := 2048.0}
        # Buttons
        CombatPistol_ButtonWidget := button_quiet:
            DefaultText:= PlainText("PURCHASE")
        SovereignShotgun_ButtonWidget := button_quiet:
            DefaultText:= PlainText("PURCHASE")
        RedEyeAssaultRifle_ButtonWidget := button_quiet:
            DefaultText:= PlainText("PURCHASE")
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
                # Buttons
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := -546.142639, Top := 667.188904, Right := 237.5, Bottom := 60.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := false
                    Widget := CombatPistol_ButtonWidget 
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := -118.227188, Top := 667.188904, Right := 237.5, Bottom := 60.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := false
                    Widget := SovereignShotgun_ButtonWidget
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := 309.95047, Top := 667.188904, Right := 237.5, Bottom := 60.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := false
                    Widget := RedEyeAssaultRifle_ButtonWidget
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := -147.857147, Top := 824.285706, Right := 294.666656, Bottom := 92.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := false
                    Widget := Close_ButtonWidget 

        # Subscribe callbacks to get notified when the player clicks the buttons.
        CombatPistol_ButtonWidget.OnClick().Subscribe(CombatPistolButton)
        SovereignShotgun_ButtonWidget.OnClick().Subscribe(SovereignShotgunButton)
        RedEyeAssaultRifle_ButtonWidget.OnClick().Subscribe(RedEyeAssaultRifleButton)
        Close_ButtonWidget.OnClick().Subscribe(OnCloseButton)

        return common_weaponshop_ui_widgets:
            Canvas := Canvas
            # Background
            BackgroundTextureWidget := BackgroundTextureWidget
            # Buttons
            CombatPistol_ButtonWidget := CombatPistol_ButtonWidget
            SovereignShotgun_ButtonWidget := SovereignShotgun_ButtonWidget
            RedEyeAssaultRifle_ButtonWidget := RedEyeAssaultRifle_ButtonWidget
            Close_ButtonWidget := Close_ButtonWidget

    # Show the UI to the player. The UI will show the menu for the selected player.
    ShowUI(Player:player, SecondaryUpgradesDevice:button_manager):void=
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
            WeaponPrice := 18000.0
            PlayerMoneyAmount := GetMoney[Player]
        then:  
            if(PlayerMoneyAmount < WeaponPrice):
                UI.CombatPistol_ButtonWidget.SetEnabled(false)
                UI.SovereignShotgun_ButtonWidget.SetEnabled(false)
                UI.RedEyeAssaultRifle_ButtonWidget.SetEnabled(false)
            else:
                UI.CombatPistol_ButtonWidget.SetEnabled(true)
                UI.SovereignShotgun_ButtonWidget.SetEnabled(true)
                UI.RedEyeAssaultRifle_ButtonWidget.SetEnabled(true)
            
    CombatPistolButton(Message:widget_message):void=
        if:
            SecondaryUpgradesDevice := SecondaryUpgradeDeviceMap[Message.Player]
        then:
            SecondaryUpgradesDevice.PurchaseCombatPistol(Message.Player)
    SovereignShotgunButton(Message:widget_message):void=
        if:
            SecondaryUpgradesDevice := SecondaryUpgradeDeviceMap[Message.Player]
        then:
            SecondaryUpgradesDevice.PurchaseSovereignShotgun(Message.Player)
    RedEyeAssaultRifleButton(Message:widget_message):void=
        if:
            SecondaryUpgradesDevice := SecondaryUpgradeDeviceMap[Message.Player]
        then:
            SecondaryUpgradesDevice.PurchaseRedEyeAssaultRifle(Message.Player)

    OnCloseButton(Message:widget_message):void=
        CloseUI(Message.Player)

    # Close the UI for the player.
    CloseUI<public>(Player:player):void=
        if:
            UI := UIMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:
            PlayerUI.RemoveWidget(UI.Canvas)
