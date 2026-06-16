import Foundation

/// Deterministic, offline ``AIProvider``.
///
/// Used by tests and SwiftUI previews. Requires no network and no API key.
/// It returns the spec's worked example verbatim for the canonical "selfish"
/// problem, recognizes a couple of other common problems, and falls back to a
/// realistic, fully-populated pack derived from the worked example for anything
/// else — so every demo reaches a complete results screen.
public struct MockProvider: AIProvider {
    /// Optional artificial delay (seconds) to exercise loading states in the UI.
    private let simulatedDelay: Double

    public init(simulatedDelay: Double = 0) {
        self.simulatedDelay = simulatedDelay
    }

    public func generateCulturePack(for problem: TeamProblem) async throws -> CulturePack {
        if simulatedDelay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))
        }
        return MockProvider.pack(for: problem)
    }

    /// Pure, synchronous lookup so previews and tests can call it directly.
    public static func pack(for problem: TeamProblem) -> CulturePack {
        let text = problem.normalized.lowercased()

        if text.contains("selfish") || text.contains("ball stick") || text.contains("share") {
            return .selfishTeam
        }
        if text.contains("give up") || text.contains("gives up")
            || text.contains("mistake") || text.contains("quit")
            || text.contains("heads down") {
            return .bouncesBack
        }
        if text.contains("late") || text.contains("effort")
            || text.contains("lazy") || text.contains("compete") {
            return .effortStandard
        }
        return .selfishTeam
    }
}

public extension CulturePack {
    /// The spec's worked example, verbatim.
    static let selfishTeam = CulturePack(
        phraseOfTheWeek: "The ball finds energy.",
        coachSpeech: """
        Talent gets attention. Trust wins games. The ball cannot stick to one \
        person and still belong to the team. When you cut hard, screen with \
        purpose, make the extra pass, and celebrate someone else's bucket, you \
        become hard to guard. This week, we are not measuring who gets shots. \
        We are measuring who creates good shots.
        """,
        practiceDrill: PracticeDrill(
            ritual: "Every made basket in shell or advantage drills must be acknowledged by two teammates.",
            drill: "Five-pass possession drill. No shot counts unless the ball changes sides and at least three players touch it."
        ),
        teamText: "Tomorrow's standard: the ball finds energy. Cut hard. Screen somebody open. Celebrate the extra pass.",
        lockerRoomCard: """
        THE BALL FINDS ENERGY
        • Cut hard.
        • Screen somebody open.
        • Make the extra pass.
        • Celebrate the assist.
        """,
        reflectionQuestion: "What did you do today that made the game easier for someone else?"
    )

    /// A team that gives up after mistakes.
    static let bouncesBack = CulturePack(
        phraseOfTheWeek: "Next play speed.",
        coachSpeech: """
        Mistakes are not the problem. Staying in the last mistake is the \
        problem. Every possession you play with your head down is a possession \
        you gave to the other team for free. The best players in the world miss \
        — they just get to the next play faster than anyone else. This week we \
        train the bounce-back. Short memory, loud teammates, eyes up. We don't \
        measure who is perfect. We measure who recovers fastest.
        """,
        practiceDrill: PracticeDrill(
            ritual: "After any turnover or miss, the player claps once and sprints to the next spot — no slumping, no excuses.",
            drill: "Mistake-and-recover drill: deliberately force a turnover, then the same player must make the next defensive stop within five seconds."
        ),
        teamText: "Tomorrow's standard: next play speed. Mistakes happen. Heads up, sprint back, pick each other up.",
        lockerRoomCard: """
        NEXT PLAY SPEED
        • Short memory.
        • Heads up, not down.
        • Sprint to the next play.
        • Pick a teammate up.
        """,
        reflectionQuestion: "How fast did you get to your next play after something went wrong today?"
    )

    /// A team with effort/competitiveness issues.
    static let effortStandard = CulturePack(
        phraseOfTheWeek: "Earn it every rep.",
        coachSpeech: """
        Effort is the one thing nobody can take and nobody can fake. Talent is \
        uneven. Calls are uneven. The clock is uneven. Effort is the part of \
        the game that is one hundred percent ours. When we sprint the floor, \
        crash the glass, and dive for the loose ball, we stop hoping to win and \
        start deciding to. This week we don't measure the scoreboard. We \
        measure the effort plays — and effort plays are a choice.
        """,
        practiceDrill: PracticeDrill(
            ritual: "Every drill starts and ends on a sprint line; first one to the line leads the next breakdown.",
            drill: "Loose-ball war: coach rolls the ball, two players compete for possession, winner's team gets the next rep."
        ),
        teamText: "Tomorrow's standard: earn it every rep. Sprint the floor. Crash the glass. Win the loose ball.",
        lockerRoomCard: """
        EARN IT EVERY REP
        • Sprint the floor.
        • Crash the glass.
        • Win the loose ball.
        • First to the line.
        """,
        reflectionQuestion: "Which effort play today did you choose to make that you could have skipped?"
    )
}
