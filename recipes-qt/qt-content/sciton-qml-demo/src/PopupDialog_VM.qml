import QtQuick 1.0
import "Reach/ReachConnection.js" as ReachConnection
import "Reach/ScitonIDs.js" as ScitonIDs

Item {
    property int screenID : ScitonIDs.ScitonScreenIDs.ScreenID_Popup

    property string trigger_v : '  ';

    // Popup Message 1
    property string popupMessage1_t : trigger_v;
    signal popupMessage1_tChange(string value)
    onPopupMessage1_tChanged: {
        if (popupMessage1_t != trigger_v)
        {
            if (popupMessage1_t == popupMessage1)
                ackPopupMessage1Change();
            else
                popupMessage1 = popupMessage1_t;
            popupMessage1_t = trigger_v;
        }
    }
    property string popupMessage1;
    signal popupMessage1Change(string value)
    function ackPopupMessage1Change() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_PopupMessage1, popupMessage1);
    }

    // Popup Message 2
    property string popupMessage2_t : trigger_v;
    signal popupMessage2_tChange(string value)
    onPopupMessage2_tChanged: {
        if (popupMessage2_t != trigger_v)
        {
            if (popupMessage2_t == popupMessage2)
                ackPopupMessage2Change();
            else
                popupMessage2 = popupMessage2_t;
            popupMessage2_t = trigger_v;
        }
    }
    property string popupMessage2;
    signal popupMessage2Change(string value)
    function ackPopupMessage2Change() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_PopupMessage2, popupMessage2);
    }

    // Popup Message 3
    property string popupMessage3_t : trigger_v;
    signal popupMessage3_tChange(string value)
    onPopupMessage3_tChanged: {
        if (popupMessage3_t != trigger_v)
        {
            if (popupMessage3_t == popupMessage3)
                ackPopupMessage3Change();
            else
                popupMessage3 = popupMessage3_t;
            popupMessage3_t = trigger_v;
        }
    }
    property string popupMessage3;
    signal popupMessage3Change(string value)
    function ackPopupMessage3Change() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_PopupMessage3, popupMessage3);
    }

    // Popup Message 4
    property string popupMessage4_t : trigger_v;
    signal popupMessage4_tChange(string value)
    onPopupMessage4_tChanged: {
        if (popupMessage4_t != trigger_v)
        {
            if (popupMessage4_t == popupMessage4)
                ackPopupMessage4Change();
            else
                popupMessage4 = popupMessage4_t;
            popupMessage4_t = trigger_v;
        }
    }
    property string popupMessage4;
    signal popupMessage4Change(string value)
    function ackPopupMessage4Change() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_PopupMessage4, popupMessage4);
    }

    // Popup Message 5
    property string popupMessage5_t : trigger_v;
    signal popupMessage5_tChange(string value)
    onPopupMessage5_tChanged: {
        if (popupMessage5_t != trigger_v)
        {
            if (popupMessage5_t == popupMessage5)
                ackPopupMessage5Change();
            else
                popupMessage5 = popupMessage5_t;
            popupMessage5_t = trigger_v;
        }
    }
    property string popupMessage5;
    signal popupMessage5Change(string value)
    function ackPopupMessage5Change() {
        this.sendAcknowledgeToMCU(ScitonIDs.ScitonPropertyIDs.PropertyID_PopupMessage5, popupMessage5);
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

    function backSelection() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_BackSelection ,ScitonIDs.ScitonEventIDs.EventValue_None);
    }

    function sendEventToMCU(eventID, eventValue)
    {
        if(typeof ReachConnection.ReachConnection.mainvm == 'undefined'){
            ReachConnection.ReachConnection.mainvm = this;
        }
        ReachConnection.ReachConnection.sendEventToMCU(screenID, eventID, eventValue);
    }

    function sendAcknowledgeToMCU(propertyID, propertyValue)
    {
        if(typeof ReachConnection.ReachConnection.mainvm == 'undefined'){
            ReachConnection.ReachConnection.mainvm = this;
        }
        ReachConnection.ReachConnection.sendAcknowledgeToMCU(screenID, propertyID, propertyValue);
    }
}
