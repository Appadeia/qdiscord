#include "simplifier.h"

Simplifier::Simplifier(QWidget *parent) : QWidget(parent)
{

}
QString Simplifier::getSimple(QString string)
{
    return string.simplified().replace("\"", "\'");
}
