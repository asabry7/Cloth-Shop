#ifndef SEARCHMANAGER_H
#define SEARCHMANAGER_H

#include <QObject>

class SearchManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString searchText READ searchText WRITE setSearchText)

public:
    explicit SearchManager(QObject *parent = nullptr) : QObject(parent) {}

    QString searchText() const { return m_searchText; }

    void setSearchText(const QString &text) {
        if (m_searchText != text) {
            m_searchText = text;
        }
    }


private:
    QString m_searchText;
};

#endif // SEARCHMANAGER_H
