#ifndef NOTIFIER_H
#define NOTIFIER_H

#include <QObject>

class Notifier : public QObject
{
    Q_OBJECT
public:
    explicit Notifier(QObject *parent = nullptr);
    Q_INVOKABLE void notify(QString messsage);

signals:

public slots:
};

#endif // NOTIFIER_H
