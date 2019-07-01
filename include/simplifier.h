#ifndef SIMPLIFIER_H
#define SIMPLIFIER_H

#include <QWidget>

class Simplifier : public QWidget
{
    Q_OBJECT
public:
    explicit Simplifier(QWidget *parent = nullptr);
    Q_INVOKABLE QString getSimple(QString string);

signals:

public slots:
};

#endif // SIMPLIFIER_H
