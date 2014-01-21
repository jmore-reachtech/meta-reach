var ScitonScreenIDs = {
    ScreenID_Popup : 0,
    ScreenID_StartMenu : 1,
    //ScreenID_Splash : 1,
    ScreenID_SelfTest : 2,
    ScreenID_JouleMain : 3,
    ScreenID_ARMApplication : 4,
    ScreenID_FiberApplication : 5,
    ScreenID_BBLApplication : 6,
    ScreenID_2940Application : 7,

    ScreenID_ClearScan_YAG_1064_nm : 99,

    ScreenID_MainView : 1000
}

var ScitonEventIDs = {
    EventID_Error : 0,

        EventValue_None : 0,

    EventID_IncrementFluence : 1,
    EventID_DecrementFluence : 2,
    EventID_IncrementWidth : 3,
    EventID_DecrementWidth : 4,
    EventID_IncrementRate : 5,
    EventID_DecrementRate : 6,
    EventID_IncrementXSize : 7,
    EventID_DecrementXSize : 8,
    EventID_IncrementYSize : 9,
    EventID_DecrementYSize : 10,
    EventID_IncrementSkinType : 11,
    EventID_DecrementSkinType : 12,
    EventID_SetHairColor : 13,

        EventValue_HairColorBlonde: 1,
        EventValue_HairColorBrown: 2,
        EventValue_HairColorBlack: 3,

    EventID_SetHairType : 14,

        EventValue_HairTypeFine: 1,
        EventValue_HairTypeMedium: 2,
        EventValue_HairTypeCoarse: 3,

    EventID_SetOffset : 15,

        EventValue_Offset1: 0,
        EventValue_Offset2: 1,
        EventValue_Offset3: 2,
        EventValue_Offset4: 3,

    EventID_RepeatSelection : 16,
    EventID_BackSelection : 17,
    EventID_StandbyReadySelection : 18,
    EventID_CounterResetSelection : 19,
    EventID_ProceedToTestScreen : 100,
    EventID_Test : 1000,
        EventValue_Test: 1234

}

var ScitonPropertyIDs = {
    PropertyID_Error : 0,
    PropertyID_Fluence : 1,
    PropertyID_Width : 2,
    PropertyID_Rate : 3,
    PropertyID_XSize : 4,
    PropertyID_YSize : 5,
    PropertyID_SkinType : 6,
    PropertyID_HairColor : 7,
    PropertyID_HairType : 8,
    PropertyID_Offset : 9,
    PropertyID_Repeat : 10,
    PropertyID_BackButtonState : 11,
    PropertyID_ReadyStandbyState : 12,
    PropertyID_CounterResetState : 13,
    PropertyID_CounterSetting : 14,
    PropertyID_LaserActive : 15,
    PropertyID_Message : 16,
    PropertyID_BackVisible : 100,
    PropertyID_PopupMessage1 : 101,
    PropertyID_PopupMessage2 : 102,
    PropertyID_PopupMessage3 : 103,
    PropertyID_PopupMessage4 : 104,
    PropertyID_PopupMessage5 : 105
}
