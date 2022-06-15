import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui

Maui.ApplicationWindow
{
    id: root
    title: qsTr("Astro")

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

    Maui.Holder
    {
        anchors.fill: parent
        visible: true

        emoji: Maui.App.iconName
        title: Maui.App.about.displayName
        body: Maui.App.about.shortDescription
    }
}
