# This file defines player_info, the collection of persistable information stored for each player.
# It also contains functions for creating, updating and returning information about a player.

using { /Verse.org/Simulation }
using { TycoonElements }

# Temp states on a game by game basis
playerstats<public>:=class<final><unique>:

    var ParkourCompleted<public>:logic=false
    var TernItemsCollected<public>:int=0
    IncrementTernItemsCollected<public>()<transacts><decides>:void=
        set TernItemsCollected += 1
    ResetTernItemsCollected<public>()<transacts><decides>:void=
        set TernItemsCollected = 0

    var HasClaimedBase<public>:?base_manager = false
    var Player<public>:player

    OnLeave<public>():void=
        set HasClaimedBase = false

    ClaimBase<public>(Base:base_manager)<transacts><decides>:void=
        not HasClaimedBase?
        set HasClaimedBase = option{Base}

# Maps each player to their persisted information.
var PlayerInfoMap:weak_map(player, player_info) = map{}

# This tracks all persistable information for a player.
player_info := class<final><persistable>:

    # The version of the current player info.
    Version:int = 0

    # The amount of Money the player has.
    Money:float = 0.0

    Rebirths:int = 0
    RebirthOnce:logic=false
    RebirthTwice:logic=false

    PlayersCurrentPropIndex : int = 0
    MoneyCollectorLevel : int = 0

    # Keeps track of the props bought and price.
    PropsInfo:prop_info=prop_info{}

    # Tutorial
    Tutorial : tutorial_info = tutorial_info{}

    # Hitboxes
    HousesHitBoxLevel:int = 0
    FarmHitBoxLevel:int = 0
    MarketsHitBoxLevel:int = 0
    TrainingAreaHitBoxLevel:int = 0
    TempleHitBox:int = 0
    QuarryHitBox:int = 0
    BarracksHitBox:int = 0
    WoodHitBox:int = 0

# Creates a new player_info with the same values as the previous player_info.
MakePlayerInfo<constructor>(Src:player_info)<transacts> := player_info:
    Version := Src.Version
    Money := Src.Money
    Rebirths := Src.Rebirths
    PropsInfo := Src.PropsInfo
    PlayersCurrentPropIndex := Src.PlayersCurrentPropIndex
    HousesHitBoxLevel := Src.HousesHitBoxLevel
    FarmHitBoxLevel := Src.FarmHitBoxLevel
    MarketsHitBoxLevel := Src.MarketsHitBoxLevel
    TrainingAreaHitBoxLevel := Src.TrainingAreaHitBoxLevel
    TempleHitBox := Src.TempleHitBox
    QuarryHitBox := Src.QuarryHitBox
    BarracksHitBox := Src.BarracksHitBox
    WoodHitBox := Src.WoodHitBox
    MoneyCollectorLevel := Src.MoneyCollectorLevel
    RebirthOnce := Src.RebirthOnce
    RebirthTwice := Src.RebirthTwice
    Tutorial := Src.Tutorial

# Creates player information for the player if none exists. 
CheckPlayerInfoForPlayer(Player:player)<decides><transacts>:void=
    Player.IsActive[]
    if(not PlayerInfoMap[Player]):
        set PlayerInfoMap[Player] = player_info{}

# Grant the amount of Money to the player.
GrantMoney<public>(Player:player, Amount:float)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]

    set PlayerInfoMap[Player] = player_info:
        # Because of 10/09/2025 update move MakePlayerInfo below money and do the same for rest of functions
        # MakePlayerInfo<constructor>(SourceInfo)
        Money := SourceInfo.Money + Amount
        MakePlayerInfo<constructor>(SourceInfo)

# Spend the amount of Money for the player.
SpendMoney<public>(Player:player, Amount:float)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]

    # Fails if player does not have enough Money.
    SourceInfo.Money >= Amount

    set PlayerInfoMap[Player] = player_info:
        Money := SourceInfo.Money - Amount
        MakePlayerInfo<constructor>(SourceInfo)

# Gets the amount of Money the player has.
GetMoney<public>(Player:player)<decides><transacts>:float=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].Money

# Players Current Prop Index
IncrementPlayersCurrentPropIndex<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]

    set PlayerInfoMap[Player] = player_info:
        PlayersCurrentPropIndex := SourceInfo.PlayersCurrentPropIndex + 1
        MakePlayerInfo<constructor>(SourceInfo)
GetPlayersCurrentPropIndex<public>(Player:player)<decides><transacts>:int=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].PlayersCurrentPropIndex

# Money Collector
IncrementMoneyCollectorLevel<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]

    set PlayerInfoMap[Player] = player_info:
        MoneyCollectorLevel := SourceInfo.MoneyCollectorLevel + 1
        MakePlayerInfo<constructor>(SourceInfo)
GetMoneyCollectorLevel<public>(Player:player)<decides><transacts>:int=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].MoneyCollectorLevel
        
# Rebirths
# Increment the players rebirth level.
IncrementPlayerRebirthLevel<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]

    set PlayerInfoMap[Player] = player_info:
        Rebirths := SourceInfo.Rebirths + 1
        MakePlayerInfo<constructor>(SourceInfo)
# Gets the players rebirth level.
GetPlayerRebirthLevel<public>(Player:player)<decides><transacts>:int=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].Rebirths
RebirthPlayer<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    SourceAchievementInfo := SourceInfo.PropsInfo
    OldArray := SourceAchievementInfo.PropBoughtArray

    var NewArray : []tycoonprops = array{}

    for (Index := 0..OldArray.Length - 1):
        if (PropInfo := OldArray[Index]):
            PropBoughtInfo := tycoonprops{
                    PropId := PropInfo.PropId,
                    IsPropBought := false
                }

            set NewArray = NewArray + array{PropBoughtInfo}

    set PlayerInfoMap[Player] = player_info:
        Money := SourceInfo.Money - SourceInfo.Money
        PlayersCurrentPropIndex := SourceInfo.PlayersCurrentPropIndex - SourceInfo.PlayersCurrentPropIndex
        MoneyCollectorLevel := SourceInfo.MoneyCollectorLevel - SourceInfo.MoneyCollectorLevel
        # HitBox Levels
        HousesHitBoxLevel := SourceInfo.HousesHitBoxLevel - SourceInfo.HousesHitBoxLevel
        FarmHitBoxLevel := SourceInfo.FarmHitBoxLevel - SourceInfo.FarmHitBoxLevel
        MarketsHitBoxLevel := SourceInfo.MarketsHitBoxLevel - SourceInfo.MarketsHitBoxLevel
        TrainingAreaHitBoxLevel := SourceInfo.TrainingAreaHitBoxLevel - SourceInfo.TrainingAreaHitBoxLevel
        TempleHitBox := SourceInfo.TempleHitBox - SourceInfo.TempleHitBox
        QuarryHitBox := SourceInfo.QuarryHitBox - SourceInfo.QuarryHitBox
        BarracksHitBox := SourceInfo.BarracksHitBox - SourceInfo.BarracksHitBox
        WoodHitBox := SourceInfo.WoodHitBox - SourceInfo.WoodHitBox
        PropsInfo := prop_info:
                PropBoughtArray := NewArray
                MakePropBoughttInfo<constructor>(SourceAchievementInfo)
        MakePlayerInfo<constructor>(SourceInfo)
RebirthPlayerOnce<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    # Fails if RebirthOnce is true
    SourceInfo.RebirthOnce = false
    set PlayerInfoMap[Player] = player_info:
        RebirthOnce := true
        MakePlayerInfo<constructor>(SourceInfo)
HasPlayerRebirthedOnce<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].RebirthOnce?
RebirthPlayerTwice<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    # Fails if RebirthTwice is true
    SourceInfo.RebirthTwice = false
    set PlayerInfoMap[Player] = player_info:
        RebirthTwice := true
        MakePlayerInfo<constructor>(SourceInfo)
HasPlayerRebirthedTwice<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].RebirthTwice?

SetPropInfoBoughtTrue<public>(Player:player, ThePropId:string)<decides><transacts>:void =
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    SourceAchievementInfo := SourceInfo.PropsInfo
    OldArray := SourceAchievementInfo.PropBoughtArray

    var FoundIndex : int = -1

    for (Index := 0..OldArray.Length - 1):
        if (PropInfo := OldArray[Index], PropInfo.PropId = ThePropId):
            set FoundIndex = Index

    if (FoundIndex >= 0):
        PropBoughtInfo := tycoonprops{
                PropId := ThePropId,
                IsPropBought := true
            }
        # Replace it in the array
        NewArray := OldArray.ReplaceElement[FoundIndex, PropBoughtInfo]

        set PlayerInfoMap[Player] = player_info:
            PropsInfo := prop_info:
                PropBoughtArray := NewArray
                MakePropBoughttInfo<constructor>(SourceAchievementInfo)
            MakePlayerInfo<constructor>(SourceInfo)

CheckIfPropIsBought<public>(Player:player, ThePropId:string)<decides><transacts>:void =
    CheckPlayerInfoForPlayer[Player]
    if (Info := PlayerInfoMap[Player]):
        PropsArray := Info.PropsInfo.PropBoughtArray
        for (Prop:PropsArray,Prop.PropId = ThePropId):
            Prop.IsPropBought?

CheckRebirth<public>(Player:player)<decides><transacts> : void =
    SourceInfo := PlayerInfoMap[Player]
    SourceAchievementInfo := SourceInfo.PropsInfo
    OldArray := SourceAchievementInfo.PropBoughtArray
    var AllBought : logic = true
    # Iterate through the array
    for (Prop : OldArray):
        if (Prop.PropId <> "Rebirth"):
            # If any prop is not bought, set AllBought to false
            if (Prop.IsPropBought = false):
                set AllBought = false
    AllBought?

# HitBoxes
# Houses
IncrementHousesHitBoxLevelLevel<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    set PlayerInfoMap[Player] = player_info:
        HousesHitBoxLevel := SourceInfo.HousesHitBoxLevel + 1
        MakePlayerInfo<constructor>(SourceInfo)
GetHousesHitBoxLevel<public>(Player:player)<decides><transacts>:int=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].HousesHitBoxLevel
# Farms
IncrementFarmHitBoxLevel<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    set PlayerInfoMap[Player] = player_info:
        FarmHitBoxLevel := SourceInfo.FarmHitBoxLevel + 1
        MakePlayerInfo<constructor>(SourceInfo)
GetFarmHitBoxLevel<public>(Player:player)<decides><transacts>:int=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].FarmHitBoxLevel
# Markets
IncrementMarketsHitBoxLevel<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    set PlayerInfoMap[Player] = player_info:
        MarketsHitBoxLevel := SourceInfo.MarketsHitBoxLevel + 1
        MakePlayerInfo<constructor>(SourceInfo)
GetMarketsHitBoxLevel<public>(Player:player)<decides><transacts>:int=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].MarketsHitBoxLevel
# Training Area
IncrementTrainingAreaHitBoxLevel<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    set PlayerInfoMap[Player] = player_info:
        TrainingAreaHitBoxLevel := SourceInfo.TrainingAreaHitBoxLevel + 1
        MakePlayerInfo<constructor>(SourceInfo)
GetTrainingAreaHitBoxLevel<public>(Player:player)<decides><transacts>:int=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].TrainingAreaHitBoxLevel
# Temple
IncrementTempleHitBoxLevel<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    set PlayerInfoMap[Player] = player_info:
        TempleHitBox := SourceInfo.TempleHitBox + 1
        MakePlayerInfo<constructor>(SourceInfo)
GetTempleHitBoxLevel<public>(Player:player)<decides><transacts>:int=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].TempleHitBox
# Quarry
IncrementQuarryHitBoxLevel<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    set PlayerInfoMap[Player] = player_info:
        QuarryHitBox := SourceInfo.QuarryHitBox + 1
        MakePlayerInfo<constructor>(SourceInfo)
GetQuarryHitBoxLevel<public>(Player:player)<decides><transacts>:int=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].QuarryHitBox
# Barracks
IncrementBarracksHitBoxLevel<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    set PlayerInfoMap[Player] = player_info:
        BarracksHitBox := SourceInfo.BarracksHitBox + 1
        MakePlayerInfo<constructor>(SourceInfo)
GetBarracksHitBoxLevel<public>(Player:player)<decides><transacts>:int=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].BarracksHitBox
# Wood
IncrementWoodHitBoxLevel<public>(Player:player)<decides><transacts>:void=
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    set PlayerInfoMap[Player] = player_info:
        WoodHitBox := SourceInfo.WoodHitBox + 1
        MakePlayerInfo<constructor>(SourceInfo)
GetWoodHitBoxLevel<public>(Player:player)<decides><transacts>:int=
    CheckPlayerInfoForPlayer[Player]
    PlayerInfoMap[Player].WoodHitBox

# Tutorial
SetTutorialInfoBoughtTrue<public>(Player:player, ThePropId:string)<decides><transacts>:void =
    CheckPlayerInfoForPlayer[Player]
    SourceInfo := PlayerInfoMap[Player]
    SourceAchievementInfo := SourceInfo.Tutorial
    OldArray := SourceAchievementInfo.TutorialInforArray

    var FoundIndex : int = -1

    for (Index := 0..OldArray.Length - 1):
        if (PropInfo := OldArray[Index], PropInfo.StepId = ThePropId):
            set FoundIndex = Index

    if (FoundIndex >= 0):
        TutorialInfo := tutorial_info_struct{
                StepId := ThePropId,
                IsPropBought := true
            }
        # Replace it in the array
        NewArray := OldArray.ReplaceElement[FoundIndex, TutorialInfo]

        set PlayerInfoMap[Player] = player_info:
            Tutorial := tutorial_info:
                TutorialInforArray := NewArray
                MakeTutorialInfo<constructor>(SourceAchievementInfo)
            MakePlayerInfo<constructor>(SourceInfo)
CheckIfTutorialIsCompleted<public>(Player:player, ThePropId:string)<decides><transacts>:void =
    CheckPlayerInfoForPlayer[Player]
    if (Info := PlayerInfoMap[Player]):
        PropsArray := Info.Tutorial.TutorialInforArray
        for (Prop:PropsArray,Prop.StepId = ThePropId):
            Prop.IsPropBought?

    
