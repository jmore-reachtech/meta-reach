import QtQuick 1.0

Image {
    id: container
    width: 1024
    height: 768
    source: "Images/002_background1024.bmp"

    ClearScan_YAG_1064_nm_VM {
        id: s99vm
        objectName: "s99vm"
    }
	    
    Text {
        id: text1
        x: 25
        y: 24
        color: "#ffffff"
        text: qsTr("ClearScan YAG 1064 nm")
        style: Text.Normal
        font.bold: true
        font.strikeout: false
        font.family: "Arial"
        styleColor: "#000000"
        font.pixelSize: 25
        smooth: true
    }

    Image {
        id: image1
        x: 21
        y: 72
        width: 982
        height: 578
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        source: "Images/134_hrm_generic1024.bmp"

        Text {
            id: text2
            x: 32
            y: 12
            width: 147
            height: 23
            color: "#ffffff"
            text: qsTr("HF Scanner")
            font.bold: true
            font.pixelSize: 21
        }

        Text {
            id: textMessage
            x: 157
            y: 12
            width: 792
            height: 23
            color: "#f7f246"
            text: s99vm.message
            visible: s99vm.message != "0"
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            font.pixelSize: 21
            onTextChanged: {
                console.log('message text updated');
                s99vm.ackMessageChange();
            }
        }

        BorderImage {
            id: border_imageFluenceBackground
            x: 80
            y: 110
            source: "Images/229_ParmUpDn.bmp"

            ScitonRepeatingImageButton {
                id: btnFluenceUp
                x: 73
                y: 0
                width: 68
                height: 56
                imageOn: "Images/102_UserUpEn.bmp"
                imageOff: "Images/101_UserUp.bmp"
                onFirstButtonClick: {
                    s99vm.incrementFluence(0);
                }
                onRepeatButtonClick: {
                    s99vm.incrementFluence(1);
                }
            }

            ScitonRepeatingImageButton {
                id: btnFluenceDown
                x: 73
                y: 115
                width: 69
                height: 56
                imageOn: "Images/104_UserDnEn.bmp"
                imageOff: "Images/103_UserDn.bmp"
                onFirstButtonClick: {
                    s99vm.decrementFluence(0);
                }
                onRepeatButtonClick: {
                    s99vm.decrementFluence(1);
                }
            }

            Text {
                id: textFluence
                x: 31
                y: 67
                color: "black"
                text: s99vm.fluence
                anchors.horizontalCenterOffset: -23
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                style: Text.Normal
                font.bold: true
                font.strikeout: false
                font.family: "Arial"
                styleColor: "#000000"
                font.pixelSize: 33
                smooth: true
                onTextChanged: {
                    console.log('fluence text updated');
                    s99vm.ackFluenceChange();
                }
            }

            BorderImage {
                id: border_imageFluenceTitle
                x: -5
                y: 20
                source: "Images/263_Fluence.bmp"
            }

            BorderImage {
                id: border_imageFluenceUnits
                x: 22
                y: 128
                source: "Images/264_Jcm.bmp"
            }
        }

        BorderImage {
            id: border_imageWidthBackground
            x: 304
            y: 110
            source: "Images/229_ParmUpDn.bmp"

            ScitonRepeatingImageButton {
                id: btnWidthUp
                x: 73
                y: 0
                width: 69
                height: 56
                imageOn: "Images/102_UserUpEn.bmp"
                imageOff: "Images/101_UserUp.bmp"
                onFirstButtonClick: {
                    s99vm.incrementWidth(0);
                }
                onRepeatButtonClick: {
                    s99vm.incrementWidth(1);
                }
            }

            ScitonRepeatingImageButton {
                id: btnWidthDown
                x: 73
                y: 115
                width: 69
                height: 56
                imageOn: "Images/104_UserDnEn.bmp"
                imageOff: "Images/103_UserDn.bmp"
                onFirstButtonClick: {
                    s99vm.decrementWidth(0);
                }
                onRepeatButtonClick: {
                    s99vm.decrementWidth(1);
                }
            }

            Text {
                id: textWidth
                x: 31
                y: 67
                color: "black"
                text: s99vm.pulsewidth
                anchors.horizontalCenterOffset: -23
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                style: Text.Normal
                font.bold: true
                font.strikeout: false
                font.family: "Arial"
                styleColor: "#000000"
                font.pixelSize: 33
                smooth: true
                onTextChanged: {
                    console.log('pulsewidth text updated');
                    s99vm.ackPulsewidthChange();
                }
            }

            BorderImage {
                id: border_imageWidthTitle
                x: 1
                y: 20
                source: "Images/265_Width.bmp"
            }

            BorderImage {
                id: border_imageWidthUnits
                x: 14
                y: 128
                source: "Images/144_BBLmSec.bmp"
            }
        }

        BorderImage {
            id: border_imageRateBackground
            x: 533
            y: 110
            source: "Images/229_ParmUpDn.bmp"

            ScitonRepeatingImageButton {
                id: btnRateUp
                x: 73
                y: 0
                width: 69
                height: 56
                imageOn: "Images/102_UserUpEn.bmp"
                imageOff: "Images/101_UserUp.bmp"
                onFirstButtonClick: {
                    s99vm.incrementRate(0);
                }
                onRepeatButtonClick: {
                    s99vm.incrementRate(1);
                }
            }

            ScitonRepeatingImageButton {
                id: btnRateDown
                x: 73
                y: 115
                width: 69
                height: 56
                imageOn: "Images/104_UserDnEn.bmp"
                imageOff: "Images/103_UserDn.bmp"
                onFirstButtonClick: {
                    s99vm.decrementRate(0);
                }
                onRepeatButtonClick: {
                    s99vm.decrementRate(1);
                }
            }

            Text {
                id: textRate
                x: 31
                y: 67
                color: "black"
                text: s99vm.formattedRate
                anchors.horizontalCenterOffset: -23
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                style: Text.Normal
                font.bold: true
                font.strikeout: false
                font.family: "Arial"
                styleColor: "#000000"
               font.pixelSize: 33
                smooth: true
                onTextChanged: {
                    console.log('rate text updated');
                    s99vm.ackRateChange();
                }
            }


            BorderImage {
                id: border_imageRateTitle
                x: 13
                y: 20
                source: "Images/262_RateTX.bmp"
            }

            BorderImage {
                id: border_imageRateUnits
                x: 36
                y: 128
                source: "Images/267_HzTX.bmp"
            }
        }

        BorderImage {
            id: border_imageScanParams
            x: 778
            y: 110
            source: "Images/135_scanParams.bmp"

            // X Size
            ScitonRepeatingImageButton {
                id: btnXSizeUp
                x: 9
                y: 21
                width: 43
                height: 35
                imageOn: "Images/084_User2UpEn.bmp"
                imageOff: "Images/083_User2Up.bmp"
                onFirstButtonClick: {
                    s99vm.incrementXSize(0);
                }
                onRepeatButtonClick: {
                    s99vm.incrementXSize(1);
                }
            }
            ScitonRepeatingImageButton {
                id: btnXSizeDown
                x: 9
                y: 92
                width: 43
                height: 35
                imageOn: "Images/086_User2DnEn.bmp"
                imageOff: "Images/085_User2Dn.bmp"
                onFirstButtonClick: {
                    s99vm.decrementXSize(0);
                }
                onRepeatButtonClick: {
                    s99vm.decrementXSize(1);
                }
            }
            Text {
                id: textXSize
                x: 23
                y: 60
                color: "black"
                text: s99vm.xsize
                anchors.horizontalCenterOffset: -28
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                style: Text.Normal
                font.bold: true
                font.strikeout: false
                font.family: "Arial"
                styleColor: "#000000"
                font.pixelSize: 24
                smooth: true
                onTextChanged: {
                    console.log('xsize text updated');
                    s99vm.ackXSizeChange();
                }
            }

            // Y Size
            ScitonRepeatingImageButton {
                id: btnYSizeUp
                x: 70
                y: 21
                width: 43
                height: 35
                imageOn: "Images/084_User2UpEn.bmp"
                imageOff: "Images/083_User2Up.bmp"
                onFirstButtonClick: {
                    s99vm.incrementYSize(0);
                }
                onRepeatButtonClick: {
                    s99vm.incrementYSize(1);
                }
            }
            ScitonRepeatingImageButton {
                id: btnYSizeDown
                x: 70
                y: 92
                width: 43
                height: 35
                imageOn: "Images/086_User2DnEn.bmp"
                imageOff: "Images/085_User2Dn.bmp"
                onFirstButtonClick: {
                    s99vm.decrementYSize(0);
                }
                onRepeatButtonClick: {
                    s99vm.decrementYSize(1);
                }
            }
            Text {
                id: textYSize
                x: 84
                y: 60
                color: "black"
                text: s99vm.ysize
                anchors.horizontalCenterOffset: 33
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                style: Text.Normal
                font.bold: true
                font.strikeout: false
                font.family: "Arial"
                styleColor: "#000000"
                font.pixelSize: 24
                smooth: true
                onTextChanged: {
                    console.log('ysize text updated');
                    s99vm.ackYSizeChange();
                }
            }

            // Offset Button
            ScitonOffsetButton {
                id: btnOffset
                x: 32
                y: 160
                offset: s99vm.offset;
                width: 58
                height: 46
                onButtonClick: {
                    s99vm.setOffset();
                }
                onOffsetChanged: {
                    console.log('offset button updated');
                    s99vm.ackOffsetChange();
                }
            }

            // Repeat Button
            ScitonRepeatButton {
                id: btnRepeat
                x: 32
                y: 270
                repeat: s99vm.repeat;
                width: 58
                height: 46
                onButtonClick: {
                    s99vm.repeatSelection();
                }
                onRepeatChanged: {
                    console.log('repeat button updated');
                    s99vm.ackRepeatChange();
                }
            }
        }

        BorderImage {
            id: border_imageHairPresets
            x: 250
            y: 348
            source: "Images/392_HairPreset.bmp"

            Text {
                id: textHairPresets
                x: 0
                y: 8
                color: "black"
                text: "Hair Presets"
                font.bold: true
                font.family: "Arial"
                styleColor: "#000000"
                font.pixelSize: 17
                smooth: true
            }

            ScitonImageButton {
                id: btnSkinTypeBlank
                x: 0
                y: 69
                width: 90
                height: 40
                visible: s99vm.skinType == 0
                imageOn: "Images/396_HairPresetBlank.bmp"
                imageOff: "Images/396_HairPresetBlank.bmp"
                onButtonClick: {
                    s99vm.incrementSkinType();
                }
            }
            ScitonImageButton {
                id: btnSkinType
                x: 0
                y: 69
                width: 90
                height: 40
                visible: s99vm.skinType != 0
                imageOn: "Images/394_HairPresetGradiant.bmp"
                imageOff: "Images/394_HairPresetGradiant.bmp"
                onButtonClick: {
                    s99vm.incrementSkinType();
                }

                Text {
                    id: textSkinType
                    x: 17
                    y: 11
                    color: "black"
                    text: s99vm.skinType
                    visible: s99vm.skinType != 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                    font.family: "Arial"
                    styleColor: "#000000"
                    font.pixelSize: 17
                    smooth: true
                    onTextChanged: {
                        console.log('skinType text updated');
                        s99vm.ackSkinTypeChange();
                    }
                }
            }

            BorderImage {
                id: border_imageHairColorBlank
                x: 104
                y: 69
                width: 90
                height: 40
                visible: s99vm.skinType == 0
                source: "Images/396_HairPresetBlank.bmp"
            }
            ScitonImageButton {
                id: btnHairColor
                x: 104
                y: 69
                width: 90
                height: 40
                visible: s99vm.skinType != 0
                imageOn: "Images/394_HairPresetGradiant.bmp"
                imageOff: "Images/394_HairPresetGradiant.bmp"
                onButtonClick: {
                    s99vm.setHairColor();
                }

                Text {
                    id: textHairColor
                    x: 17
                    y: 11
                    color: "black"
                    text: s99vm.hairColor == 1 ? "Blonde" :
                          (s99vm.hairColor == 2 ?  "Brn/Red" : "Black")
                    visible: s99vm.skinType != 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                    font.family: "Arial"
                    styleColor: "#000000"
                    font.pixelSize: 17
                    smooth: true
                    onTextChanged: {
                        console.log('hairColor text updated');
                        s99vm.ackHairColorChange();
                    }
                }
            }

            BorderImage {
                id: border_imageHairTypeBlank
                x: 208
                y: 69
                width: 90
                height: 40
                visible: s99vm.skinType == 0
                source: "Images/396_HairPresetBlank.bmp"
            }
            ScitonImageButton {
                id: btnHairType
                x: 208
                y: 69
                width: 90
                height: 40
                visible: s99vm.skinType != 0
                imageOn: "Images/394_HairPresetGradiant.bmp"
                imageOff: "Images/394_HairPresetGradiant.bmp"
                onButtonClick: {
                    s99vm.setHairType();
                }
                Text {
                    id: textHairType
                    x: 50
                    y: 11
                    color: "black"
                    text: s99vm.hairType == 1 ? "Fine" :
                          (s99vm.hairType == 2 ? "Medium" : "Coarse")
                    visible: s99vm.skinType != 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                    font.family: "Arial"
                    styleColor: "#000000"
                    font.pixelSize: 17
                    smooth: true
                    onTextChanged: {
                        console.log('hairType text updated');
                        s99vm.ackHairTypeChange();
                    }
                }
            }
        }
    }

    // Back Button
    ScitonImageButton {
        id: btnBack
        x: 33
        y: 677
        width: 72
        height: 46
        imageOn: "Images/100_BackEn.bmp"
        imageOff: "Images/099_Back.bmp"
        imageDisabled: "Images/099_Back.bmp"
        enabled: s99vm.backEnabled == 1
        onButtonClick: {
            s99vm.backSelection();
        }
        onEnabledChanged: {
            console.log('back button enable updated');
            s99vm.ackBackEnabledChange();
        }
    }

    // Standby Button
    ScitonStandbyButton {
        id: btnStandby
        x: 423
        y: 672
        mode: s99vm.inReadyMode
        width: 178
        height: 65

        imageStandbyOn: "Images/130_Standby.bmp"
        imageStandbyOff: "Images/130_Standby.bmp"
        imageReadyOn: "Images/131_Ready.bmp"
        imageReadyOff: "Images/131_Ready.bmp"
        imageReadyFlashingOn: "Images/133_Post.bmp";
        imageReadyFlashingOff: "Images/133_Post.bmp";
        imageTreatOn: "Images/132_Treat.bmp"
        imageTreatOff: "Images/132_Treat.bmp"

        onButtonClick: {
            s99vm.standbyReadySelection();
        }
        onModeChanged: {
            console.log('standy/ready state updated');
            s99vm.ackInReadyModeChange();
        }
    }

    Timer {
        id: laserFlashingTimer
          interval: 500; running: true; repeat: true
          onTriggered: {
              if (s99vm.treating == 1)
              {
                  if (border_imageLaserIcon.opacity == 1)
                  {
                      border_imageLaserIcon.opacity = 0;
                  }
                  else
                  {
                      border_imageLaserIcon.opacity = 1;
                  }
                  //border_imageLaserIcon.visible = !border_imageLaserIcon.visible;
              }
              else
              {
                  border_imageLaserIcon.opacity = 0;
                  //border_imageLaserIcon.visible = false;
              }
          }
      }

    BorderImage {
        id: border_imageLaserIcon
        x: 746
        y: 672
        visible: s99vm.treating == 1
        width: 70
        height: 65
        source: "Images/142_laser_symbol.bmp"
        onVisibleChanged: {
            console.log('treat button state updated');
            s99vm.ackTreatingChange();
        }
    }

    BorderImage {
        id: border_imageCounter
        x: 884
        y: 672
        width: 119
        height: 56
        source: "Images/270_Counter.bmp"

        ScitonCounterResetButton {
            id: btnResetCounter
            x: 71
            y: 0
            width: 48
            height: 22
            enabled: s99vm.counterResetEnabled == 1
            imageOn: "Images/138_ShotClearEn.bmp"
            imageOff: "Images/137_ShotClear.bmp"
            imageDisabled: "Images/137_ShotClear.bmp"
            onButtonClick: {
                s99vm.counterResetSelection();
            }
            onEnabledChanged: {
                console.log('counter reset button enable updated');
                s99vm.ackCounterResetEnabledChange();
            }
        }

        Text {
            id: textCounter
            x: 55
            y: 27
            color: "black"
            text: s99vm.counter
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            font.family: "Arial"
            styleColor: "#000000"
            font.pixelSize: 17
            smooth: true

            onTextChanged: {
                console.log('counter text updated');
                s99vm.ackCounterChange();
            }

            // Used only for testing in simulation mode.
            /*
            Timer {
                id: counterTimer
                  interval: 1000; running: false; repeat: true
                  onTriggered: s99vm.counter++;
              }
            function startTimer() {
                if(typeof connection == 'undefined'){
                    counterTimer.start();
                }
            }
            Component.onCompleted: startTimer();
            */
        }

    }
}
