import QtQuick 1.0
import "Reach/ReachConnection.js" as ReachConnection
import "Reach/ScitonIDs.js" as ScitonIDs

Item {
    property int screenID : ScitonIDs.ScitonScreenIDs.ScreenID_ClearScan_YAG_1064_nm

    property string trigger_v : '  ';

    // Fluence
    property string fluence_t : trigger_v;
    signal fluence_tChange(string value)
    onFluence_tChanged: {
        if (fluence_t != trigger_v)
        {
            try {
                var fluence_v = parseInt(fluence_t);
                if (fluence_v == fluence)
                    ackFluenceChange();
                else
                    fluence = fluence_v;
            }
            catch (e) {
            }
            fluence_t = trigger_v;
        }
    }
    property int fluence : 50;
    signal fluenceChange(int value)
    function incrementFluence(repeat) {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_IncrementFluence, repeat);
    }
    function decrementFluence(repeat) {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_DecrementFluence, repeat);
    }
    function ackFluenceChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_Fluence, fluence);
    }
    
    // Width
    property string pulsewidth_t : trigger_v;
    signal pulsewidth_tChange(string value)
    onPulsewidth_tChanged: {
        if (pulsewidth_t != trigger_v)
        {
            try {
                var pulsewidth_v = parseInt(pulsewidth_t);
                if (pulsewidth_v == pulsewidth)
                    ackPulsewidthChange();
                else
                    pulsewidth = pulsewidth_v;
            }
            catch (e) {
            }
            pulsewidth_t = trigger_v;
        }
    }
    property int pulsewidth : 20;
    signal pulsewidthChange(int value)
    function incrementWidth(repeat) {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_IncrementWidth, repeat);
    }
    function decrementWidth(repeat) {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_DecrementWidth, repeat);
    }
    function ackPulsewidthChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_Width, pulsewidth);
    }

    // Rate
    property string rate_t : trigger_v;
    signal rate_tChange(string value)
    onRate_tChanged: {
        if (rate_t != trigger_v)
        {
            try {
                var rate_v = parseFloat(rate_t);
                if (rate_v == rate)
                    ackRateChange();
                else
                    rate = rate_v;
            }
            catch (e) {
            }
            rate_t = trigger_v;
        }
    }
    property string formattedRate : Number(s99vm.rate).toFixed(1)
    property real rate : 5.8;
    signal rateChange(real value)
    function incrementRate(repeat) {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_IncrementRate, repeat);
    }
    function decrementRate(repeat) {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_DecrementRate, repeat);
    }
    function ackRateChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_Rate, rate);
    }

    // X Size
    property string xsize_t : trigger_v;
    signal xsize_tChange(string value)
    onXsize_tChanged: {
        if (xsize_t != trigger_v)
        {
            try {
                var xsize_v = parseInt(xsize_t);
                if (xsize_v == xsize)
                    ackXSizeChange();
                else
                    xsize = xsize_v;
            }
            catch (e) {
            }
            xsize_t = trigger_v;
        }
    }
    property int xsize : 3;
    signal xsizeChange(int value)
    function incrementXSize(repeat) {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_IncrementXSize, repeat);
    }
    function decrementXSize(repeat) {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_DecrementXSize, repeat);
    }
    function ackXSizeChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_XSize, xsize);
    }

    // Y Size
    property string ysize_t : trigger_v;
    signal ysize_tChange(string value)
    onYsize_tChanged: {
        if (ysize_t != trigger_v)
        {
            try {
                var ysize_v = parseInt(ysize_t);
                if (ysize_v == ysize)
                    ackYSizeChange();
                else
                    ysize = ysize_v;
            }
            catch (e) {
            }
            ysize_t = trigger_v;
        }
    }
    property int ysize : 3;
    signal ysizeChange(int value)
    function incrementYSize(repeat) {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_IncrementYSize, repeat);
    }
    function decrementYSize(repeat) {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_DecrementYSize, repeat);
    }
    function ackYSizeChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_YSize, ysize);
    }

    // Offset
    property string offset_t : trigger_v;
    signal offset_tChange(string value)
    onOffset_tChanged: {
        if (offset_t != trigger_v)
        {
            try {
                var offset_v = parseInt(offset_t);
                if (offset_v == offset)
                    ackOffsetChange();
                else
                    offset = offset_v;
            }
            catch (e) {
            }
            offset_t = trigger_v;
        }
    }
    property int offset : ScitonIDs.ScitonEventIDs.EventValue_Offset1;
    signal offsetChange(int value)
    function setOffset() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_SetOffset , ScitonIDs.ScitonEventIDs.EventValue_None);
    }
    function ackOffsetChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_Offset, offset);
    }

    // Repeat
    property string repeat_t : trigger_v;
    signal repeat_tChange(string value)
    onRepeat_tChanged: {
        if (repeat_t != trigger_v)
        {
            try {
                var repeat_v = parseInt(repeat_t);
                if (repeat_v == repeat)
                    ackRepeatChange();
                else
                    repeat = repeat_v;
            }
            catch (e) {
            }
            repeat_t = trigger_v;
        }
    }
    property int repeat : 0;
    signal repeatChange(int value)
    function repeatSelection() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_RepeatSelection ,ScitonIDs.ScitonEventIDs.EventValue_None);
    }
    function ackRepeatChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_Repeat, repeat);
    }

    // Skin Type
    property string skinType_t : trigger_v;
    signal skinType_tChange(string value)
    onSkinType_tChanged: {
        if (skinType_t != trigger_v)
        {
            try {
                var skinType_v = parseInt(skinType_t);
                if (skinType_v == skinType)
                    ackSkinTypeChange();
                else
                    skinType = skinType_v;
            }
            catch (e) {
            }
            skinType_t = trigger_v;
        }
    }
    property int skinType : 0;
    signal skinTypeChange(int value)
    function incrementSkinType() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_IncrementSkinType ,ScitonIDs.ScitonEventIDs.EventValue_None);
    }
    function decrementSkinType() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_DecrementSkinType ,ScitonIDs.ScitonEventIDs.EventValue_None);
    }
    function ackSkinTypeChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_SkinType, skinType);
    }

    // Hair Color
    property string hairColor_t : trigger_v;
    signal hairColor_tChange(string value)
    onHairColor_tChanged: {
        if (hairColor_t != trigger_v)
        {
            try {
                var hairColor_v = parseInt(hairColor_t);
                if (hairColor_v == hairColor)
                    ackHairColorChange();
                else
                    hairColor = hairColor_v;
            }
            catch (e) {
            }
            hairColor_t = trigger_v;
        }
    }
    property int hairColor : ScitonIDs.ScitonEventIDs.EventValue_HairColorBlack;
    signal hairColorChange(int value)
    function setHairColor() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_SetHairColor ,ScitonIDs.ScitonEventIDs.EventValue_None);
    }
    function ackHairColorChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_HairColor, hairColor);
    }

    // Hair Type
    property string hairType_t : trigger_v;
    signal hairType_tChange(string value)
    onHairType_tChanged: {
        if (hairType_t != trigger_v)
        {
            try {
                var hairType_v = parseInt(hairType_t);
                if (hairType_v == hairType)
                    ackHairTypeChange();
                else
                    hairType = hairType_v;
            }
            catch (e) {
            }
            hairType_t = trigger_v;
        }
    }
    property int hairType : ScitonIDs.ScitonEventIDs.EventValue_HairTypeFine;
    signal hairTypeChange(int value)
    function setHairType() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_SetHairType, ScitonIDs.ScitonEventIDs.EventValue_None);
    }
    function ackHairTypeChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_HairType, hairType);
    }

    // Back button
    property string backEnabled_t : trigger_v;
    signal backEnabled_tChange(string value)
    onBackEnabled_tChanged: {
        if (backEnabled_t != trigger_v)
        {
            try {
                var backEnabled_v = parseInt(backEnabled_t);
                if (backEnabled_v == backEnabled)
                    ackBackEnabledChange();
                else
                    backEnabled = backEnabled_v;
            }
            catch (e) {
            }
            backEnabled_t = trigger_v;
        }
    }
    property int backEnabled : 0
    signal backEnabledChange(int value)
    function backSelection() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_BackSelection ,ScitonIDs.ScitonEventIDs.EventValue_None);
    }
    function ackBackEnabledChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_BackButtonState, backEnabled);
    }

    // Standby/Ready
    property string inReadyMode_t : trigger_v;
    signal inReadyMode_tChange(string value)
    onInReadyMode_tChanged: {
        if (inReadyMode_t != trigger_v)
        {
            try {
                var inReadyMode_v = parseInt(inReadyMode_t);
                if (inReadyMode_v == inReadyMode)
                    ackInReadyModeChange();
                else
                    inReadyMode = inReadyMode_v;
            }
            catch (e) {
            }
            inReadyMode_t = trigger_v;
        }
    }
    property int inReadyMode: 0;
    signal inReadyModeChange(int value)
    function standbyReadySelection() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_StandbyReadySelection ,ScitonIDs.ScitonEventIDs.EventValue_None);
    }
    function ackInReadyModeChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_ReadyStandbyState, inReadyMode);
    }

    // Treating
    property string treating_t : trigger_v;
    signal treating_tChange(string value)
    onTreating_tChanged: {
        if (treating_t != trigger_v)
        {
            try {
                var treating_v = parseInt(treating_t);
                if (treating_v == treating)
                    ackTreatingChange();
                else
                    treating = treating_v;
            }
            catch (e) {
            }
            treating_t = trigger_v;
        }
    }
    property int treating: 0;
    signal treatingChange(int value)
    function ackTreatingChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_LaserActive, treating);
    }

    // Counter reset button
    property string counterResetEnabled_t : trigger_v;
    signal counterResetEnabled_tChange(string value)
    onCounterResetEnabled_tChanged: {
        if (counterResetEnabled_t != trigger_v)
        {
            try {
                var counterResetEnabled_v = parseInt(counterResetEnabled_t);
                if (counterResetEnabled_v == counterResetEnabled)
                    ackCounterResetEnabledChange();
                else
                    counterResetEnabled = counterResetEnabled_v;
            }
            catch (e) {
            }
            counterResetEnabled_t = trigger_v;
        }
    }
    property int counterResetEnabled : 0;
    signal counterResetEnabledChange(int value)
    function counterResetSelection() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_CounterResetSelection ,ScitonIDs.ScitonEventIDs.EventValue_None);
    }
    function ackCounterResetEnabledChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_CounterResetState, counterResetEnabled);
    }

    // Counter
    property string counter_t : trigger_v;
    signal counter_tChange(string value)
    onCounter_tChanged: {
        if (counter_t != trigger_v)
        {
            try {
                var counter_v = parseInt(counter_t);
                if (counter_v == counter)
                    ackCounterChange();
                else
                    counter = counter_v;
            }
            catch (e) {
            }
            counter_t = trigger_v;
        }
    }
    property int counter : 0;
    signal counterChange(int value)
    function ackCounterChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_CounterSetting, counter);
    }

    // Message
    property string message_t : trigger_v;
    signal message_tChange(string value)
    onMessage_tChanged: {
        if (message_t != trigger_v)
        {
            if (message_t == message)
                ackMessageChange();
            else
                message = message_t;
            message_t = trigger_v;
        }
    }
    property string message;
    signal messageChange(string value)
    function ackMessageChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_Message, message);
    }

    // Back button visibility
    property string backVisible_t : trigger_v;
    signal backVisible_tChange(string value)
    onBackVisible_tChanged: {
        if (backVisible_t != trigger_v)
        {
            try {
                var backVisible_v = parseInt(backVisible_t);
                if (backVisible_v == backVisible)
                    ackBackVisibleChange();
                else
                    backVisible = backVisible_v;
            }
            catch (e) {
            }
            backVisible_t = trigger_v;
        }
    }
    property int backVisible : 1
    signal backVisibleChange(int value)
    function ackBackVisibleChange() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_BackVisible, backVisible);
    }

    function testEvent() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_Test ,ScitonIDs.ScitonEventIDs.EventValue_Test);
    }

    function sendEventToMCU(eventID, eventValue)
    {
        if(typeof ReachConnection.ReachConnection.s99vm == 'undefined'){
            ReachConnection.ReachConnection.s99vm = this;
        }
        ReachConnection.ReachConnection.sendEventToMCU(screenID, eventID, eventValue);
    }

    function sendAcknowledgeToMCU(propertyID, propertyValue)
    {
        if(typeof ReachConnection.ReachConnection.s99vm == 'undefined'){
            ReachConnection.ReachConnection.s99vm = this;
        }
        ReachConnection.ReachConnection.sendAcknowledgeToMCU(screenID, propertyID, propertyValue);
    }
}
