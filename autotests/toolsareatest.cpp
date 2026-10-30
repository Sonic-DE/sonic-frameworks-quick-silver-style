// SPDX-FileCopyrightText: 2026 Joseph Crowell <joseph.w.crowell@gmail.com>
// SPDX-License-Identifier: GPL-2.0-or-later

// What the platform theme publishes on the application (_sonic_tools_area_*) reaches
// Kirigami.Theme.toolsArea through this style's Kirigami platform plugin, live.

#include <QDir>
#include <QFile>
#include <QPalette>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQuickWindow>
#include <QStandardPaths>
#include <QTemporaryDir>
#include <QTest>

class ToolsAreaTest : public QObject {
    Q_OBJECT

private Q_SLOTS:
    void initTestCase();
    void testWithoutToolsArea();
    void testPublishedValuesReachTheTheme();

private:
    static void publish(bool on);
    QObject* root() const;

    QTemporaryDir m_plugins;
    QQmlApplicationEngine engine;
};

void ToolsAreaTest::initTestCase()
{
    QStandardPaths::setTestModeEnabled(true);
    // The plugin just built, where Kirigami looks for it.
    const QString platform = m_plugins.filePath(QStringLiteral("kf6/kirigami/platform"));
    QVERIFY(QDir().mkpath(platform));
    QVERIFY(QFile::copy(QStringLiteral(PLUGIN_FILE), platform + QLatin1Char('/') + QFileInfo(QStringLiteral(PLUGIN_FILE)).fileName()));
    QCoreApplication::addLibraryPath(m_plugins.path());
    QQuickStyle::setStyle(QStringLiteral("org.kde.breeze"));
    engine.load(QFINDTESTDATA("toolsareatest.qml"));
    QCOMPARE(engine.rootObjects().size(), 1);
}

QObject* ToolsAreaTest::root() const
{
    return engine.rootObjects().constFirst();
}

void ToolsAreaTest::publish(bool on)
{
    static int serial = 0;
    QPalette palette;
    QColor active(10, 20, 30);
    active.setAlphaF(0.5);
    palette.setColor(QPalette::Active, QPalette::Window, active);
    palette.setColor(QPalette::Inactive, QPalette::Window, QColor(40, 50, 60));
    qApp->setProperty("_sonic_tools_area_headerColors", on ? QVariant::fromValue(palette) : QVariant());
    qApp->setProperty("_sonic_tools_area_separatorColor", on ? QVariant::fromValue(QColor(1, 2, 3)) : QVariant());
    qApp->setProperty("_sonic_tools_area_blurBehind", on ? QVariant(true) : QVariant());
    qApp->setProperty("_sonic_tools_area_opaqueWhenMaximized", on ? QVariant(true) : QVariant());
    qApp->setProperty("_sonic_tools_area_titleBarHidden", on ? QVariant(true) : QVariant());
    qApp->setProperty("_sonic_tools_area_translucent", on ? QVariant(true) : QVariant());
    qApp->setProperty("_sonic_tools_area_serial", ++serial);
}

void ToolsAreaTest::testWithoutToolsArea()
{
    QCOMPARE(root()->property("active").toBool(), false);
    QVERIFY(!root()->property("separatorColor").value<QColor>().isValid());
}

void ToolsAreaTest::testPublishedValuesReachTheTheme()
{
    publish(true);
    QTRY_COMPARE(root()->property("active").toBool(), true);
    QColor active(10, 20, 30);
    active.setAlphaF(0.5);
    QCOMPARE(root()->property("backgroundColor").value<QColor>(), active);
    QCOMPARE(root()->property("inactiveBackgroundColor").value<QColor>(), QColor(40, 50, 60));
    QCOMPARE(root()->property("separatorColor").value<QColor>(), QColor(1, 2, 3));
    QCOMPARE(root()->property("blurBehind").toBool(), true);
    QCOMPARE(root()->property("translucent").toBool(), QQuickWindow::hasDefaultAlphaBuffer());

    publish(false);
    QTRY_COMPARE(root()->property("active").toBool(), false);
}

QTEST_MAIN(ToolsAreaTest)

#include "toolsareatest.moc"
