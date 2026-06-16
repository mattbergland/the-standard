import XCTest

/// End-to-end UI test that launches the app with the offline ``MockProvider``
/// (via `-UITEST_MOCK 1`), drives it to the populated results screen, and
/// captures screenshots of both the input and results screens.
///
/// Runs deterministically with NO network and NO API key.
final class TheStandardUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testBuildCulturePackFlowCapturesScreens() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_MOCK", "1"]
        app.launch()

        // INPUT SCREEN — input is prefilled with the example problem in UI-test mode.
        let buildButton = app.buttons["buildCulturePackButton"]
        XCTAssertTrue(buildButton.waitForExistence(timeout: 15), "Build button should appear")
        attach(name: "01-input-screen")

        // Tap "Build Culture Pack".
        buildButton.tap()

        // RESULTS SCREEN — wait for the results container to appear.
        let results = app.otherElements["resultsScreen"]
        let resultsScroll = app.scrollViews.firstMatch
        XCTAssertTrue(
            results.waitForExistence(timeout: 15) || resultsScroll.waitForExistence(timeout: 15),
            "Results screen should appear"
        )

        // The hero phrase from the worked example must be visible.
        XCTAssertTrue(
            app.staticTexts["The ball finds energy."].waitForExistence(timeout: 10),
            "Phrase of the week should render"
        )

        // Capture the top of the results, then scroll to reveal every card.
        attach(name: "02-results-top")
        app.swipeUp()
        attach(name: "03-results-middle")
        app.swipeUp()
        attach(name: "04-results-bottom")
    }

    /// Attach a full-screen screenshot that survives into the result bundle.
    private func attach(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
