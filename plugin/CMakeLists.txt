# Copyright 2018-2021 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2021 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

cmake_minimum_required(VERSION 3.16)

project(MauiCalendarLib VERSION ${MAUICALENDAR_VERSION})

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(REQUIRED_KF5_VERSION 5.77.0)

set(AKONADI_VERSION "5.19.0")
set(AKONADI_CONTACT_VERSION "5.19.0")
set(CALENDARSUPPORT_LIB_VERSION "5.19")
set(EVENTVIEW_LIB_VERSION "5.19.0")

find_package(ECM ${REQUIRED_KF5_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMInstallIcons)
include(ECMAddAppIcon)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)
include(ECMSetupVersion)
include(ECMSourceVersionControl)
include(FeatureSummary)
include(ECMQMLModules)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick Widgets REQUIRED)

find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick Widgets REQUIRED)

find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS I18n CoreAddons Config)

find_package(Qt5QuickCompiler)
set_package_properties(Qt5QuickCompiler PROPERTIES
    DESCRIPTION "Compile QML at build time"
    TYPE OPTIONAL
    )

find_package(MauiKit)

find_package(KF5Akonadi ${AKONADI_VERSION} CONFIG REQUIRED)
find_package(KF5AkonadiContact ${AKONADI_CONTACT_VERSION} CONFIG REQUIRED)
find_package(KF5CalendarSupport ${CALENDARSUPPORT_LIB_VERSION} CONFIG REQUIRED)
find_package(KF5EventViews ${EVENTVIEW_LIB_VERSION} CONFIG REQUIRED)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/code
    ${CMAKE_CURRENT_SOURCE_DIR}/code/models
    )

file(GLOB model_SRCS

     "models/*.cpp"
)

set(lib_SRCS
    code/plugin.cpp
#    code/calendarmanager.cpp
#    code/incidencewrapper.cpp
#    code/agentconfiguration.cpp

    code/models/infinitecalendarviewmodel.cpp
    code/models/hourlyincidencemodel.cpp
    code/models/multidayincidencemodel.cpp
    code/models/incidenceoccurrencemodel.cpp
    code/models/monthmodel.cpp
    code/models/timezonelistmodel.cpp
#    assets/assets.qrc
    )

set(lib_HDRS
    code/plugin.h
#    assets/assets.qrc
    )

qtquick_compiler_add_resources(lib_QML_QRC controls/qml.qrc)

add_library(${PROJECT_NAME}
    ${lib_SRCS}
    ${model_SRCS}
    ${lib_HDRS}
    ${lib_QML_QRC}
    )

target_link_libraries(${PROJECT_NAME}
    PRIVATE
    MauiKit

    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Widgets

    KF5::CoreAddons
    KF5::I18n
    KF5::ConfigCore

    KF5::CalendarCore
    KF5::AkonadiCore
    KF5::AkonadiCalendar
    KF5::AkonadiContact
    KF5::AkonadiAgentBase
    KF5::AkonadiXml
    KF5::CalendarSupport
    KF5::Contacts
    )

install(FILES
    ${lib_HDRS}
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/Maui/Calendar
    COMPONENT Devel)

if (BUILD_SHARED_LIBS)
    add_custom_target(copy_calendar_to_bin ALL
        COMMAND ${CMAKE_COMMAND} -E
        make_directory ${CMAKE_BINARY_DIR}/bin/org/maui/calendar/
        COMMAND ${CMAKE_COMMAND} -E
        copy ${CMAKE_CURRENT_SOURCE_DIR}/controls/qmldir ${CMAKE_BINARY_DIR}/bin/org/maui/calendar/
        COMMAND ${CMAKE_COMMAND} -E
        copy $<TARGET_FILE:${PROJECT_NAME}> ${CMAKE_BINARY_DIR}/bin/org/maui/calendar/
        )

        install(FILES controls/qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/maui/calendar)

endif()

install(TARGETS ${PROJECT_NAME} DESTINATION ${KDE_INSTALL_QMLDIR}/org/maui/calendar )
