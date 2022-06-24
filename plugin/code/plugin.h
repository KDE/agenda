#pragma once

#include <QObject>
#include <QQmlExtensionPlugin>


class MauiCalendarPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    void registerTypes(const char *uri) override;

    QString resolveFileUrl(const QString &filePath) const
    {
        return QStringLiteral("qrc:/maui/calendar/") + filePath;
    }
};
