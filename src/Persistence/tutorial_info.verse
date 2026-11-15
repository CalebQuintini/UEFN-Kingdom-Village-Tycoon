tutorial_info_struct := struct<persistable>:
    StepId : string = ""
    IsPropBought : logic = false

tutorial_info := class<final><persistable>:
    TutorialInforArray:[]tutorial_info_struct =
        array{
            tutorial_info_struct{StepId := "HousesHitBox", IsPropBought := false},
            tutorial_info_struct{StepId := "MoneyCollector", IsPropBought := false},
            tutorial_info_struct{StepId := "WatchTower1", IsPropBought := false},
            tutorial_info_struct{StepId := "WatchTower2", IsPropBought := false},
            tutorial_info_struct{StepId := "WatchTower3", IsPropBought := false},
            tutorial_info_struct{StepId := "WatchTower4", IsPropBought := false},
            tutorial_info_struct{StepId := "ArmoryStand1", IsPropBought := false}
        }

MakeTutorialInfo<constructor>(Src:tutorial_info)<transacts> := tutorial_info:
    TutorialInforArray := Src.TutorialInforArray
    
