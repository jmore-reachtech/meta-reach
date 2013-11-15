import QtQuick 1.0
import "Reach/ReachConnection.js" as ReachConnection
import "Reach/ScitonIDs.js" as ScitonIDs

Item {
    property int screenID : ScitonIDs.ScitonScreenIDs.ScreenID_MainView

    property string trigger_v : '  ';

    // s0
    property string s0_t : trigger_v;
    signal s0_tChange(string value)
    onS0_tChanged: {
        if (s0_t != trigger_v)
        {
            try {
                var s0_v = parseInt(s0_t);
                if (s0_v == s0)
                    ackS0Change();
                else
                    s0 = s0_v;
            }
            catch (e) {
            }
            s0_t = trigger_v;
        }
    }
    property int s0 : 0;
    signal s0Change(int value)
    function ackS0Change() {
        this.sendScreenAcknowledgeToMCU(ScitonIDs.ScitonScreenIDs.ScreenID_Popup, s0);
    }

    // s1
    property string s1_t : trigger_v;
    signal s1_tChange(string value)
    onS1_tChanged: {
        if (s1_t != trigger_v)
        {
            try {
                var s1_v = parseInt(s1_t);
                if (s1_v == s1)
                    ackS1Change();
                else
                    s1 = s1_v;
            }
            catch (e) {
            }
            s1_t = trigger_v;
        }
    }
    property int s1 : 1;
    signal s1Change(int value)
    function ackS1Change() {
        this.sendScreenAcknowledgeToMCU(ScitonIDs.ScitonScreenIDs.ScreenID_StartMenu, s1);
    }

    // s99
    property string s99_t : trigger_v;
    signal s99_tChange(string value)
    onS99_tChanged: {
        if (s99_t != trigger_v)
        {
            try {
                var s99_v = parseInt(s99_t);
                if (s99_v == s99)
                    ackS99Change();
                else
                    s99 = s99_v;
            }
            catch (e) {
            }
            s99_t = trigger_v;
        }
    }
    property int s99 : 0;
    signal s99Change(int value)
    function ackS99Change() {
        this.sendScreenAcknowledgeToMCU(ScitonIDs.ScitonScreenIDs.ScreenID_ClearScan_YAG_1064_nm, s99);
    }

    function sendEventToMCU(eventID, eventValue)
    {
        if(typeof ReachConnection.ReachConnection.mainvm == 'undefined'){
            ReachConnection.ReachConnection.mainvm = this;
        }
        ReachConnection.ReachConnection.sendEventToMCU(screenID, eventID, eventValue);
    }

    function sendScreenAcknowledgeToMCU(propertyID, propertyValue)
    {
        if(typeof ReachConnection.ReachConnection.mainvm == 'undefined'){
            ReachConnection.ReachConnection.mainvm = this;
        }
        ReachConnection.ReachConnection.sendScreenAcknowledgeToMCU(screenID, propertyID, propertyValue);
    }
}
