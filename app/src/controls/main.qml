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
            title: "Events"
            body: "No events for this day"
        }

        Maui.Page
        {
            anchors.fill: parent
            headBar.leftContent: Maui.ToolButtonMenu
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

            headBar.middleContent: Maui.ToolActions
            {
                Layout.alignment: Qt.AlignCenter
                expanded: true
                autoExclusive: true

                Action
                {
                    text: i18n("Year")
                }

                Action
                {
                    text: i18n("Month")
                }

                Action
                {
                    text: i18n("Week")
                }
            }

            Cal.MonthView
            {
                anchors.fill: parent
            }
        }
    }

}
