import QtQuick 2.0
import Ubuntu.Components 1.1
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
    applicationName: "contenthub-exporter.liu-xiao-guo"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(60)
    height: units.gu(85)

    function showState( state ) {
        switch (state) {
        case ContentTransfer.Created:
            console.log("Created");
            break
        case ContentTransfer.Initiated:
            console.log("Initiated");
            break;
        case ContentTransfer.InProgress:
            console.log("InProgress");
            break;
        case ContentTransfer.Downloading:
            console.log("Downloading");
            break;
        case ContentTransfer.Downloaded:
            console.log("Downloaded");
            break;
        case ContentTransfer.Charged:
            console.log("Charged");
            break;
        case ContentTransfer.Collected:
            console.log("Collected");
            break;
        case ContentTransfer.Aborted:
            console.log("Aborted");
            break;
        case ContentTransfer.Finalized:
            console.log("Finalized");
            break;
        default:
            console.log("not recognized state!")
            break;
        }
    }

    PageStack {
        id: pageStack
        Component.onCompleted: pageStack.push(root)

        Connections {
            target: ContentHub
            onExportRequested: {
                root.activeTransfer = transfer;
                console.log ("onExportRequested: " + root.activeTransfer.state);
                showState(root.activeTransfer.state);
            }
        }

        Page {
            id: root
            anchors.fill: parent
            title: i18n.tr("Hub Exporter")
            visible: false
            flickable: imagesView
            property var activeTransfer
            property bool pickMode: (root.activeTransfer.state === ContentTransfer.InProgress &&
                                     root.activeTransfer.direction === ContentTransfer.Import)

            onPickModeChanged: {
                console.log("pickMode changed: " + root.pickMode);
                if (root.pickMode && pageStack.currentPage !== root)
                    pageStack.pop();
            }

            function __exportItems(item)
            {
                var results = [];
                if (item)
                    results.push(resultComponent.createObject(root, {"url": item}));
                else
                {
                    for (var i = 0; i < images.count; i++)
                    {
                        if (images.get(i).selected) {
                            if (images.get(i).contentType === ContentType.Text)
                                results.push(resultComponent.createObject(root, {"text": images.get(i).src}));
                            else
                                results.push(resultComponent.createObject(root, {"url": Qt.resolvedUrl(images.get(i).src)}));
                        }
                    }
                }
                if (results.length > 0)
                {
                    root.activeTransfer.items = results;
                    root.activeTransfer.state = ContentTransfer.Charged;
                }
            }

            function __getImageFromItem(item)
            {
                console.log("Get Image from:" + item)
                switch (item.contentType) {
                case ContentType.Pictures:
                    return Qt.resolvedUrl(item.src)
                case ContentType.Contacts:
                    return Qt.resolvedUrl("vcards/vcard.png")
                case ContentType.Text:
                    return Qt.resolvedUrl("text-plain.png")
                }
            }

            ListModel {
                id: images

                // Text
                ListElement {
                    src: "Some text to share"
                    selected: false
                    contentType: ContentType.Text
                }
                // Images
                ListElement {
                    src: "images/1.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/2.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/3.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/4.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/5.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/6.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/7.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/8.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/9.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/10.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/11.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/12.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/13.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/14.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/15.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/16.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/17.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }
                ListElement {
                    src: "images/18.jpg"
                    selected: false
                    contentType: ContentType.Pictures
                }

                // vCards
                ListElement {
                    src: "vcards/Joker.vcf"
                    selected: false
                    contentType: ContentType.Contacts
                }
                ListElement {
                    src: "vcards/Stark,_Tony.vcf"
                    selected: false
                    contentType: ContentType.Contacts
                }
            }

            GridView {
                id: imagesView
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    bottom: pickerButtons.top
                }
                model: images
                cellWidth: units.gu(20)
                cellHeight: cellWidth

                delegate: imageDelegate
            }

            Component {
                id: resultComponent
                ContentItem {}
            }

            Component {
                id: imageDelegate
                Item {
                    id: curItem
                    width: units.gu(19)
                    height: width

                    property string url: contentType === ContentType.Text ? src : Qt.resolvedUrl(src)
                    property string preview: root.__getImageFromItem(images.get(index))
                    property bool selected: selected

                    UbuntuShape {
                        height: parent.width
                        width: height
                        image: Image {
                            id: image
                            source: preview
                            height: parent.width
                            width: height
                            sourceSize.height: height
                            sourceSize.width: width
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }
                        Image {
                            id: selectionTick
                            anchors.right: parent.right
                            anchors.top: parent.top
                            width: units.gu(5)
                            height: units.gu(5)
                            visible: curItem.selected && root.pickMode
                            source: "photo-preview-selected-overlay.png"
                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: root.pickMode
                        onClicked: {
                            selected = !selected;
                            images.setProperty(index, "selected", selected);
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: !root.pickMode
                        onPressAndHold: {
                            PopupUtils.open(actPopComp, emptyItemForCaller);
                        }
                        onClicked: {
                            if (!actPopComp.visible)
                            {
                                // PopupUtils.open(actPopComp, emptyItemForCaller);
                                pageStack.push(imageView, {"url": url,
                                                   "preview": preview,
                                                   "contentType": contentType});

                            }
                        }
                    }

                    /* create an empty item centered in the image to align the popover to */
                    Item {
                        id: emptyItemForCaller
                        anchors.centerIn: parent
                        z: 100

                    }

                    Component {
                        id: actPopComp
                        ActionSelectionPopover {
                            id: actPop
                            delegate: ListItem.Standard {
                                text: action.text
                            }

                            actions: ActionList {
                                Action {
                                    text: "Open with..."
                                    onTriggered: {
                                        PopupUtils.close(actPop);
                                        if (contentType === ContentType.Text) {
                                            pageStack.push(picker, {"url": src,
                                                               "handler": ContentHandler.Destination,
                                                               "contentType": contentType});
                                        } else {
                                            pageStack.push(picker, {"url": url,
                                                               "handler": ContentHandler.Destination,
                                                               "contentType": contentType});
                                        }
                                    }
                                }
                                Action {
                                    text: "Share"
                                    onTriggered: {
                                        PopupUtils.close(actPop);
                                        if (contentType === ContentType.Text) {
                                            pageStack.push(picker, {"url": src,
                                                               "handler": ContentHandler.Share,
                                                               "contentType": contentType});
                                        } else {
                                            pageStack.push(picker, {"url": url,
                                                               "handler": ContentHandler.Share,
                                                               "contentType": contentType});
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Connections {
                target: root.activeTransfer
                onStateChanged: {
                    console.log("StateChanged: " + root.activeTransfer.state);
                    showState(root.activeTransfer.state);
                }
            }

            ListItem.Empty {
                id: pickerButtons
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    margins: units.gu(2)
                }
                visible: root.pickMode
                Button {
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                        margins: units.gu(2)
                    }
                    text: "Cancel"
                    onClicked: root.activeTransfer.state = ContentTransfer.Aborted;
                }

                Button {
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        margins: units.gu(2)
                    }
                    text: "Select"
                    onClicked: {
                        console.log("onClicked: charging");
                        root.__exportItems();
                    }
                }
            }
        }

        Page {
            id: imageView
            visible: false
            property var url
            property var contentType
            title: i18n.tr("Image details")
            property alias preview: image.source

            tools: ToolbarItems {
                ToolbarButton {
                    action: Action {
                        text: "Open with..."
                        iconName: "add"
                        onTriggered: {
                            pageStack.push(picker, {"url": imageView.url, "handler": ContentHandler.Destination, "contentType": imageView.contentType });
                        }
                    }
                }
                ToolbarButton {
                    action: Action {
                        text: "Share"
                        iconName: "contact-group"
                        onTriggered: {
                            pageStack.push(picker, {"url": imageView.url, "handler": ContentHandler.Share, "contentType": imageView.contentType });
                        }
                    }
                }
            }

            Image {
                id: image
                anchors.fill: parent
                sourceSize.height: height
                sourceSize.width: width
            }
        }

        Page {
            id: picker
            visible: false
            property var curTransfer
            property var url
            property var handler
            property alias contentType: peerPicker.contentType

            function __exportItems(url) {
                if (picker.curTransfer.state === ContentTransfer.InProgress)
                {
                    if (contentType !== ContentType.Text)
                        picker.curTransfer.items = [ resultComponent.createObject(root, {"url": url}) ];
                    else {
                        picker.curTransfer.items = [ resultComponent.createObject(root, {"text": url}) ];
                    }
                    picker.curTransfer.state = ContentTransfer.Charged;
                }
            }

            ContentPeerPicker {
                id: peerPicker

                visible: parent.visible
                contentType: ContentType.Pictures
                handler: picker.handler

                onPeerSelected: {
                    console.log("onPeerSelected!---------------------------!")
                    picker.curTransfer = peer.request();
                    pageStack.pop();
                    if (picker.curTransfer.state === ContentTransfer.InProgress) {
                        console.log("picker.url " + picker.url);
                        picker.__exportItems(picker.url);
                    }
                }

                onCancelPressed: {
                    console.log("onCancelPressed!---------------------------!")
                    pageStack.pop();
                }
            }

            Connections {
                target: picker.curTransfer
                onStateChanged: {
                    console.log("curTransfer StateChanged: " + picker.curTransfer.state);
                    showState(picker.curTransfer.state)
                    if (picker.curTransfer.state === ContentTransfer.InProgress)
                    {
                        picker.__exportItems(picker.url);
                    }
                }
            }
        }
    }
}

