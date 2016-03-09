import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 0.1

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "sheet.liu-xiao-guo"

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
        title: i18n.tr("sheet")

        Component {
            id: defaultSheet
            DefaultSheet {
                id: sheet
                title: i18n.tr("Default sheet Title")
                doneButton: true

                Label {
                    anchors.fill: parent
                    wrapMode: Text.WordWrap
                    text:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " +
                    "Integer et ante at erat malesuada accumsan in eget mauris. " +
                    "Nunc ultrices tristique laoreet. In non tristique lorem. " +
                    "Donec in libero ut libero pretium lacinia. Proin dictum faucibus viverra. "
                }
            }
        }

        Component {
            id: composerSheet
            ComposerSheet {
                id: sheet
                title: i18n.tr("Composer sheet")
                Label {
                    anchors.fill: parent
                    wrapMode: Text.WordWrap
                    text:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " +
                    "Integer et ante at erat malesuada accumsan in eget mauris. " +
                    "Nunc ultrices tristique laoreet. In non tristique lorem. " +
                    "Donec in libero ut libero pretium lacinia. Proin dictum faucibus viverra. "
                }
                onCancelClicked: PopupUtils.close(sheet)
                onConfirmClicked: PopupUtils.close(sheet)
            }
        }

        Row {
            anchors.centerIn: parent
            spacing: units.gu(2)

            Button {
                text: "Default sheet"
                onClicked: {
                    PopupUtils.open(defaultSheet, null)
                }
            }

            Button {
                text: "Composer Sheet"

                onClicked: {
                    PopupUtils.open(composerSheet, null)
                }
            }
        }
    }
}

