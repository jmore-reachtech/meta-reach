Qt.include("ScitonIDs.js")

var ReachConnection = {
    updateValue : function (obj, prop, value) {
         if(typeof connection == 'undefined'){
             console.log(qsTr("SIMULATED connection.updateValue('%1', '%2', '%3')").arg(obj).arg(prop).arg(value));
             this.simulateUpdateValue(obj, prop, value);
         }
         else
         {
             console.log(qsTr("connection.updateValue('%1', '%2', '%3')").arg(obj).arg(prop).arg(value));
             connection.updateValue(obj, prop, value);
         }
    },
    sendEventToMCU : function (screenID, eventID, eventValue) {
        console.log(qsTr("Sending event to MCU (screenID=%1 eventID=%2 eventValue=%3)").arg(screenID).arg(eventID).arg(eventValue));
        this.updateValue('S' + screenID, 'E' + eventID, eventValue);
    },
    sendAcknowledgeToMCU : function (screenID, propertyID, propertyValue) {
        console.log(qsTr("Sending acknowledge to MCU (screenID=%1 propertyID=%2 propertyValue=%3)").arg(screenID).arg(propertyID).arg(propertyValue));
        this.updateValue('S' + screenID, 'P' + propertyID, propertyValue);
    },
    sendScreenAcknowledgeToMCU : function (screenID, propertyID, propertyValue) {
        console.log(qsTr("Sending screen acknowledge to MCU (screenID=%1 propertyID=%2 propertyValue=%3)").arg(screenID).arg(propertyID).arg(propertyValue));
        this.updateValue('S' + screenID, 'S' + propertyID, propertyValue);
    },
    simulateUpdateValue : function (obj, prop, value) {
          if (obj == 'S' + ScitonScreenIDs.ScreenID_ClearScan_YAG_1064_nm)
          {
              var vm = this.s99vm;

              if (prop == 'E' + ScitonEventIDs.EventID_IncrementFluence)
              {
                  if (vm.fluence < 160)
                  {
                      //vm.fluence++;
                      vm.fluence_t = '' + (vm.fluence + 1);
                      vm.skinType = 0;
                  }
              }

              if (prop == 'E' + ScitonEventIDs.EventID_DecrementFluence)
              {
                  if (vm.fluence > 10)
                  {
                      //vm.fluence--;
                      vm.fluence_t = '' + (vm.fluence - 1);
                      vm.skinType = 0;
                  }
              }

              if (prop == 'E' + ScitonEventIDs.EventID_IncrementWidth)
              {
                  if (vm.pulsewidth < 200)
                  {
                      vm.pulsewidth++;
                      vm.skinType = 0;
                  }
              }
              if (prop == 'E' + ScitonEventIDs.EventID_DecrementWidth)
              {
                  if (vm.pulsewidth > 2)
                  {
                      vm.pulsewidth--;
                      vm.skinType = 0;
                  }
              }

              if (prop == 'E' + ScitonEventIDs.EventID_IncrementRate)
              {
                  if (vm.rate <= 9.9)
                  {
                      vm.rate += 0.1;
                  }
              }
              if (prop == 'E' + ScitonEventIDs.EventID_DecrementRate)
              {
                  if (vm.rate >= 1.1)
                  {
                      vm.rate -= 0.1;
                  }
              }

              if (prop == 'E' + ScitonEventIDs.EventID_IncrementXSize)
              {
                  if (vm.xsize < 5)
                  {
                      vm.xsize++;
                  }
              }
              if (prop == 'E' + ScitonEventIDs.EventID_DecrementXSize)
              {
                  if (vm.xsize > 1)
                  {
                      vm.xsize--;
                  }
              }

              if (prop == 'E' + ScitonEventIDs.EventID_IncrementYSize)
              {
                  if (vm.ysize < 5)
                  {
                      vm.ysize++;
                  }
              }
              if (prop == 'E' + ScitonEventIDs.EventID_DecrementYSize)
              {
                  if (vm.ysize > 1)
                  {
                      vm.ysize--;
                  }
              }

              if (prop == 'E' + ScitonEventIDs.EventID_IncrementSkinType)
              {
                  if (vm.skinType < 7)
                  {
                      if (vm.skinType == 0)
                      {
                          vm.skinType = 4;
                      }
                      else if (vm.skinType == 6)
                      {
                          vm.skinType = 1;
                      }
                      else
                      {
                          vm.skinType++;
                      }
                      if (vm.skinType == 1)
                      {
                          vm.hairColor = ScitonEventIDs.EventValue_HairColorBrown;
                          vm.hairType = ScitonEventIDs.EventValue_HairTypeFine;
                      }
                      if (vm.skinType == 2)
                      {
                          vm.hairColor = ScitonEventIDs.EventValue_HairColorBrown;
                          vm.hairType = ScitonEventIDs.EventValue_HairTypeFine;
                      }
                      if (vm.skinType == 3)
                      {
                          vm.hairColor = ScitonEventIDs.EventValue_HairColorBlack;
                          vm.hairType = ScitonEventIDs.EventValue_HairTypeFine;
                      }
                      if (vm.skinType == 4)
                      {
                          vm.hairColor = ScitonEventIDs.EventValue_HairColorBlack;
                          vm.hairType = ScitonEventIDs.EventValue_HairTypeFine;
                      }
                      if (vm.skinType == 5)
                      {
                          vm.hairColor = ScitonEventIDs.EventValue_HairColorBlack;
                          vm.hairType = ScitonEventIDs.EventValue_HairTypeFine;
                      }
                      if (vm.skinType == 6)
                      {
                          vm.hairColor = ScitonEventIDs.EventValue_HairColorBlack;
                          vm.hairType = ScitonEventIDs.EventValue_HairTypeFine;
                      }
                  }
              }

              if (prop == 'E' + ScitonEventIDs.EventID_SetHairColor)
              {
                  if (vm.hairColor == ScitonEventIDs.EventValue_HairColorBlonde)
                  {
                      vm.hairColor = ScitonEventIDs.EventValue_HairColorBrown;
                  }
                  else if (vm.hairColor == ScitonEventIDs.EventValue_HairColorBrown)
                  {
                      vm.hairColor = ScitonEventIDs.EventValue_HairColorBlack;
                  }
                  else if (vm.hairColor == ScitonEventIDs.EventValue_HairColorBlack)
                  {
                      vm.hairColor = ScitonEventIDs.EventValue_HairColorBlonde;
                  }
              }

              if (prop == 'E' + ScitonEventIDs.EventID_SetHairType)
              {
                  if (vm.hairType == ScitonEventIDs.EventValue_HairTypeFine)
                  {
                      vm.hairType = ScitonEventIDs.EventValue_HairTypeMedium;
                  }
                  else if (vm.hairType == ScitonEventIDs.EventValue_HairTypeMedium)
                  {
                      vm.hairType = ScitonEventIDs.EventValue_HairTypeCoarse;
                  }
                  else if (vm.hairType == ScitonEventIDs.EventValue_HairTypeCoarse)
                  {
                      vm.hairType = ScitonEventIDs.EventValue_HairTypeFine;
                  }
              }

              if (prop == 'E' + ScitonEventIDs.EventID_SetOffset)
              {
                  var nextOffset = 0;
                  if (vm.offset < ScitonIDs.ScitonEventIDs.EventValue_Offset4)
                  {
                      nextOffset = vm.offset + 1
                  }
                  else
                  {
                      nextOffset = ScitonIDs.ScitonEventIDs.EventValue_Offset1;
                  }
                  vm.offset = nextOffset;
              }

              if (prop == 'E' + ScitonEventIDs.EventID_RepeatSelection)
              {
                  var nextRepeat = 0;
                  if (vm.repeat < 5)
                  {
                      nextRepeat = vm.repeat + 1
                  }
                  else
                  {
                      nextRepeat = 0;
                  }
                  vm.repeat = nextRepeat;
              }

              if (prop == 'E' + ScitonEventIDs.EventID_CounterResetSelection)
              {
                  vm.counter = 0;
              }

              if (prop == 'E' + ScitonEventIDs.EventID_StandbyReadySelection)
              {
                  if (vm.inReadyMode < 3)
                  {
                      vm.inReadyMode = vm.inReadyMode + 1;
                  }
                  else
                  {
                      vm.inReadyMode = 0;
                  }
                  if (vm.inReadyMode == 3)
                  {
                      vm.treating = 1;
                  }
                  else
                  {
                      vm.treating = 0;
                  }
              }

          }
    }
}

