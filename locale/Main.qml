import QtQuick 2.0
import Ubuntu.Components 1.1

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "locale.liu-xiao-guo"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(60)
    height: units.gu(85)

    Page {
        title: i18n.tr("Locale")

        Rectangle {
            id: root
            anchors.fill: parent
            color: "lightgray"

            property string locale: view.currentItem.locale

            Text {
                id: title
                text: "Select locale:"
            }

            Rectangle {
                id: chooser
                anchors.top: title.bottom
                anchors.topMargin: 5
                width: parent.width-10
                x: 5
                height: parent.height/2 - 10
                color: "#40300030"
                ListView {
                    id: view
                    clip: true
                    focus: true
                    anchors.fill: parent
                    model: [
                        "en_US",
                        "en_GB",
                        "fi_FI",
                        "de_DE",
                        "ar_SA",
                        "hi_IN",
                        "zh_CN",
                        "th_TH",
                        "fr_FR",
                        "nb_NO",
                        "sv_SE"
                    ]
                    delegate: Text {
                        property string locale: modelData
                        height: units.gu(3)
                        width: view.width
                        text: Qt.locale(modelData).name + " ("+ Qt.locale(modelData).nativeCountryName + "/" + Qt.locale(modelData).nativeLanguageName + ")"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: view.currentIndex = index

                        }
                    }
                    highlight: Rectangle {
                        height: 30
                        color: "#60300030"
                    }
                }
            }

            Rectangle {
                color: "white"
                anchors.top: chooser.bottom
                anchors.topMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                x: 5; width: parent.width - 10

                Column {
                    anchors.fill: parent
                    spacing: 5
                    Text {
                        property var date: new Date()
                        text: "Date: " + date.toLocaleDateString(Qt.locale(root.locale))
                    }
                    Text {
                        property var date: new Date()
                        text: "Time: " + date.toLocaleTimeString(Qt.locale(root.locale))
                    }
                    Text {
                        property var dow: Qt.locale(root.locale).firstDayOfWeek
                        text: "First day of week: " + Qt.locale(root.locale).standaloneDayName(dow)
                    }
                    Text {
                        property var num: 10023823
                        text: "Number: " + num.toLocaleString(Qt.locale(root.locale))
                    }
                    Text {
                        property var num: 10023823
                        text: "Currency: " + num.toLocaleCurrencyString(Qt.locale(root.locale))
                    }
                }
            }
        }
    }
}

