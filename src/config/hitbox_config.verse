using { /Verse.org/Simulation }
using { Persistence }

# Houseses Area HitBox
GetHousesHitboxLevelHitAmounts<public>()<transacts>:[]float =
        array{10.0, 20.0, 40.0, 80.0}
GetHousesHitboxPriceAmounts<public>()<transacts>:[]float =
        array{500.0, 1000.0, 2000.0}
# Farm Area HitBox
GetFarmHitboxLevelHitAmounts<public>()<transacts>:[]float =
        array{160.0, 320.0, 640.0, 1280.0}
GetFarmHitboxPriceAmounts<public>()<transacts>:[]float =
        array{6000.0, 18000.0, 54000.0}
# Markets Area HitBox
GetMarketsHitboxLevelHitAmounts<public>()<transacts>:[]float =
        array{2560.0, 5120.0, 10240.0, 20480.0}
GetMarketsHitboxPriceAmounts<public>()<transacts>:[]float =
        array{162000.0, 486000.0, 1458000.0}
# Training Grounds Area HitBox
GetTrainingGroundsHitboxLevelHitAmounts<public>()<transacts>:[]float =
        array{34000.0, 59000.0, 100600.0, 171000.0}
GetTrainingGroundsHitboxPriceAmounts<public>()<transacts>:[]float =
        array{4374000.0, 13122000.0, 39366000.0}
# Temple HitBox
GetTempleHitboxLevelHitAmounts<public>()<transacts>:[]float =
        array{290000.0, 494000.0, 840000.0, 1428000.0}
GetTempleHitboxPriceAmounts<public>()<transacts>:[]float =
        array{118098000.0, 354294000.0, 1062882000.0}
# Quarry HitBox
GetQuarryHitboxLevelHitAmounts<public>()<transacts>:[]float =
        array{2428000.0, 4128000.0, 7018000.0, 11932000.0}
GetQuarryHitboxPriceAmounts<public>()<transacts>:[]float =
        array{3188646000.0, 9565938000.0, 28697814000.0}
# Barracks HitBox
GetBarracksHitboxLevelHitAmounts<public>()<transacts>:[]float =
        array{20284000.0, 34483000.0, 58622000.0, 99658000.0}
GetBarracksHitboxPriceAmounts<public>()<transacts>:[]float =
        array{86093442000.0, 258280326000.0, 774840978000.0}
# Wood HitBox
GetWoodHitboxLevelHitAmounts<public>()<transacts>:[]float =
        array{169418000.0, 288011000.0, 489620000.0, 832354000.0}
GetWoodHitboxPriceAmounts<public>()<transacts>:[]float =
        array{2324522934000.0, 6973568802000.0, 20920706406000.0}

# GetHousesHitboxLevelHitAmounts
GetPlayerHousesHitBoxHitAmount<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetHousesHitBoxLevel[Player]
        PlayersHitAmounts := GetHousesHitboxLevelHitAmounts()
        PlayerIndex := Min(PlayerDamageLevel, PlayersHitAmounts.Length-1)
        PlayersHitAmounts[PlayerIndex]
GetPlayerHousesHitBoxPriceAmounts<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetHousesHitBoxLevel[Player]
        HitAmountPrices := GetHousesHitboxPriceAmounts()
        PlayerIndex := Min(PlayerDamageLevel, HitAmountPrices.Length-1)
        HitAmountPrices[PlayerIndex]
# FarmHitboxLevelHitAmounts
GetPlayerFarmHitBoxHitAmount<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetFarmHitBoxLevel[Player]
        PlayersHitAmounts := GetFarmHitboxLevelHitAmounts()
        PlayerIndex := Min(PlayerDamageLevel, PlayersHitAmounts.Length-1)
        PlayersHitAmounts[PlayerIndex]
GetPlayerFarmHitBoxPriceAmounts<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetFarmHitBoxLevel[Player]
        HitAmountPrices := GetFarmHitboxPriceAmounts()
        PlayerIndex := Min(PlayerDamageLevel, HitAmountPrices.Length-1)
        HitAmountPrices[PlayerIndex]
# MarketsHitboxLevelHitAmounts
GetPlayerMarketsHitBoxHitAmount<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetMarketsHitBoxLevel[Player]
        PlayersHitAmounts := GetMarketsHitboxLevelHitAmounts()
        PlayerIndex := Min(PlayerDamageLevel, PlayersHitAmounts.Length-1)
        PlayersHitAmounts[PlayerIndex]
GetPlayerMarketsHitBoxPriceAmounts<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetMarketsHitBoxLevel[Player]
        HitAmountPrices := GetMarketsHitboxPriceAmounts()
        PlayerIndex := Min(PlayerDamageLevel, HitAmountPrices.Length-1)
        HitAmountPrices[PlayerIndex]
# TrainingGroundsHitboxLevelHitAmounts
GetPlayerTrainingGroundsHitBoxHitAmount<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetTrainingAreaHitBoxLevel[Player]
        PlayersHitAmounts := GetTrainingGroundsHitboxLevelHitAmounts()
        PlayerIndex := Min(PlayerDamageLevel, PlayersHitAmounts.Length-1)
        PlayersHitAmounts[PlayerIndex]
GetPlayerTrainingGroundsHitBoxPriceAmounts<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetTrainingAreaHitBoxLevel[Player]
        HitAmountPrices := GetTrainingGroundsHitboxPriceAmounts()
        PlayerIndex := Min(PlayerDamageLevel, HitAmountPrices.Length-1)
        HitAmountPrices[PlayerIndex]
# TempleHitboxLevelHitAmounts
GetTempleHitBoxHitAmount<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetTempleHitBoxLevel[Player]
        PlayersHitAmounts := GetTempleHitboxLevelHitAmounts()
        PlayerIndex := Min(PlayerDamageLevel, PlayersHitAmounts.Length-1)
        PlayersHitAmounts[PlayerIndex]
GetTempleHitBoxPriceAmounts<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetTempleHitBoxLevel[Player]
        HitAmountPrices := GetTempleHitboxPriceAmounts()
        PlayerIndex := Min(PlayerDamageLevel, HitAmountPrices.Length-1)
        HitAmountPrices[PlayerIndex]
# QuarryHitboxLevelHitAmounts
GetQuarryHitBoxHitAmount<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetQuarryHitBoxLevel[Player]
        PlayersHitAmounts := GetBarracksHitboxLevelHitAmounts()
        PlayerIndex := Min(PlayerDamageLevel, PlayersHitAmounts.Length-1)
        PlayersHitAmounts[PlayerIndex]
GetQuarryHitBoxPriceAmounts<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetQuarryHitBoxLevel[Player]
        HitAmountPrices := GetQuarryHitboxPriceAmounts()
        PlayerIndex := Min(PlayerDamageLevel, HitAmountPrices.Length-1)
        HitAmountPrices[PlayerIndex]
# BarracksHitboxLevelHitAmounts
GetBarracksHitBoxHitAmount<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetBarracksHitBoxLevel[Player]     
        PlayersHitAmounts := GetBarracksHitboxLevelHitAmounts()
        PlayerIndex := Min(PlayerDamageLevel, PlayersHitAmounts.Length-1)
        PlayersHitAmounts[PlayerIndex]
GetBarracksHitBoxPriceAmounts<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetBarracksHitBoxLevel[Player]
        HitAmountPrices := GetBarracksHitboxPriceAmounts()
        PlayerIndex := Min(PlayerDamageLevel, HitAmountPrices.Length-1)
        HitAmountPrices[PlayerIndex]
# WoodHitboxLevelHitAmounts
GetWoodHitBoxHitAmount<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetWoodHitBoxLevel[Player]
        PlayersHitAmounts := GetWoodHitboxLevelHitAmounts()
        PlayerIndex := Min(PlayerDamageLevel, PlayersHitAmounts.Length-1)
        PlayersHitAmounts[PlayerIndex]
GetWoodHitBoxPriceAmounts<public>(Player:player)<decides><transacts>:float=
        PlayerDamageLevel := GetWoodHitBoxLevel[Player]
        HitAmountPrices := GetWoodHitboxPriceAmounts()
        PlayerIndex := Min(PlayerDamageLevel, HitAmountPrices.Length-1)
        HitAmountPrices[PlayerIndex]

# Money Collector
GetMoneyCollectorAmounts<public>()<transacts>:[]float =
        array{
                # Houses
                0.0, 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 
                11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0, 
                21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0,
                # Farm
                29.0, 30.0, 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0,
                41.0, 42.0, 43.0,
                # Markets
                61.0, 72.0, 83.0, 94.0, 105.0, 116.0, 127.0, 138.0, 149.0, 160.0, 171.0, 182.0,
                # Training Area
                194.0, 208.0, 222.0, 236.0, 250.0, 264.0, 278.0, 292.0, 306.0, 320.0, 334.0, 348.0,
                362.0, 376.0, 390.0, 404.0,
                # Temples
                434.0, 464.0, 494.0, 524.0, 554.0, 584.0, 614.0, 644.0,
                # WindMills
                699.0, 754.0, 809.0, 864.0, 919.0, 974.0, 1029.0, 
                # Quarry
                1429.0, 1829.0, 2229.0, 2629.0, 3029.0, 3429.0, 3829.0, 4229.0, 4629.0, 5029.0, 5829.0, 6629.0,
                7429.0, 8229.0, 9029.0, 9829.0, 11329.0, 12829.0, 14329.0, 15829.0, 17329.0,
                # Barracks
                21329.0, 25329.0, 29329.0, 33329.0, 39329.0, 45329.0, 51329.0,
                # Wood
                108658.0, 120658.0, 132658.0, 144658.0, 156658.0, 168658.0, 180658.0, 205880.0,
                240880.0, 275880.0, 325880.0, 385880.0,
                # Castle
                485880.0, 785000.0
        }
GetMoneyCollectorAmounts<public>(Player:player)<decides><transacts>:float=
        PlayerMoneyCollectorLevel := GetMoneyCollectorLevel[Player]
        MoneyCollectorAmounts := GetMoneyCollectorAmounts()
        PlayerIndex := Min(PlayerMoneyCollectorLevel, MoneyCollectorAmounts.Length-1)
        MoneyCollectorAmounts[PlayerIndex]


            
