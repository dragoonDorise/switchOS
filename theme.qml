// SwitchOS

import QtQuick 2.0
import SortFilterProxyModel 0.2
import QtMultimedia 5.9
import "qrc:/qmlutils" as PegasusUtils
import "utils.js" as Utils
import "layer_platform" 
import "layer_grid"
import "layer_help"

FocusScope
{
    id: root


    // options you might want to play with

    property bool darkMode: true

    property bool yTogglesDarkMode: true
    
    property bool restorePosition: true

    property var masterVolume: 1.0

    // end options


    property var bottomNavButtonSize: 0.08
    property var bottomNavButtonText: 0.05
    
    property var platformMarginTop: 0.15
    property var headerMarginTop: 0.0472
    property var headerLogo: 0.0833
    property var headerTime: 0.04
    property var platformBox: 0.55
    
    
    
    property var platformText: 0.025
    property var selectedPlatformTitle: 0.05
    property var platformBubbleBottom: 0.02
    
    
    property var gamesHeaderHeight: 0.1222
    property var gamesHeaderIcon: 0.0611
    property var gamesHeaderNavTop: 0.0416
    property var gamesCategoryTitle: 0.0277
    property var gamesGridMarginTop: 0.1388
    property var sc6: 0.6527
    property var sc7: 0.0194
    property var gamesBubbleHeight: 0.0611
    property var gamesBubbleText: 0.0422
    property var gamesBubbleTriangleHeight: 0.02
    
    property bool searchActive
    property string searchTerm: ""
    
    property int collectionIndex: 0
    property int currentGameIndex: 0
    property int screenmargin: vpx(30)
    property real screenwidth: width
    property real screenheight: height
    property bool widescreen: ((height/width) < 0.7)
    property real helpbarheight: Math.round(screenheight*0.1041) // Calculated manually based on mockup
    property var allCollections: {
        let collections = api.collections.toVarArray()
        collections.unshift({"name": "Favorites", "shortName": "auto-favorites", "games": allFavorites})
        collections.unshift({"name": "Last Played", "shortName": "auto-lastplayed", "games": filterLastPlayed})
        collections.unshift({"name": "All Games", "shortName": "auto-allgames", "games": api.allGames})

        return collections
    }
    property var currentCollection: allCollections[collectionIndex]
    property int maximumPlayedGames: {
        if (allLastPlayed.count >= 17) {
            return 17
        }
        return allLastPlayed.count
    }

    SortFilterProxyModel {
        id: allFavorites
        sourceModel: api.allGames
        filters: ValueFilter { roleName: "favorite"; value: true; }
    }

    SortFilterProxyModel {
        id: allLastPlayed
        sourceModel: api.allGames
        filters: ValueFilter { roleName: "lastPlayed"; value: ""; inverted: true; }
        sorters: RoleSorter { roleName: "lastPlayed"; sortOrder: Qt.DescendingOrder }
    }

    SortFilterProxyModel {
        id: filterLastPlayed
        sourceModel: allLastPlayed
        filters: IndexFilter { maximumIndex: maximumPlayedGames }
    }

    function modulo(a,n) {
        return (a % n + n) % n;
    }

    function nextCollection () {
        jumpToCollection(collectionIndex + 1);
    }

    function prevCollection() {
        jumpToCollection(collectionIndex - 1);
    }

    function jumpToCollection(idx) {
        api.memory.set('gameCollIndex' + collectionIndex, currentGameIndex); // save game index of current collection
        collectionIndex = modulo(idx, allCollections.length); // new collection index
        currentGameIndex = 0; // Jump to the top of the list each time collection is changed
    }

    function showSoftwareScreen()
    {
        /*platformScreen.visible = false;
        softwareScreen.visible = true;*/
        softwareScreen.focus = true;
        toSoftware.play();
    }

    function showSoftwareScreenNoSfx()
    {
        softwareScreen.focus = true;
    }    

    function showHomeScreen()
    {
        platformScreen.focus = true;
        backSfx.play();
        /*platformScreen.visible = true;
        softwareScreen.visible = false;*/
        //platformScreen.focus = true;
    }
    
  function toggleSearch() {  
         searchActive = !searchActive;
        
        /*platformScreen.visible = true;
        softwareScreen.visible = false;*/
        //platformScreen.focus = true;
  }  
    

    function playGame()
    {
        root.state = "playgame"

        launchSfx.play()
    }

    // function launchGame()
    // {
    //     currentGame.launch();
    // }

    // Theme settings
    FontLoader { id: titleFont; source: "fonts/Nintendo_Switch_UI_Font.ttf" }

    property var themeLight: {
        return {
            main: "#EBEBEB",
            secondary: "#2D2D2D",
            accent: "#10AEBE",
            highlight: "white",
            text: "#2C2C2C",
            button: "white"
        }
    }

    property var themeDark: {
        return {
            main: "#2D2D2D",
            secondary: "#EBEBEB",
            accent: "#10AEBE",
            highlight: "black",
            text: "white",
            button: "#515151"
        }
    }

    // Do this properly later
    property var theme: {
    	var mode = darkMode ? themeDark : themeLight;
        return {
            main: api.memory.get('themeBG') || mode.main,
            secondary: api.memory.get('themeSecondary') || mode.secondary,
            accent: api.memory.get('themeAccent') || mode.accent,
            highlight: api.memory.get('themeHighlight') || mode.highlight,
            text: api.memory.get('themeText') || mode.text,
            button: api.memory.get('themeButton') || mode.button
        }
    }

    function toggleDarkMode() {
        if (darkMode) {
            darkMode = false;
            theme.main = themeLight.main;
        } else {
            darkMode = true;
            theme.main = themeDark.main;
        }
        api.memory.set('darkMode', darkMode);
    }

    Timer {
        id: timer
        running: false
        repeat: false
        property var callback
        onTriggered: callback()
    }

    function setTimeout(callback, delay)
    {
        if (!timer.running) {
	        timer.callback = callback;
	        timer.interval = delay + 1;
	        timer.running = true;
        }
    }

    Component.onCompleted: {
        state: "platformscreen"
        homeSfx.play()

        var darkModeMemory = api.memory.get('darkMode');
        if (darkModeMemory != undefined && darkModeMemory != darkMode) {
        	toggleDarkMode();
        }
    }    

    // State settings
    states: [
        State {
            name: "platformscreen"; when: platformScreen.focus == true
        },
        State {
            name: "softwarescreen"; when: softwareScreen.focus == true
        },
        State {
            name: "playgame";
        }
    ]

    transitions: [
        Transition {
            from: "platformscreen"; to: "softwarescreen"
            SequentialAnimation {
                PropertyAnimation { target: platformScreen; property: "opacity"; to: 0; duration: 200}
                PropertyAction { target: platformScreen; property: "visible"; value: false }
                PropertyAction { target: softwareScreen; property: "visible"; value: true }
                PropertyAnimation { target: softwareScreen; property: "opacity"; to: 1; duration: 200}
            }
        },
        Transition {
            from: "softwarescreen"; to: "platformscreen"
            SequentialAnimation {
                PropertyAnimation { target: softwareScreen; property: "opacity"; to: 0; duration: 200}
                PropertyAction { target: softwareScreen; property: "visible"; value: false }
                PropertyAction { target: platformScreen; property: "visible"; value: true }
                PropertyAnimation { target: platformScreen; property: "opacity"; to: 1; duration: 200}
            }
        },
        Transition {
            to: "playgame"
            SequentialAnimation {
                PropertyAnimation { target: softwareScreen; property: "opacity"; to: 0; duration: 200}
                PauseAnimation { duration: 200 }
                ScriptAction { script: launchGame() }
            }
        },
        Transition {
            from: ""; to: "platformscreen"
            ParallelAnimation {
                NumberAnimation { target: platformScreen; property: "scale"; from: 1.2; to: 1.0; duration: 200; easing.type: Easing.OutQuad }
                NumberAnimation { target: platformScreen; property: "opacity"; from: 0; to: 1; duration: 200 }
            }
        }
    ]


    // Background
    Rectangle {
        id: background
        anchors
        {
            left: parent.left; right: parent.right
            top: parent.top; bottom: parent.bottom
        }
        color: theme.main
    }

    // Platform screen
    PlatformScreen
    {
        id: platformScreen
        focus: true
        anchors
        {
            left: parent.left; right: parent.right
            top: parent.top; bottom: helpBar.top
        }
    }

    // All Software screen
    SoftwareScreen {
        id: softwareScreen
        opacity: 0
        visible: false
        anchors
        {
            left: parent.left;// leftMargin: screenmargin
            right: parent.right;// rightMargin: screenmargin
            top: parent.top; bottom: helpBar.top
        }
    }


    // Help bar
    Item
    {
        id: helpBar
        anchors
        {
            left: parent.left; leftMargin: screenmargin
            right: parent.right; rightMargin: screenmargin
            bottom: parent.bottom
        }
        height: helpbarheight

        Rectangle {

            anchors.fill: parent
            color: theme.main
        }

        Rectangle {
            anchors.left: parent.left; anchors.right: parent.right
            height: 1
            color: theme.secondary
        }

        ControllerHelp {
            id: controllerHelp
            width: parent.width
            height: parent.height
            anchors {
                bottom: parent.bottom;
            }
            showBack: !platformScreen.focus
        }

    }

    SoundEffect {
      id: navSound
      source: "assets/audio/Klick.wav"
      volume: masterVolume * 1.0
    }

    SoundEffect {
      id: toSoftware
      source: "assets/audio/EnterBack.wav"
      volume: masterVolume * 1.0
    }

    SoundEffect {
      id: fillList
      source: "assets/audio/Icons.wav"
      volume: masterVolume * 1.0
    }

    SoundEffect {
      id: backSfx
      source: "assets/audio/Nock.wav"
      volume: masterVolume * 1.0
    }

    SoundEffect {
        id: launchSfx
        source: "assets/audio/PopupRunTitle.wav"
        volume: masterVolume * 1.0
    }

    SoundEffect {
        id: homeSfx
        source: "assets/audio/Home.wav"
        volume: masterVolume * 1.0
    }

}
