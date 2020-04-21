import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import com.qt.CModel 1.0

Window {
    visible: true
    width: 1920
    height: 800
    title: qsTr("股票信息")

    Rectangle {
        width: 1500
        height: 800

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
                        if(textInput_Code.text.length == 6)
                            listView.model.add(textInput_Code.text);
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
                            text: today_start_price;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 120;
                        }
                        Text {
                            text: yesterday_end_price;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 120;
                        }
                        Text {
                            text: current_price;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 120;
                        }
                        Text {
                            text: today_highestLowest;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 160;
                        }
                        Text {
                            text: trans_total;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 180;
                        }
                        Text {
                            text: trans_amount;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 160;
                        }
                        Text {
                            text: update_date_time;
                            color: wrapper.ListView.isCurrentItem ? "red" : "black";
                            font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                            Layout.preferredWidth: 280;
                        }
                    }
                }
            }
            Component {
                id: headerView;
                Item {
                    width: parent.width;
                    height: 30;
                    z: 2;
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
                            text: qsTr("今日开盘价");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 120;
                        }
                        Text {
                            text: qsTr("昨日收盘价");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 120;
                        }
                        Text {
                            text: qsTr("当前价格");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 120;
                        }
                        Text {
                            text: qsTr("今日最高/低价");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 160;
                        }
                        Text {
                            text: qsTr("成交的股票数(百股)");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 180;
                        }
                        Text {
                            text: qsTr("成交金额(万元)");
                            font.bold: true;
                            font.pixelSize: 20;
                            Layout.preferredWidth: 160;
                        }
                        Rectangle {
                            width: 180;
                            height: parent.height;
                            Text {
                                anchors.centerIn: parent;
                                text: qsTr("更新日期时间");
                                font.bold: true;
                                font.pixelSize: 20;
                                Layout.preferredWidth: 280;
                            }
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
                    width: 1365
                    height: 620

                    //anchors.top: row_top.bottom;
                    //anchors.topMargin: 4;
                    ListView {
                        id: listView;
                        anchors.fill: parent;
                        headerPositioning : ListView.OverlayHeader

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
                                var code = listView.model.get(listView.currentIndex, 0);
                                var name = listView.model.get(listView.currentIndex, 1);
                                listView.footerItem.text = code + ", " + name;
                                canvas_Min.minuteLine = "http://image.sinajs.cn/newchart/min/n/" + code + ".gif";
                                canvas_Min.loadImage(canvas_Min.minuteLine);
                                canvas_Min.clear_canvas();
                                canvas_Min.requestPaint();
                                canvas_K_daily.minuteLine = "http://image.sinajs.cn/newchart/daily/n/" + code + ".gif";
                                canvas_K_daily.loadImage(canvas_K_daily.minuteLine);
                                canvas_K_daily.clear_canvas();
                                canvas_K_daily.requestPaint();
                            } else {
                                listView.footerItem.text = "";
                            }
                        }
                    }
                }
                ColumnLayout {
                    Canvas {
                        id: canvas_Min;
                        //anchors.left: rectangle_Information.right;
                        //anchors.leftMargin: 4;
                        width: 545;
                        height: 300;
                        property var minuteLine: "http://image.sinajs.cn/newchart/min/n/sz000001.gif";

                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.drawImage(minuteLine, 0, 0);
                        }
                        Component.onCompleted: {
                            loadImage(minuteLine);
                        }
                        onImageLoaded: requestPaint();
                        function clear_canvas() {
                            var ctx = getContext("2d");
                            ctx.reset();
                        }
                    }
                    Canvas {
                        id: canvas_K_daily;
                        //anchors.left: rectangle_Information.right;
                        //anchors.leftMargin: 4;
                        width: 545;
                        height: 300;
                        property var minuteLine: "http://image.sinajs.cn/newchart/daily/n/sz000001.gif";

                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.drawImage(minuteLine, 0, 0);
                        }
                        Component.onCompleted: {
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
        }
        Component.onCompleted: {

        }
    }
}
