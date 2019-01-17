/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import XCTest

class TranslationSnackBarTest: BaseTestCase {
    
    // // This test checks to the correct functionalty of the Translation prompt and Translation is done corrrectly using Google
    func testSnackBarDisplayed() {
        userState.localeIsExpectedDifferent = true
        navigator.openURL(path(forTestPage: "manifesto-zh-CN.html"))
        waitUntilPageLoad()
        navigator.goto(TranslatePageMenu)
        waitForExistence(app.buttons["TranslationPrompt.doTranslate"])
        app.buttons["TranslationPrompt.doTranslate"].tap()
        waitForValueContains(app.textFields["url"], value: "translate.google")
        if iPad(){
                app.buttons["URLBarView.backButton"].tap()
        } else{
                app.buttons["TabToolbar.backButton"].tap()
        }
        app.buttons["TranslationPrompt.dontTranslate"].tap()
        XCTAssertFalse(app.buttons["TranslationPrompt.dontTranslate"].exists)
    }
    
    // This test checks to see if Translation is enabled by default from the Settings menu and can be correctly disabled
    func testSnackBarNotDispalyed() {
        navigator.goto(TranslationSettings)
        let translationToggle = app.tables.cells.element(boundBy:0)
        XCTAssertTrue(translationToggle.isEnabled)
        translationToggle.tap()
        navigator.openURL(path(forTestPage: "manifesto-zh-CN.html"))
        waitUntilPageLoad()
        XCTAssertFalse(app.buttons["TranslationPrompt.dontTranslate"].exists)
    }
    
    // This test checks to see if Translation is correctly done when using Bing
    func testTranslateBing() {
        navigator.goto(TranslationSettings)
        app.tables["Translate.Setting.Options"].staticTexts["Bing"].tap()
        navigator.openURL(path(forTestPage: "manifesto-zh-CN.html"))
        waitUntilPageLoad()
        //navigator.goto(TranslatePageMenu)
        waitForExistence(app.buttons["TranslationPrompt.doTranslate"])
        app.buttons["TranslationPrompt.doTranslate"].tap()
        waitForValueContains(app.textFields["url"], value: "microsofttranslator")
    }
}

