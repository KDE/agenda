import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15 as QQC2

import org.mauikit.controls 1.3 as Maui
import org.maui.calendar 1.0 as Kalendar

import "dateutils.js" as DateUtils

QQC2.Page
{
    id: control

    signal dateClicked(var date)
    signal dateRightClicked(var date)

    signal monthClicked(var date)
    signal monthRightClicked(var date)

    property bool compact : false

    property alias model : _monthModel
    property alias year: _monthModel.year
    property alias month : _monthModel.month


    padding: control.compact ? Maui.Style.space.small : Maui.Style.space.medium

    header: Maui.LabelDelegate
    {
        width: parent.width
        isSection: true
        color: viewLoader.isCurrentItem ? Maui.Theme.highlightColor : Maui.Theme.textColor
        label: _monthModel.monthName(modelData + 1)
    }

    background: Rectangle
    {
        color: viewLoader.isCurrentItem ? Maui.Theme.alternateBackgroundColor : control.hovered ? Maui.Theme.hoverColor : Maui.Theme.backgroundColor
        radius: Maui.Style.radiusV

        MouseArea
        {
            id: _mouseArea
            hoverEnabled: true
            anchors.fill: parent
            onClicked: control.monthClicked(new Date(control.year, modelData+1))
        }
    }

    GridLayout
    {
        anchors.fill: parent

        columns: 7
        rows: 7

        columnSpacing: control.compact ? 0 : Maui.Style.space.small
        rowSpacing:  control.compact ? 0 : Maui.Style.space.small

        Kalendar.MonthModel
        {
            id: _monthModel
        }

        Repeater
        {
            model: _monthModel

            delegate: QQC2.Button
            {
                Maui.Theme.colorSet: Maui.Theme.View
                Maui.Theme.inherit: false

                Layout.fillWidth: true
                Layout.fillHeight: true

                padding: 0

                highlighted: model.isToday

                checkable: true
                checked: model.isToday

                opacity: sameMonth ? 1 : 0.7

                text: model.dayNumber

                font.bold: model.isToday
                font.weight: checked ? Font.Bold : Font.Normal
                font.pointSize: control.compact ? Maui.Style.fontSizes.tiny : Maui.Style.fontSizes.medium

                onClicked: control.dateClicked(model.date)

                background: Rectangle
                {
                    visible: sameMonth
                    color: checked ? Maui.Theme.highlightColor : hovered ? Maui.Theme.focusColor : "transparent"
                    radius: Maui.Style.radiusV
                }
            }
        }
    }
}
