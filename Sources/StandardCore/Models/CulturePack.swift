import Foundation

/// The "magical output" of The Standard.
///
/// Each stored property maps to exactly one required output section in the app
/// spec and is rendered as its own card in the UI. The type is `Codable` so it
/// round-trips to/from the JSON returned by an ``AIProvider``.
public struct CulturePack: Codable, Equatable, Sendable {
    /// A short rallying phrase for the week.
    public let phraseOfTheWeek: String

    /// A ~60-second speech the coach can deliver to the team.
    public let coachSpeech: String

    /// The practice drill and/or ritual that reinforces the standard.
    public let practiceDrill: PracticeDrill

    /// A short message the coach can send the team.
    public let teamText: String

    /// A printable, condensed version for the locker room.
    public let lockerRoomCard: String

    /// A single reflective question for players.
    public let reflectionQuestion: String

    public init(
        phraseOfTheWeek: String,
        coachSpeech: String,
        practiceDrill: PracticeDrill,
        teamText: String,
        lockerRoomCard: String,
        reflectionQuestion: String
    ) {
        self.phraseOfTheWeek = phraseOfTheWeek
        self.coachSpeech = coachSpeech
        self.practiceDrill = practiceDrill
        self.teamText = teamText
        self.lockerRoomCard = lockerRoomCard
        self.reflectionQuestion = reflectionQuestion
    }
}

public extension CulturePack {
    /// Every section title in display order. Used by the prompt builder and by
    /// tests that assert the engine produced a complete pack.
    static let sectionTitles: [String] = [
        "Phrase of the week",
        "60-second coach speech",
        "Practice drill",
        "Team text",
        "Locker room card",
        "Reflection question"
    ]

    /// `true` when every section contains usable, non-empty content.
    var isComplete: Bool {
        ![
            phraseOfTheWeek,
            coachSpeech,
            practiceDrill.drill,
            practiceDrill.ritual,
            teamText,
            lockerRoomCard,
            reflectionQuestion
        ].contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
    }
}

/// The practice section of a ``CulturePack``.
///
/// The spec calls for "a practice drill (and/or practice ritual)", so this
/// captures both: a repeatable `ritual` and a concrete `drill`.
public struct PracticeDrill: Codable, Equatable, Sendable {
    /// A repeatable ritual that reinforces the standard every practice.
    public let ritual: String

    /// A concrete drill with rules tied to the standard.
    public let drill: String

    public init(ritual: String, drill: String) {
        self.ritual = ritual
        self.drill = drill
    }

    private enum CodingKeys: String, CodingKey {
        case ritual
        case drill
    }

    /// Robust decoding: accepts either a structured `{ ritual, drill }` object
    /// or a single string (in which case it becomes the `drill`, with an empty
    /// ritual). This keeps `ClaudeProvider` resilient to model formatting.
    public init(from decoder: Decoder) throws {
        if let single = try? decoder.singleValueContainer(),
           let text = try? single.decode(String.self) {
            self.ritual = ""
            self.drill = text
            return
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ritual = (try? container.decode(String.self, forKey: .ritual)) ?? ""
        self.drill = (try? container.decode(String.self, forKey: .drill)) ?? ""
    }
}
