// Copyright (C) 2014 - 2015 Leslie Zhai <xiang.zhai@i-soft.com.cn>

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import cn.com.isoft.qwx 1.0
import "global.js" as Global

Item {
    id: navigatorView
    width: parent.width; height: parent.height

    property var syncKey
    property var initObj

    Sync {
        id: syncObj
        onSyncKeyChanged: {
            Global.syncKey = syncObj.syncKey
        }
        Component.onCompleted: {
            if (Global.v2) {
                // TODO: from Init syncKey
                syncObj.postV2(Global.uin, Global.sid, Global.skey, navigatorView.syncKey)
            } else {
                syncObj.post(Global.uin, Global.sid, Global.skey, navigatorView.syncKey)
            }
        }
    }

    StatusNotify {
        id: statusNotifyObj
        Component.onCompleted: {
            if (Global.v2) {
                statusNotifyObj.postV2(Global.uin, Global.sid, Global.skey, Global.deviceId, Global.loginUserName)
            } else {
                statusNotifyObj.post(Global.uin, Global.sid, Global.skey, Global.deviceId, Global.loginUserName)
            }
        }
    }

    Monitor {
        id: monitorObj
        onNeedReSync: {
            if (Global.v2) {                                                       
                syncObj.postV2(Global.uin, Global.sid, Global.skey, navigatorView.syncKey)            } else {                                                            
                syncObj.post(Global.uin, Global.sid, Global.skey, navigatorView.syncKey)
            }
        }
    }

    Timer {                                                                        
        id: monitorTimer                                                              
        interval: 300000; running: true; repeat: true; triggeredOnStart: true 
        onTriggered: {
            if (Global.v2) {
                monitorObj.getV2(Global.uin, Global.sid, Global.skey, Global.deviceId, Global.syncKey)
            } else {
                monitorObj.get(Global.uin, Global.sid, Global.skey, Global.deviceId, Global.syncKey)
            }
        }
    }

    HeadImg {
        id: loginUserHeadImg
        v2: Global.v2                                             
        userName: Global.loginUserName
    }

    StackView {
        id:navigatorStackView
        anchors.fill: parent
        initialItem: Item {
            TabView {
                id: navigatorTabView
                width: parent.width; height: parent.height - navigatorHeader.height
                tabPosition: Qt.BottomEdge
                anchors.top: navigatorHeader.bottom

                IconTab {
                    title: "微信"
                    iconSource: "images/messages.png"
                    WXView {
                        contactList: navigatorView.initObj.contactList
                    }
                }

                IconTab {
                    title: "通讯录"
                    iconSource: "images/contacts.png"
                    ContactListView {}
                }

                IconTab {
                    title: "我"
                    iconSource: loginUserHeadImg.filePath
                    IView {}
                }

                style: TabViewStyle {
                    frameOverlap: 1 
                    tab: Rectangle {
                        color: "white"
                        implicitWidth: 100
                        implicitHeight: 60

                        CircleImage {
                            id: iconImage
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 3
                            imageSource: navigatorTabView.getTab(styleData.index).iconSource
                            width: 30; height: 30
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: iconImage.bottom
                            anchors.topMargin: 3
                            text: styleData.title
                            color: styleData.selected ? "#45c01a" : "#9b9b9b"
                            font.pixelSize: 12
                        }
                    }
                    frame: Rectangle { color: "white" }
                }
            }
        
            Rectangle {
                id: navigatorHeader 
                width: parent.width; height: 58
                anchors.top: parent.top
                color: "#20282a"
                                                                                   
                Text { 
                    text: "微信"
                    font.pixelSize: 22
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 19
                    color: "white"
                }
            }
        }
    }
}
