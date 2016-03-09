import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Content 0.1

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "contenthub-picker.liu-xiao-guo"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(60)
    height: units.gu(85)

    PageStack {
        id: pageStack
        Component.onCompleted: pageStack.push(root)

        Page {
            id: root
            title: i18n.tr("Peer Picker Example")
            visible: false

            property list<ContentItem> importItems
            property var activeTransfer
//            property list<ContentPeer> peers

            Column {
                anchors.fill: parent

                ListItem.Standard {
                    id: peerListHeader
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    text: i18n.tr("Sources")
                    control: Button {
                        text: i18n.tr("Select source")
                        onClicked: {
                            pageStack.push(picker);
                        }
                    }
                }

                ListItem.Header {
                    id: titleItem
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    text: i18n.tr("Results")
                }

                GridView {
                    id: resultList
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: childrenRect.height
                    cellWidth: units.gu(20)
                    cellHeight: cellWidth

                    model: root.importItems
                    delegate: Item {
                        id: result
                        height: units.gu(19)
                        width: height
                        UbuntuShape {
                            width: parent.width
                            height: width
                            source: Image {
                                id: image
                                source: url
                                sourceSize.width: width
                                sourceSize.height: height
                                height: parent.height
                                width: height
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }
                        }
                    }
                }
            }

            ContentTransferHint {
                anchors.fill: root
                activeTransfer: root.activeTransfer
            }

            Connections {
                target: root.activeTransfer
                onStateChanged: {
                    console.log("StateChanged: " + root.activeTransfer.state);
                    switch (root.activeTransfer.state ) {
                    case ContentTransfer.Created:
                        console.log("StateChanged: Created")
                        break;

                    case ContentTransfer.Initiated:
                        console.log("StateChanged: Initiated")
                        break;

                    case ContentTransfer.InProgress:
                        console.log("StateChanged: InProgress")
                        break;

                    case ContentTransfer.Downloading:
                        console.log("StateChanged: Downloading")
                        break;

                    case ContentTransfer.Downloaded:
                        console.log("StateChanged: Downloaded")
                        break;

                    case ContentTransfer.Charged:
                        console.log("StateChanged: Charged")
                        break;

                    case ContentTransfer.Collected:
                        console.log("StateChanged: Collected")
                        break;

                    case ContentTransfer.Aborted:
                        console.log("StateChanged: Aborted")
                        break;

                    case ContentTransfer.Finalized:
                        console.log("StateChanged: Finalized")
                        break;
                    }

                    if (root.activeTransfer.state === ContentTransfer.Charged) {
                        root.importItems = root.activeTransfer.items;

                        for ( var key in root.importItems ) {
                            console.log("url: " + root.importItems[key].url)
                        }
                    }
                }
            }

        }

        Page {
            id: picker
            visible: false

            ContentPeerPicker {
                visible: parent.visible

                // Type of handler: Source, Destination, or Share
                handler: ContentHandler.Source
                // well know content type
                contentType: ContentType.Pictures

                onPeerSelected: {
                    console.log("onPeerSelected-----------------------------!")
                    root.activeTransfer = peer.request();
                    pageStack.pop();
                }

                onCancelPressed: {
                    console.log("onCancelPressed!---------------------------!")
                    pageStack.pop();
                }
            }
        }
    }
}

