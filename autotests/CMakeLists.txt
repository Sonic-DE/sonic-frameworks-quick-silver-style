# SPDX-License-Identifier: BSD-2-Clause

add_executable(comboboxsizetest comboboxsizetest.cpp)
target_link_libraries(comboboxsizetest PRIVATE Qt6::QuickTest)
add_dependencies(comboboxsizetest BreezeStyle BreezeImpl)

add_test(NAME comboboxsizetest
    COMMAND comboboxsizetest -input ${CMAKE_CURRENT_SOURCE_DIR}
)
set_tests_properties(comboboxsizetest PROPERTIES ENVIRONMENT
    "QT_QPA_PLATFORM=offscreen;QT_QUICK_BACKEND=software;QT_QUICK_CONTROLS_STYLE=Basic;QML_DISABLE_DISK_CACHE=1;QML_IMPORT_PATH=${CMAKE_BINARY_DIR}/bin"
)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS Test)
add_executable(toolsareatest toolsareatest.cpp)
target_link_libraries(toolsareatest PRIVATE Qt6::Test Qt6::Qml Qt6::Quick Qt6::QuickControls2)
target_compile_definitions(toolsareatest PRIVATE PLUGIN_FILE="$<TARGET_FILE:org.kde.breeze>")
add_dependencies(toolsareatest org.kde.breeze BreezeStyle BreezeImpl)
add_test(NAME toolsareatest COMMAND toolsareatest)
set_tests_properties(toolsareatest PROPERTIES ENVIRONMENT
    "QT_QPA_PLATFORM=offscreen;QT_QUICK_BACKEND=software;QML_DISABLE_DISK_CACHE=1;QML_IMPORT_PATH=${CMAKE_BINARY_DIR}/bin"
)
