#include <QProcess>
#include "notifier.h"

Notifier::Notifier(QObject *parent) : QObject(parent)
{

}
void Notifier::notify(QString messsage)
{
    QString cmd = "notify-send ";
    cmd += "'";
    cmd += messsage;
    cmd += "'";
    QProcess::execute(cmd);
}
