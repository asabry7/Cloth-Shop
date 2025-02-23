#ifndef ORDERMANAGER_H
#define ORDERMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QDebug>

class OrderManager : public QObject {
    Q_OBJECT
public:
    explicit OrderManager(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void addPlacedOrder(const QVariantMap &order) {
        placedOrders.append(order);
        qDebug() << "Order Placed:" << order;
    }

    Q_INVOKABLE QVariantList getPlacedOrders() const {
        return placedOrders;
    }

private:
    QVariantList placedOrders;
};

#endif // ORDERMANAGER_H
