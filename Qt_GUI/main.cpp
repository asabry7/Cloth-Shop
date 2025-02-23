#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <signal.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>        /* For mode constants */
#include <fcntl.h>           /* For O_* constants */
#include "IPC_part/ShopProcess.h"
#include "IPC_part/InventoryManagerProcess.h"

#define SHM_NAME "/cloth_shm"
#define SHM_PID_NAME "/updater_pid_shm"
#define MAX_CLOTH 100
#define BUFFER_SIZE 300


#include "DatabaseLoader.h"
#include "OrderManager.h"
#include "CartManager.h"
#include "SearchManager.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Register and expose DatabaseLoader to QML
    DatabaseLoader databaseLoader;
    OrderManager orderManager;
    CartManager cartManager;
    SearchManager searchManager;

    engine.rootContext()->setContextProperty("databaseLoader", &databaseLoader);

    engine.rootContext()->setContextProperty("orderManager", &orderManager);

    engine.rootContext()->setContextProperty("cartManager", &cartManager);

    engine.rootContext()->setContextProperty("searchManager", &searchManager);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);


    engine.loadFromModule("STM", "Main");




    /************************************************************** Loading the Database file ******************************************************************/

    /***********************************************************************************************************************************************************/
    return app.exec();
}
