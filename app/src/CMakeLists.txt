# Copyright 2018-2021 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2021 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

set(project_SRCS
    code/main.cpp
    assets/assets.qrc
    )

qtquick_compiler_add_resources(project_QML_QRC controls/qml.qrc)

add_executable(${PROJECT_NAME}
    ${project_SRCS}
    ${project_QML_QRC}
    )

target_compile_definitions(${PROJECT_NAME}
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
    MauiKit
    MauiCalendarLib

    Qt5::Core
    Qt5::Quick
    Qt5::Widgets

    KF5::CoreAddons
    KF5::I18n

#    KF5::CalendarCore
#    KF5::AkonadiCore
#    KF5::AkonadiCalendar
#    KF5::AkonadiContact
#    KF5::AkonadiAgentBase
#    KF5::AkonadiXml
#    KF5::CalendarSupport
#    KF5::Contacts
    )

install(TARGETS ${PROJECT_NAME} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
