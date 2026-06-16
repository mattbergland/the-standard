import XCTest
@testable import StandardCore

final class ParserAndRequestTests: XCTestCase {
    private let sampleJSON = """
    {
      "phraseOfTheWeek": "The ball finds energy.",
      "coachSpeech": "Trust wins games.",
      "practiceDrill": { "ritual": "Acknowledge each bucket.", "drill": "Five-pass possession drill." },
      "teamText": "Cut hard, screen, pass.",
      "lockerRoomCard": "THE BALL FINDS ENERGY",
      "reflectionQuestion": "Who did you help today?"
    }
    """

    func testParsesPlainJSON() throws {
        let pack = try CulturePackParser.parse(sampleJSON)
        XCTAssertEqual(pack.phraseOfTheWeek, "The ball finds energy.")
        XCTAssertTrue(pack.isComplete)
    }

    func testParsesJSONWrappedInMarkdownFence() throws {
        let fenced = "```json\n\(sampleJSON)\n```"
        let pack = try CulturePackParser.parse(fenced)
        XCTAssertEqual(pack.practiceDrill.drill, "Five-pass possession drill.")
    }

    func testParsesJSONSurroundedByProse() throws {
        let messy = "Sure! Here is your pack:\n\(sampleJSON)\nHope that helps."
        let pack = try CulturePackParser.parse(messy)
        XCTAssertEqual(pack.reflectionQuestion, "Who did you help today?")
    }

    func testParserThrowsOnGarbage() {
        XCTAssertThrowsError(try CulturePackParser.parse("no json here at all")) { error in
            guard case CulturePackError.decoding = error else {
                return XCTFail("Expected decoding error, got \(error)")
            }
        }
    }

    func testAnthropicRequestHasRequiredHeadersAndBody() throws {
        let problem = InputParser.parse("My team plays selfish.")
        let request = try AnthropicRequestBuilder.makeRequest(
            for: problem,
            apiKey: "test-key-123",
            model: "claude-test"
        )

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url, anthropicMessagesURL)
        XCTAssertEqual(request.value(forHTTPHeaderField: "x-api-key"), "test-key-123")
        XCTAssertEqual(request.value(forHTTPHeaderField: "anthropic-version"), "2023-06-01")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")

        let body = try XCTUnwrap(request.httpBody)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: body) as? [String: Any])
        XCTAssertEqual(json["model"] as? String, "claude-test")
        XCTAssertNotNil(json["max_tokens"])
        XCTAssertNotNil(json["system"])
        let messages = try XCTUnwrap(json["messages"] as? [[String: Any]])
        let userContent = try XCTUnwrap(messages.first?["content"] as? String)
        XCTAssertTrue(userContent.contains("My team plays selfish."))
    }

    func testClaudeProviderWithoutKeyThrowsMissingAPIKey() async {
        let provider = ClaudeProvider(apiKey: nil)
        do {
            _ = try await provider.generateCulturePack(for: InputParser.parse("hi"))
            XCTFail("Expected missingAPIKey error")
        } catch let error as CulturePackError {
            XCTAssertEqual(error, .missingAPIKey)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
