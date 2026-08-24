// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Templates as T
import QtTest
import org.kde.breeze as Breeze

TestCase {
    id: testCase
    name: "ComboBoxSize"
    when: windowShown
    width: 1600
    height: 400

    readonly property string longText: "ABCDEFGHIJKLMNOPQRSTUVWXYZ".repeat(4)

    Component {
        id: fixtureComponent

        Item {
            id: fixture
            property alias control: combo
            property alias model: listModel
            property alias policy: combo.implicitContentWidthPolicy
            property alias editable: combo.editable
            property bool rtl: false

            ListModel {
                id: listModel
                ListElement { text: "A" }
                ListElement { text: "BBBBBBBB" }
            }

            Breeze.ComboBox {
                id: combo
                model: listModel
                textRole: "text"
                font.pixelSize: 16
                LayoutMirroring.enabled: fixture.rtl
            }
        }
    }

    function verifyTextFits(control) {
        const textField = control.contentItem;
        const available = textField.width - textField.leftPadding - textField.rightPadding;
        verify(available + 1 >= textField.contentWidth,
               "Available text width " + available + " must fit " + textField.contentWidth);
    }

    function test_sameCountModelUpdate_data() {
        return [
            { tag: "readonly-ltr", editable: false, rtl: false },
            { tag: "readonly-rtl", editable: false, rtl: true },
            { tag: "editable-ltr", editable: true, rtl: false },
            { tag: "editable-rtl", editable: true, rtl: true },
        ];
    }

    function test_sameCountModelUpdate(data) {
        const fixture = createTemporaryObject(fixtureComponent, testCase, {
            policy: T.ComboBox.WidestText,
            editable: data.editable,
            rtl: data.rtl,
        });
        verify(fixture !== null);
        const control = fixture.control;
        const previousWidth = control.implicitWidth;
        fixture.model.setProperty(1, "text", longText);
        compare(control.count, 2);
        control.currentIndex = 1;
        tryCompare(control.contentItem, "text", longText);
        tryVerify(() => control.implicitWidth > previousWidth);
        verifyTextFits(control);
    }

    function test_policyChangeRestoresContentSizing() {
        const fixture = createTemporaryObject(fixtureComponent, testCase, {
            policy: T.ComboBox.WidestText,
        });
        verify(fixture !== null);
        const control = fixture.control;
        control.implicitContentWidthPolicy = T.ComboBox.ContentItemImplicitWidth;
        control.displayText = longText;
        tryCompare(control.contentItem, "text", longText);
        verifyTextFits(control);
    }

    function test_completedPolicyInitialSize() {
        const fixture = createTemporaryObject(fixtureComponent, testCase, {
            policy: T.ComboBox.WidestTextWhenCompleted,
        });
        verify(fixture !== null);
        fixture.control.currentIndex = 1;
        tryCompare(fixture.control.contentItem, "text", "BBBBBBBB");
        verifyTextFits(fixture.control);
    }

    function test_fontChange() {
        const fixture = createTemporaryObject(fixtureComponent, testCase, {
            policy: T.ComboBox.WidestText,
        });
        verify(fixture !== null);
        const control = fixture.control;
        control.currentIndex = 1;
        const previousWidth = control.implicitWidth;
        control.font.pixelSize = 40;
        tryVerify(() => control.implicitWidth > previousWidth);
        verifyTextFits(control);
    }
}
