import Foundation

/// Builds the system and user prompts sent to an AI provider.
///
/// The prompt is deliberately explicit about the JSON shape so that
/// ``ClaudeProvider`` receives output that decodes straight into
/// ``CulturePack``.
public enum PromptBuilder {
    /// The JSON keys the model is asked to return, matching ``CulturePack``'s
    /// `Codable` keys.
    static let jsonKeys: [String] = [
        "phraseOfTheWeek",
        "coachSpeech",
        "practiceDrill",
        "teamText",
        "lockerRoomCard",
        "reflectionQuestion"
    ]

    /// System prompt establishing the assistant's role and tone.
    public static func systemPrompt() -> String {
        """
        You are The Standard, an assistant for sports coaches and team leaders. \
        You turn a single team problem into one weekly "Culture Pack" the coach \
        can teach and reinforce. Your voice is direct, warm, and concrete — the \
        way a great coach talks in a huddle. Avoid clichés and filler. Every \
        section must be usable as-is, today.
        """
    }

    /// User prompt embedding the coach's problem and requesting strict JSON
    /// with one field per required output section.
    public static func userPrompt(for problem: TeamProblem) -> String {
        """
        A coach described this team problem, in their own words:

        \"\"\"
        \(problem.normalized)
        \"\"\"

        Produce a Culture Pack with EVERY one of these sections:
        - Phrase of the week: a short rallying phrase.
        - 60-second coach speech: roughly 60 seconds spoken, motivating and specific.
        - Practice drill: a concrete drill AND a repeatable ritual that reinforce the standard.
        - Team text: a short message the coach can send the team.
        - Locker room card: a printable, condensed version of the standard.
        - Reflection question: one question that makes players think.

        Respond with ONLY a single JSON object, no markdown, using exactly these keys:
        {
          "phraseOfTheWeek": "string",
          "coachSpeech": "string",
          "practiceDrill": { "ritual": "string", "drill": "string" },
          "teamText": "string",
          "lockerRoomCard": "string",
          "reflectionQuestion": "string"
        }
        """
    }
}
