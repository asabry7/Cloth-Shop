cmake_minimum_required(VERSION 3.16)

project(STM VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appSTM
    main.cpp
)

qt_add_qml_module(appSTM
    URI STM
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES DatabaseLoader.h
        RESOURCES
        QML_FILES SearchBar.qml
        QML_FILES TopBanner.qml
        QML_FILES Items.qml
        QML_FILES test.qml
        SOURCES OrderManager.h
        QML_FILES ShowAllOrders.qml
        SOURCES CartManager.h
        QML_FILES ShowAllCartItems.qml
        SOURCES SearchManager.h
        QML_FILES ShowRestock.qml

        SOURCES IPC_part/InventoryManagerProcess.cpp
        SOURCES IPC_part/InventoryManagerProcess.h
        SOURCES IPC_part/SharedData.h
        SOURCES IPC_part/ShopProcess.cpp
        SOURCES IPC_part/ShopProcess.cpp

)


qt_add_resources(appSTM
    PREFIX "/"
    FILES
    images/search.png
    images/cart.png
    images/stm.png
    images/location.png
    images/RAM.jpg
    images/tshirt.jpeg
    images/jeans.jpeg
    images/shoes.jpeg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSTM PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSTM
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSTM
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appSTM
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
