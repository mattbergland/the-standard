import XCTest
@testable import StandardCore

final class EngineTests: XCTestCase {
    func testEngineProducesEveryRequiredSection() async throws {
        let engine = CulturePackEngine(provider: MockProvider())
        let pack = try await engine.makeCulturePack(from: "My team is talented but plays selfish.")

        // Every required output section must be present and non-empty.
        XCTAssertTrue(pack.isComplete, "All Culture Pack sections must be populated")
        XCTAssertFalse(pack.phraseOfTheWeek.isEmpty)
        XCTAssertFalse(pack.coachSpeech.isEmpty)
        XCTAssertFalse(pack.practiceDrill.ritual.isEmpty)
        XCTAssertFalse(pack.practiceDrill.drill.isEmpty)
        XCTAssertFalse(pack.teamText.isEmpty)
        XCTAssertFalse(pack.lockerRoomCard.isEmpty)
        XCTAssertFalse(pack.reflectionQuestion.isEmpty)
    }

    func testSelfishProblemMatchesWorkedExampleVerbatim() async throws {
        let engine = CulturePackEngine(provider: MockProvider())
        let pack = try await engine.makeCulturePack(from: "My team is talented but plays selfish.")

        XCTAssertEqual(pack.phraseOfTheWeek, "The ball finds energy.")
        XCTAssertEqual(
            pack.reflectionQuestion,
            "What did you do today that made the game easier for someone else?"
        )
        XCTAssertTrue(pack.coachSpeech.contains("Trust wins games."))
        XCTAssertTrue(pack.practiceDrill.drill.contains("Five-pass possession drill"))
        XCTAssertTrue(pack.teamText.contains("the ball finds energy"))
    }

    func testDifferentProblemsYieldDistinctPacks() async throws {
        let engine = CulturePackEngine(provider: MockProvider())
        let selfish = try await engine.makeCulturePack(from: "My team plays selfish.")
        let bounceBack = try await engine.makeCulturePack(from: "My team gives up after mistakes.")

        XCTAssertNotEqual(selfish.phraseOfTheWeek, bounceBack.phraseOfTheWeek)
        XCTAssertTrue(bounceBack.isComplete)
    }

    func testMockProviderIsDeterministic() async throws {
        let engine = CulturePackEngine(provider: MockProvider())
        let first = try await engine.makeCulturePack(from: "My team is selfish.")
        let second = try await engine.makeCulturePack(from: "My team is selfish.")
        XCTAssertEqual(first, second)
    }
}
