import QtQuick 1.0
import "Reach/ReachConnection.js" as ReachConnection
import "Reach/ScitonIDs.js" as ScitonIDs

Item {
    property int screenID : ScitonIDs.ScitonScreenIDs.ScreenID_StartMenu

    function proceedToTestScreen() {
        this.sendEventToMCU(ScitonIDs.ScitonEventIDs.EventID_ProceedToTestScreen, ScitonIDs.ScitonEventIDs.EventValue_None);
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
