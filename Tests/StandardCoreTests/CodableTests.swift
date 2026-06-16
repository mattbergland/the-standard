import XCTest
@testable import StandardCore

final class CodableTests: XCTestCase {
    func testCulturePackRoundTrip() throws {
        let original = CulturePack.selfishTeam
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(CulturePack.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    func testTeamProblemRoundTrip() throws {
        let original = InputParser.parse("  My team   plays\n selfish  ")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(TeamProblem.self, from: data)
        XCTAssertEqual(original, decoded)
        XCTAssertEqual(decoded.normalized, "My team plays selfish")
    }

    func testPracticeDrillDecodesFromObject() throws {
        let json = #"{ "ritual": "Clap and reset", "drill": "Five-pass drill" }"#
        let drill = try JSONDecoder().decode(PracticeDrill.self, from: Data(json.utf8))
        XCTAssertEqual(drill.ritual, "Clap and reset")
        XCTAssertEqual(drill.drill, "Five-pass drill")
    }

    func testPracticeDrillDecodesFromBareString() throws {
        // Robustness: a model may return practiceDrill as a single string.
        let json = #""Five-pass possession drill.""#
        let drill = try JSONDecoder().decode(PracticeDrill.self, from: Data(json.utf8))
        XCTAssertEqual(drill.drill, "Five-pass possession drill.")
        XCTAssertEqual(drill.ritual, "")
    }

    func testAllPresetPacksRoundTrip() throws {
        for pack in [CulturePack.selfishTeam, .bouncesBack, .effortStandard] {
            let data = try JSONEncoder().encode(pack)
            let decoded = try JSONDecoder().decode(CulturePack.self, from: data)
            XCTAssertEqual(pack, decoded)
            XCTAssertTrue(decoded.isComplete)
        }
    }
}
