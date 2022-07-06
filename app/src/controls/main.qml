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

        sideBarContent:   Maui.Holder
        {
            anchors.fill: parent
            visible: true

            emoji: "view-calendar"
            title: Qt.formatDateTime(_appViews.currentItem.selectedDate, "dd MMM yyyy")
            body: "No events for this day"
        }

        Maui.AppViews
        {
            id: _appViews
            anchors.fill: parent
            showCSDControls: true
            headBar.leftContent: [Maui.ToolButtonMenu
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
                },
                ToolButton
                {
                    icon.name: "sidebar-collapse"
                    onClicked: _sideBarView.sideBar.toggle()
                    checked: _sideBarView.sideBar.visible
                }

            ]

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


                Cal.MonthView
                {
                    id: _monthView
                     Maui.AppView.title: i18n("Month")
                }


            Maui.AppViewLoader
            {
                Maui.AppView.title: i18n("Year")

                Cal.YearView
                {
                    onMonthClicked:
                    {
                        _appViews.currentIndex = 0
                        _monthView.setToDate(date)
                    }
                }
            }

            //                Maui.AppViewLoader
            //                {
            //                    id: _weekViewComponent
            //                    Cal.HourlyView
            //                    {
            //                    }
            //                }
        }



    }

}
