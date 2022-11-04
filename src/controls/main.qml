import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Cal

Maui.ApplicationWindow
{
    id: root
    title: qsTr("Astro")


    Maui.Dialog
    {
        id: _eventDialog
        headBar.visible: false
        acceptButton.text: i18n("Create")

        onRejected: close()

        onAccepted:
        {
            Cal.CalendarManager.addIncidence(_eventPage.incidence)
        }

        Cal.EventPage
        {
            id: _eventPage
            Layout.fillWidth: true
        }
    }

    Action
    {
        id: _newEventAction
        text: "New event"
        icon.name: "new-event"
        onTriggered: _eventDialog.open()
    }

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
                        contentItem: Column
                        {
                            Repeater
                            {
                                model: Cal.CalendarManager.collections
                                delegate: MenuItem
                                {
                                    width: parent.width
                                    checkable: true
                                    text: model.display

                                    checked: model.checkState === 2
                                                                    onTriggered: model.checkState = model.checkState === 0 ? 2 : 0

                                }
                            }
                        }
                    }

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
                    action: _newEventAction
                }

            ]


            Maui.ListBrowser
            {
                anchors.fill: parent
                holder.visible: count === 0

                holder.emoji: "view-calendar"
                holder.title: Qt.formatDateTime(_stackView.currentItem.selectedDate, "dd MMM yyyy")
                holder.body: "No events for this day"

                model: Cal.IncidenceOccurrenceModel
                {
                    start: _stackView.currentItem.selectedDate
                    length: 0
                    calendar: Cal.CalendarManager.calendar
                    filter: Cal.Filter
                }

                delegate: Maui.ListBrowserDelegate
                {
                    width: ListView.view.width

                    property var data : model.incidences
                    label1.text: model.summary
                    label2.text: model.startTime.toLocaleTimeString()
                }

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
                display: ToolButton.IconOnly

                Action
                {
                    icon.name: "go-previous"
                    text: i18n("Previous Year")
                    shortcut: "Left"
                    onTriggered: _stackView.currentItem.previousDate()
                }

                Action
                {
                    icon.name: "go-jump-today"
                    text: i18n("Today")
                    onTriggered: _stackView.currentItem.resetDate()
                }

                Action
                {
                    icon.name: "go-next"
                    text: i18n("Next Year")
                    shortcut: "Right"
                    onTriggered: _stackView.currentItem.nextDate()
                }
            }

            StackView
            {
                id:_stackView
                anchors.fill: parent
                clip: true
                initialItem: Cal.YearView
                {
                    id: _yearView
                    onMonthClicked:
                    {
                        _stackView.push(_monthViewComponent)
                        _stackView.currentItem.setToDate(_stackView.currentItem.addMonthsToDate(date, -1))
                    }
                }


                Component
                {
                    id: _monthViewComponent
                    Cal.MonthView
                    {

                    }
                }



                pushExit: Transition
                {
                    ParallelAnimation
                    {
                        PropertyAnimation
                        {
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
