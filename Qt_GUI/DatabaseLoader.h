#ifndef DATABASELOADER_H
#define DATABASELOADER_H

#include <QObject>
#include <QVariantList>
#include <QFile>
#include <QTextStream>
#include <QDebug>

class DatabaseLoader : public QObject {
    Q_OBJECT
public:
    explicit DatabaseLoader(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE QVariantList loadClothes() {
        QVariantList clothesList;
        QFile file("/home/asabry/Documents/qtDir/STM/database.txt");

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qWarning() << "Error opening database file!";
            return clothesList;
        }

        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine();
            QStringList parts = line.split(",");

            if (parts.size() != 3) continue; // Skip invalid lines

            QVariantMap cloth;
            cloth["name"] = parts[0].trimmed();
            cloth["price"] = QString("%1 EGP").arg(parts[1].trimmed()); // Format price
            // Construct the image path dynamically using the name
            QString imageName = parts[0].trimmed().toLower().replace(" ", "_"); // Convert spaces to underscores
            cloth["image"] = QString("qrc:/images/%1.jpeg").arg(imageName);
            cloth["stock"] = QString("%1").arg(parts[2].trimmed()); // Format stock

            clothesList.append(cloth);
        }

        file.close();
        return clothesList;
    }

    Q_INVOKABLE bool updateStock(const QString &itemName, double price, int quantity) {
        QFile file("/home/asabry/Documents/qtDir/STM/database.txt");

        if (!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
            qWarning() << "Error opening database file for updating!";
            return false;
        }

        QTextStream in(&file);
        QStringList lines;
        bool itemFound = false;

        // Read all lines from the file
        while (!in.atEnd()) {
            QString line = in.readLine();
            QStringList parts = line.split(",");

            if (parts.size() != 3) {
                lines.append(line); // Keep invalid lines as they are
                continue;
            }

            QString currentItemName = parts[0].trimmed();
            if (currentItemName == itemName) {
                // Update the stock for the matching item
                int currentStock = parts[2].trimmed().toInt();
                int newStock = currentStock + quantity; // Add the restocked quantity
                line = QString("%1, %2, %3").arg(currentItemName).arg(price).arg(newStock);
                itemFound = true;
            }

            lines.append(line);
        }

        if (!itemFound) {
            // If the item doesn't exist, add it to the database
            lines.append(QString("%1, %2, %3").arg(itemName).arg(price).arg(quantity));
        }

        // Write the updated lines back to the file
        file.resize(0); // Clear the file content
        QTextStream out(&file);
        for (const QString &line : lines) {
            out << line << "\n";
        }

        file.close();
        emit databaseUpdated();
        return true;
    }
signals:
    void databaseUpdated(); // Signal to notify when the database is updated
};

#endif // DATABASELOADER_H
