import XCTest
@testable import StandardCore

/// Live, network-dependent smoke test for ``ClaudeProvider``.
///
/// This test is **skipped** unless `ANTHROPIC_API_KEY` is present in the
/// environment, so the offline suite (and CI without a key) stays green and
/// network-free. Run it locally with a key to sanity-check real output.
final class LiveClaudeTests: XCTestCase {
    func testLiveClaudeProducesCompletePack() async throws {
        guard let key = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"], !key.isEmpty else {
            throw XCTSkip("ANTHROPIC_API_KEY not set; skipping live Claude smoke test.")
        }

        let engine = CulturePackEngine(provider: ClaudeProvider())
        let pack = try await engine.makeCulturePack(from: "My team is talented but plays selfish.")

        XCTAssertTrue(pack.isComplete, "Live Claude response should populate every section")
        XCTAssertFalse(pack.phraseOfTheWeek.isEmpty)
        XCTAssertFalse(pack.coachSpeech.isEmpty)
    }
}
