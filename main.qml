import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import com.qt.CModel 1.0

Window {
    visible: true
    width: 1280
    height: 480
    title: qsTr("股票信息")

    Rectangle {
        width: 1024
        height: 400

        ColumnLayout {
            anchors.top: parent.top;
            anchors.topMargin: 4;
            anchors.left: parent.left;
            anchors.leftMargin: 4;
            height: 180;
            spacing: 4;

            RowLayout {
                id: row_top;
                Text {
                    text: qsTr("股票代码");
                    color: "blue";
                    font {bold:true; pixelSize: 24;}
                }
                TextInput {
                    id: textInput_Code;
                    width: 100;
                    font.pixelSize: 24;
                    maximumLength: 6
                    validator: RegExpValidator{regExp:/[0-9][0-9][0-9][0-9][0-9][0-9]/}
                    focus: true;
                    text: "000001";
                }
                Button {
                    id: addStock;
                    text: qsTr("添加")
                    onClicked: {
                        console.log("add code : " + textInput_Code.text)
                    }
                }
                Text {
                    text: qsTr("代码只能是数字，一次添加一个；");
                    color: "green";
                    font {bold:false; pixelSize: 24;}
                }
            }

            Component {
                id: stockDelegate;
                Item {
                    id: wrapper;
                    width: parent.width;
                    height: 30;

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: wrapper.ListView.view.currentIndex = index;
                    }

                    RowLayout {
                        anchors.left: parent.left;
                        anchors.verticalCenter: parent.verticalCenter;
                        spacing: 8;
                        Text {
                            id: col_1;
                            text: code;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 100;
                        }
                        Text {
                            text: name;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 100;
                        }
                        Text {
                            text: latestPrice;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 80;
                        }
                        Text {
                            text: change;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 80;
                        }
                        Text {
                            text: quoteChange;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 80;
                        }
                        Text {
                            text: highestLowest;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 120;
                        }
                        Text {
                            text: takeProfitStopLoss;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 120;
                        }
                    }
                }
            }
            Component {
                id: stockModel;
                ListModel {
                    ListElement {
                        code: "1";
                        name: "2";
                        latestPrice: "3";
                        change: "4";
                        quoteChange: "5";
                        highestLowest: "6";
                        takeProfitStopLoss: "7";
                    }
                    ListElement {
                        code: "21";
                        name: "22";
                        latestPrice: "23";
                        change: "24";
                        quoteChange: "25";
                        highestLowest: "26";
                        takeProfitStopLoss: "27";
                    }
                }
            }
            Component {
                id: headerView;
                Item {
                    width: parent.width;
                    height: 30;
                    RowLayout {
                        anchors.left: parent.left;
                        anchors.verticalCenter: parent.verticalCenter;
                        spacing: 8;
                        Text {
                            text: qsTr("代码");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 100;
                        }
                        Text {
                            text: qsTr("名字");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 100;
                        }
                        Text {
                            text: qsTr("最新价");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 80;
                        }
                        Text {
                            text: qsTr("涨跌额");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 80;
                        }
                        Text {
                            text: qsTr("涨跌幅");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 80;
                        }
                        Text {
                            text: qsTr("最高/最低");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 120;
                        }
                        Text {
                            text: qsTr("止盈/止损");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 120;
                        }
                    }
                }
            }
            Component {
                id: footerView;
                Text {
                    width: parent.width;
                    font.italic: true;
                    color: "blue";
                    height: 30;
                    verticalAlignment: Text.AlignVCenter;
                }
            }

            RowLayout {
                Rectangle {
                    id: rectangle_Information;
                    width: 700
                    height: 400

                    //anchors.top: row_top.bottom;
                    //anchors.topMargin: 4;
                    ListView {
                        id: listView;
                        anchors.fill: parent;

                        delegate: stockDelegate;
                        //model: stockModel.createObject(listView);
                        model: StockListModel{source: "stocks.xml";}
                        header: headerView;
                        footer: footerView;
                        highlight: Rectangle {
                            color: "lightblue";
                        }

                        add: Transition {
                            ParallelAnimation {
                                NumberAnimation {
                                    property: "opacity";
                                    from: 0;
                                    to: 1.0;
                                    duration: 1000;
                                }
                                NumberAnimation {
                                    property: "y";
                                    from: 0;
                                    duration: 1000;
                                }
                            }
                        }

                        onCurrentIndexChanged: {
                            if(listView.currentIndex >= 0) {
                                var data = listView.model.get(listView.currentIndex);
                                listView.footerItem.text = data.code + ", " +
                                        data.name + ", " +
                                        data.latestPrice + ", " +
                                        data.change + ", " +
                                        data.quoteChange + ", " +
                                        data.highestLowest + ", " +
                                        data.takeProfitStopLoss;
                                if(listView.currentIndex % 2) {
                                    canvas_Min.minuteLine = canvas_Min.minuteLine1;
                                } else {
                                    canvas_Min.minuteLine = canvas_Min.minuteLine2;
                                }
                                canvas_Min.loadImage(canvas_Min.minuteLine);
                                canvas_Min.clear_canvas();
                                canvas_Min.requestPaint();
                            } else {
                                listView.footerItem.text = "";
                            }
                        }
                    }
                }
                Canvas {
                    id: canvas_Min;
                    //anchors.left: rectangle_Information.right;
                    //anchors.leftMargin: 4;
                    width: 545;
                    height: 300;
                    property var minuteLine1: "http://image.sinajs.cn/newchart/min/n/sz000001.gif";
                    property var minuteLine2: "http://image.sinajs.cn/newchart/min/n/sh000002.gif";

                    property var minuteLine: ""

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.drawImage(minuteLine, 0, 0);
                    }
                    Component.onCompleted: {
                        minuteLine = minuteLine1;
                        loadImage(minuteLine);
                    }
                    onImageLoaded: requestPaint();
                    function clear_canvas() {
                        var ctx = getContext("2d");
                        ctx.reset();
                    }
                }
            }
        }
        Component.onCompleted: {

        }
    }
}
