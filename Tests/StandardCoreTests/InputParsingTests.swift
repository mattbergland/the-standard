import XCTest
@testable import StandardCore

final class InputParsingTests: XCTestCase {
    func testNormalizationTrimsAndCollapsesWhitespace() {
        let problem = InputParser.parse("  My   team\n\nplays  selfish  ")
        XCTAssertEqual(problem.normalized, "My team plays selfish")
        XCTAssertEqual(problem.wordCount, 4)
        XCTAssertFalse(problem.isEmpty)
    }

    func testEmptyAndWhitespaceInputIsEmpty() {
        XCTAssertTrue(InputParser.parse("").isEmpty)
        XCTAssertTrue(InputParser.parse("    \n\t  ").isEmpty)
        XCTAssertEqual(InputParser.parse("   ").wordCount, 0)
    }

    func testEngineThrowsOnEmptyInput() async {
        let engine = CulturePackEngine(provider: MockProvider())
        do {
            _ = try await engine.makeCulturePack(from: "   \n  ")
            XCTFail("Expected emptyInput error")
        } catch let error as CulturePackError {
            XCTAssertEqual(error, .emptyInput)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testEngineHandlesVeryShortInputWithoutCrashing() async throws {
        let engine = CulturePackEngine(provider: MockProvider())
        let pack = try await engine.makeCulturePack(from: "x")
        XCTAssertTrue(pack.isComplete)
    }
}
