import XCTest
@testable import StandardCore

final class PromptBuilderTests: XCTestCase {
    func testUserPromptContainsTheCoachInput() {
        let problem = InputParser.parse("My team is talented but plays selfish.")
        let prompt = PromptBuilder.userPrompt(for: problem)
        XCTAssertTrue(prompt.contains("My team is talented but plays selfish."))
    }

    func testUserPromptMentionsEveryRequiredSection() {
        let problem = InputParser.parse("My team gives up after mistakes.")
        let prompt = PromptBuilder.userPrompt(for: problem)
        for title in CulturePack.sectionTitles {
            XCTAssertTrue(
                prompt.localizedCaseInsensitiveContains(title),
                "Prompt should mention required section: \(title)"
            )
        }
    }

    func testUserPromptRequestsEveryJSONKey() {
        let problem = InputParser.parse("Anything")
        let prompt = PromptBuilder.userPrompt(for: problem)
        for key in PromptBuilder.jsonKeys {
            XCTAssertTrue(prompt.contains(key), "Prompt should request JSON key: \(key)")
        }
    }

    func testSystemPromptEstablishesRole() {
        XCTAssertTrue(PromptBuilder.systemPrompt().contains("The Standard"))
    }
}
