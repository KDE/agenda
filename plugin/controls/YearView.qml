// Copyright (C) 2018 Michael Bohlender, <bohlender@kolabsys.com>
// Copyright (C) 2018 Christian Mollekopf, <mollekopf@kolabsys.com>
// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15 as QQC2

import org.mauikit.controls 1.3 as Maui
import org.maui.calendar 1.0 as Kalendar

import "dateutils.js" as DateUtils

Maui.Page
{
    id: monthPage


    property date selectedDate: currentDate
    property date currentDate: new Date()
    Timer
    {
        interval: 5000;
        running: true
        repeat: true
        onTriggered: currentDate = new Date()
    }


    signal monthClicked(var date)

    property date startDate
    property date firstDayOfMonth
    property int year : currentDate.getUTCFullYear()
    property bool initialMonth: true
    readonly property bool isLarge: width > Maui.Style.units.gridUnit * 40
    readonly property bool isTiny: width <= Maui.Style.units.gridUnit * 40
property alias gridView :_gridView

    headBar.background: null
    title: monthPage.year


    GridView
    {
        id: _gridView

        anchors.fill: parent
        anchors.margins : Maui.Style.space.medium

        focus: true
        cellHeight: cellWidth
        cellWidth: width/3
        currentIndex: currentDate.getUTCMonth()
        model: 12

        delegate: Loader
        {
            id: viewLoader

            property bool isNextOrCurrentItem: index >= _gridView.currentIndex -1 && index <= _gridView.currentIndex + 1
            property bool isCurrentItem: GridView.isCurrentItem

            active: true
            asynchronous: !isCurrentItem
            visible: status === Loader.Ready

            width: GridView.view.cellWidth - Maui.Style.space.small
            height: GridView.view.cellHeight - Maui.Style.space.small

            sourceComponent: QQC2.Page
            {

                property alias model : _monthModel
                padding: Maui.Style.space.medium

                header: Maui.LabelDelegate
                {
                    width: parent.width
                    isSection: true
                    label: _monthModel.monthName(modelData + 1)
                }

                background: Rectangle
                {
                    color: viewLoader.isCurrentItem ? Maui.Theme.alternateBackgroundColor : Maui.Theme.backgroundColor
                    radius: Maui.Style.radiusV

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: monthClicked(new Date(monthPage.year, modelData+1))
                    }
                }

                GridLayout
                {
                    anchors.fill: parent
                    columns: 7
                    rows: 7
                    columnSpacing: monthPage.isTiny ? 0 : Maui.Style.space.small
                    rowSpacing:  monthPage.isTiny ? 0 : Maui.Style.space.small

                    Kalendar.MonthModel
                    {
                        id: _monthModel
                        year: monthPage.year
                        month: modelData+1
                    }

                    Repeater
                    {
                        model: _monthModel.weekDays
                        delegate: QQC2.Label
                        {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            horizontalAlignment: Text.AlignHCenter
                            opacity: 0.7
                            text: monthPage.isTiny ? modelData.slice(0,1) : modelData
                            font.bold: monthPage.isLarge
                            font.weight: monthPage.isLarge  ? Font.Bold : Font.Normal
                            font.pointSize: monthPage.isTiny ? Maui.Style.fontSizes.tiny : Maui.Style.fontSizes.medium
                        }
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
                            font.pointSize: monthPage.isTiny ? Maui.Style.fontSizes.tiny : Maui.Style.fontSizes.medium
                            onClicked: monthPage.selectedDate = model.date

                            background: Rectangle
                            {
                                visible: sameMonth && monthPage.isLarge
                                color: checked ? Maui.Theme.highlightColor : hovered ? Maui.Theme.hoverColor : Maui.Theme.alternateBackgroundColor
                                radius: Maui.Style.radiusV

                            }
                        }

                    }

                }
            }
        }
    }
}

