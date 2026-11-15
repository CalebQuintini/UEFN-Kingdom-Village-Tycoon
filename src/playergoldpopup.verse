using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation/Tags }
using { Persistence }
using { UserInterface }
using { Utility }
using { Config }

PlayerPopUpAttributes := class:
    Player : player
    var PopUpNumber : float = 0.0
    var PopUpTimePopUp : int = 0
    var PopUpHitCount : int = 0
    var Earn : float = 0.0
    GoldPopUpBreakLoopEvent : event() = event(){}

player_money_popup_device_system := class(creative_device):

    var PlayerPopUpMap : [player]PlayerPopUpAttributes = map{}

    @editable
    GoldHudPopUp : hud_message_device = hud_message_device{}

    # Earn Update
    UpdateEarnAmount(Player: player, GoldAmount: float): void =
        if:
            PopUp_Attributes := PlayerPopUpMap[Player]
            GoldAmountAmountRounded := GoldAmount
        then:
            set PopUp_Attributes.Earn = GoldAmountAmountRounded

    # Main Popup Trigger
    PopUpActivateProp(Player: player, GoldAmount: float): void =
        if:
            PopUp_Attributes := PlayerPopUpMap[Player]
        then:
            UpdateEarnAmount(Player, GoldAmount)
            set PopUp_Attributes.PopUpHitCount = 2
            if (PopUp_Attributes.PopUpHitCount = 2):
                if (PopUp_Attributes.PopUpTimePopUp < 10):
                    set PopUp_Attributes.PopUpNumber += 1.0
                    EarnAmount := PopUp_Attributes.PopUpNumber * PopUp_Attributes.Earn
                    GoldHudPopUp.SetText(StringToMessage("+{AbbreviateNumber((PopUp_Attributes.PopUpNumber * PopUp_Attributes.Earn))}"))
                    GoldHudPopUp.Show(Player)
                    PopUp_Attributes.GoldPopUpBreakLoopEvent.Signal()
                    spawn:
                        PopUpTimerForPopUp(Player)
                if(PopUp_Attributes.PopUpTimePopUp >= 10):
                    set PopUp_Attributes.PopUpHitCount = 1 
            if (PopUp_Attributes.PopUpHitCount = 1):
                set PopUp_Attributes.PopUpNumber = 0.0
                set PopUp_Attributes.PopUpNumber += 1.0
                GoldHudPopUp.SetText(StringToMessage("+{AbbreviateNumber((PopUp_Attributes.PopUpNumber * PopUp_Attributes.Earn))}"))
                GoldHudPopUp.Show(Player)
                PopUp_Attributes.GoldPopUpBreakLoopEvent.Signal()
                spawn:
                    PopUpTimerForPopUp(Player)
            set PopUp_Attributes.PopUpHitCount = 2

    PopUpTimerForPopUp(Player:player)<suspends> : void=
        if:
            PopUp_Attributes := PlayerPopUpMap[Player]
        then:
            set PopUp_Attributes.PopUpTimePopUp = 0
            race:
                block:
                    loop:
                        Sleep(0.1)
                        set PopUp_Attributes.PopUpTimePopUp += 1
                        if (PopUp_Attributes.PopUpTimePopUp >+ 20):
                            GoldHudPopUp.Hide(Player)
                            break
                block:
                    PopUp_Attributes.GoldPopUpBreakLoopEvent.Await()

    PlayerAdded(Player:player)<transacts><decides>:void=
        PopUpInitPlayer[Player]

    PlayerRemoved(Player:player)<transacts><decides>:void=
        OnPlayerLeftServer[Player]

    PopUpInitPlayer(Player : player)<transacts><decides>: void=
        if:
            Agent := agent[Player]
        then:
            if (Existign := PlayerPopUpMap[Player]){}
            else:
                PopUpInformation := PlayerPopUpAttributes{Player := Player}
                if (set PlayerPopUpMap[Player] = PopUpInformation) {}

    OnPlayerLeftServer(LeavingPlayer:player)<transacts><decides>:void=
        if (ThePlayer := PlayerPopUpMap[LeavingPlayer]):

            var NewPlayerBarrierMap:[player]PlayerPopUpAttributes = map{}

            for (Key -> Value : PlayerPopUpMap, Key <> LeavingPlayer):
                set NewPlayerBarrierMap = ConcatenateMaps(NewPlayerBarrierMap, map{Key => Value})

            set PlayerPopUpMap = NewPlayerBarrierMap
