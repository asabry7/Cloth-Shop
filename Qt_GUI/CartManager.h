#ifndef CARTMANAGER_H
#define CARTMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QDebug>

class CartManager : public QObject {
    Q_OBJECT
public:
    explicit CartManager(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void addCartItem(const QVariantMap &item) {
        cartItems.append(item);
        qDebug() << "Item added to cart:" << item;
    }

    Q_INVOKABLE QVariantList getCartItems() const {
        return cartItems;
    }

    // 🔹 Add this function to clear the cart
    Q_INVOKABLE void clearCart() {
        cartItems.clear();
        qDebug() << "Cart cleared!";
    }

private:
    QVariantList cartItems;
};

#endif // CARTMANAGER_H
