import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui
import org.maui.calendar 1.0 as Cal

Maui.ApplicationWindow
{
    id: root
    title: qsTr("Astro")

    Maui.SideBarView
    {
        id: _sideBarView
        anchors.fill: parent

        sideBarContent:  Maui.Page
        {
            anchors.fill: parent
            Maui.Theme.colorSet: Maui.Theme.Window

            headBar.leftContent: [
                Maui.ToolButtonMenu
                {
                    icon.name: "application-menu"
                    MenuItem
                    {
                        text: i18n("Settings")
                        icon.name: "settings-configure"
                    }

                    MenuItem
                    {
                        text: i18n("About")
                        icon.name: "documentinfo"
                        onTriggered: root.about()
                    }
                }

            ]

            headBar.rightContent: [
                ToolButton
                {
                    icon.name: "list-add"
                }

            ]

            Maui.Holder
            {
                anchors.fill: parent
                visible: true

                emoji: "view-calendar"
                title: Qt.formatDateTime(_stackView.currentItem.selectedDate, "dd MMM yyyy")
                body: "No events for this day"
            }
        }

        Maui.Page
        {
            anchors.fill: parent
            showCSDControls: true
            title: _stackView.currentItem.title
            headBar.background: null
            headBar.leftContent: [
                ToolButton
                {
                    icon.name: "sidebar-collapse"
                    onClicked: _sideBarView.sideBar.toggle()
                    checked: _sideBarView.sideBar.visible
                },

                ToolButton
                {
                    icon.name: "go-previous"
                    onClicked: _stackView.pop()
                    visible: _stackView.depth === 2
                    text: _yearView.title
                }
            ]

            headBar.rightContent: Maui.ToolActions
            {
                autoExclusive: false
                checkable: false

                Action
                {
                    icon.name: "go-previous"
                    text: i18n("Previous Year")
                    shortcut: "Left"
                    onTriggered: monthPage.year--
                }

                Action
                {
                    icon.name: "go-jump-today"
                    text: i18n("Today")
                    onTriggered: monthPage.year = currentDate.getUTCFullYear()
                }

                Action
                {
                    icon.name: "go-next"
                    text: i18n("Next Year")
                    shortcut: "Right"
                    onTriggered: monthPage.year++
                }
            }

            //            headBar.middleContent: Maui.ToolActions
            //            {
            //                Layout.alignment: Qt.AlignCenter
            //                expanded: true
            //                autoExclusive: true

            //                Action
            //                {
            //                    text: i18n("Year")
            //                    onTriggered: _loaderView.sourceComponent = _yearViewComponent
            //                }

            //                Action
            //                {
            //                    text: i18n("Month")
            //                    onTriggered: _loaderView.sourceComponent = _monthViewComponent
            //                }

            //                Action
            //                {
            //                    text: i18n("Week")
            //                    onTriggered: _loaderView.sourceComponent = _weekViewComponent

            //                }
            //            }


            StackView
            {
                id:_stackView
                anchors.fill: parent
                clip: true
                initialItem: Cal.YearView
                {
                    id: _yearView
                    headBar.visible: false
                    onMonthClicked:
                    {
                        _stackView.push(_monthView)
                        _monthView.setToDate(date)
                    }
                }


                Cal.MonthView
                {
                    id: _monthView
                    headBar.visible: false

                    //                    visible: StackView.status === StackView.Active
                }


                pushExit: Transition
                {
                    ParallelAnimation
                    {
                        PropertyAnimation
                        {
                            //                        target: _yearView.gridView.currentItem
                            property: "scale"
                            from: 1
                            to: 4
                            duration: 200
                            easing.type: Easing.InOutCubic
                        }

                        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200; easing.type: Easing.InOutCubic }
                    }

                }

                pushEnter: Transition
                {
                    ParallelAnimation
                    {
                        PropertyAnimation
                        {
                            //                        target: _yearView.gridView.currentItem
                            property: "scale"
                            from: 0
                            to: 1
                            duration: 200
                            easing.type: Easing.OutCubic
                        }

                        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200; easing.type: Easing.OutCubic }
                    }
                }

                popEnter: Transition
                {
                    ParallelAnimation
                    {
                        PropertyAnimation
                        {
                            //                        target: _yearView.gridView.currentItem
                            property: "scale"
                            from: 4
                            to: 1
                            duration: 200
                            easing.type: Easing.InOutCubic
                        }

                        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200; easing.type: Easing.InOutCubic }
                    }
                }

                popExit: Transition
                {
                    ParallelAnimation
                    {
                        PropertyAnimation
                        {
                            //                        target: _yearView.gridView.currentItem
                            property: "scale"
                            from: 1
                            to: 0
                            duration: 200
                            easing.type: Easing.OutCubic
                        }

                        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200; easing.type: Easing.OutCubic }
                    }

                }
            }
        }

    }

}
