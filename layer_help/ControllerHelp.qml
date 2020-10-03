import QtQuick 2.12
import QtGraphicalEffects 1.0

FocusScope {
  id: root
  property string bottomNavButtonText1: showBack ? "Start" : "OK"
  property string controllerButton1: "B"
  property string bottomNavButtonText2: "Back"
  property string controllerButton2: "A"

  property string bottomNavButtonText3: "Favourite"
  property string controllerButton3: "Y"  

  property string bottomNavButtonText4: "Search"
  property string controllerButton4: "X"  

 

  property bool showBack: true

  function processButtonArt(buttonModel) {
    var i;
    for (i = 0; buttonModel.length; i++) {
      if (buttonModel[i].name().includes("Gamepad")) {
        var buttonValue = buttonModel[i].key.toString(16)
        return buttonValue.substring(buttonValue.length-1, buttonValue.length);
      }
    }
  }
  
  Item {
    id: background

    width: parent.width
    height: parent.height
      
    Behavior on opacity { NumberAnimation { duration: 200 } }
    
    Image {
      id: button1
      width: Math.round(screenheight*bottomNavButtonSize)
      height: width
      source: "../assets/images/controller/"+ processButtonArt(api.keys.accept) + ".png"
      sourceSize.width: 64
      sourceSize.height: 64
      anchors {
        verticalCenter: button1Txt.verticalCenter
        right: button1Txt.left
        rightMargin: vpx(5)
      }
      
    }//button1

    ColorOverlay {
        anchors.fill: button1
        source: button1
        color: theme.text
        cached: true
    }

    Item {
      id: button1Txt
      width: txt1.width
      height: txt1.height
      Text {
        id: txt1
        text: bottomNavButtonText1
        color: theme.text
        font.pixelSize: Math.round(screenheight*bottomNavButtonText)
        font.family: titleFont.name
        font.bold: true
      }
      anchors {
        verticalCenter: parent.verticalCenter
        right: parent.right
        rightMargin: vpx(25)
      }
      
    }//buttonBack

    Image {
      id: button2
      width: Math.round(screenheight*bottomNavButtonSize)
      height: width
      source: "../assets/images/controller/"+ processButtonArt(api.keys.cancel) + ".png"
      sourceSize.width: 64
      sourceSize.height: 64
      anchors {
        verticalCenter: button2Txt.verticalCenter
        right: button2Txt.left
        rightMargin: vpx(5)
      }
      visible: showBack
    }//button2

    ColorOverlay {
        anchors.fill: button2
        source: button2
        color: theme.text
        cached: true
        visible: showBack
    }

    Item {
      id: button2Txt
      width: txt2.width
      height: txt2.height
      Text {
        id: txt2
        text: bottomNavButtonText2
        color: theme.text
        font.pixelSize: Math.round(screenheight*bottomNavButtonText)
        font.family: titleFont.name
        font.bold: true
      }
      anchors {
        verticalCenter: parent.verticalCenter
        right: button1.left
        rightMargin: vpx(20)
      }
      visible: showBack
    }


    Image {
      id: button3
      width: Math.round(screenheight*bottomNavButtonSize)
      height: width
      source: "../assets/images/controller/"+ processButtonArt(api.keys.details) + ".png"
      sourceSize.width: 64
      sourceSize.height: 64
      anchors {
        verticalCenter: button3Txt.verticalCenter
        right: button3Txt.left
        rightMargin: vpx(5)
      }
      visible: showBack
    }//button3

    ColorOverlay {
        anchors.fill: button3
        source: button3
        color: theme.text
        cached: true
        visible: showBack
    }

    Item {
      id: button3Txt
      width: txt3.width
      height: txt3.height
      Text {
        id: txt3
        text: bottomNavButtonText3
        color: theme.text
        font.pixelSize: Math.round(screenheight*bottomNavButtonText)
        font.family: titleFont.name
        font.bold: true
      }
      anchors {
        verticalCenter: parent.verticalCenter
        right: button2.left
        rightMargin: vpx(20)
      }
      visible: showBack
    }

//     Image {
//       id: button4
//       width: Math.round(screenheight*bottomNavButtonSize)
//       height: width
//       source: "../assets/images/controller/"+ processButtonArt(api.keys.filters) + ".png"
//       sourceSize.width: 64
//       sourceSize.height: 64
//       anchors {
//         verticalCenter: button4Txt.verticalCenter
//         right: button4Txt.left
//         rightMargin: vpx(5)
//       }
//       visible: showBack
//     }//button4
// 
//     ColorOverlay {
//         anchors.fill: button4
//         source: button4
//         color: theme.text
//         cached: true
//         visible: showBack
//     }
// 
//     Item {
//       id: button4Txt
//       width: txt4.width
//       height: txt4.height
//       Text {
//         id: txt4
//         text: bottomNavButtonText4
//         color: theme.text
//         font.pixelSize: Math.round(screenheight*bottomNavButtonText)
//         font.family: titleFont.name
//         font.bold: true
//       }
//       anchors {
//         verticalCenter: parent.verticalCenter
//         right: button3.left
//         rightMargin: vpx(20)
//       }
//       
//       Keys.onPressed: {
//           // Accept
//           if (api.keys.isAccept(event) && !event.isAutoRepeat) {
//               event.accepted = true;
//               if (!searchActive) {
//                   searchInput.selectAll();
//               } else {
//                   searchInput.selectAll();
//               }
//           }
//       }      
//       visible: showBack
//       
//       
//     }



    // Search bar
    Item {
    id: searchbar
        
        //property bool selected: ListView.isCurrentItem && root.focus
        property bool selected: true
        
        onSelectedChanged: if (!selected && searchActive) toggleSearch();

        width: parent.width
        height: parent.height

        Behavior on width {
            PropertyAnimation { duration: 200; easing.type: Easing.OutQuart; easing.amplitude: 2.0; easing.period: 1.5 }
        }
        
        anchors { 
          verticalCenter: parent.verticalCenter
        }        
        
        Rectangle { // Background
            width: parent.width
            height: parent.height
            color: searchbar.selected && !searchActive ? theme.text : theme.text
            opacity: searchbar.selected && !searchActive ? 0 : searchActive ? 1 : 1
        }
        
        Rectangle {//White input
            width: parent.width - vpx(80)
            height: parent.height - vpx(40)
            color: "white"
            radius: height/2
            opacity: searchbar.selected && !searchActive ? 0 : searchActive ? 1 : 1
            anchors{
              verticalCenter: parent.verticalCenter
              top:vpx(20)
              left:vpx(20)
            }
        }          
        
        TextInput {
        id: searchInput
            width: parent.width
            opacity: searchbar.selected && !searchActive ? 0 : searchActive ? 1 : 1
            anchors { 
              verticalCenter: parent.verticalCenter
              //left: button4.left
              left:vpx(20)
            }
           // verticalAlignment: Text.AlignVCenter
            color: theme.text
            focus: true
            font.family: titleFont.name
            font.pixelSize: vpx(18)
            clip: true
            text: "searchTerm"
            onTextEdited: {
                searchTerm = searchInput.text
            }
        }          

    }
   
  
        
      

  


  }//background
}//root
