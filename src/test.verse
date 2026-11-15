# This file contains a test device that sets up some useful buttons for testing the game.

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { Persistence }
using { UserInterface }

test<public>:= class(creative_device):

    # Button for granting money.
    @editable
    GrantMoneyButton:button_device = button_device{}

    @editable
    MinusGoldButton:button_device = button_device{}

    # UI manager for showing and updating UI.
    @editable
    UIManager:ui_manager = ui_manager{}

    OnBegin<override>()<suspends>:void=
        # Subscribe callbacks to get notified when a player interacts with the buttons.
        GrantMoneyButton.InteractedWithEvent.Subscribe(OnGrantMoneyButtonInteractedWith)
        MinusGoldButton.InteractedWithEvent.Subscribe(OnRemovePlayersGold)

    OnGrantMoneyButtonInteractedWith(Agent:agent):void=
        if:
            SelectedPlayer := player[Agent]
            GrantMoney[SelectedPlayer, 1000000000000.0]
        then:
            UIManager.UpdatePlayersResourceUIs(SelectedPlayer)

    OnRemovePlayersGold(Agent:agent):void=
        if:
            SelectedPlayer := player[Agent]
            PlayersGoldAmount := GetMoney[SelectedPlayer]
            SpendMoney[SelectedPlayer, PlayersGoldAmount]
            # ResetTutorial[SelectedPlayer]
        then:
            UIManager.UpdatePlayersResourceUIs(SelectedPlayer)

