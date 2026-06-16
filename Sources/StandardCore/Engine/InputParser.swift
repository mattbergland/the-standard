import Foundation

/// Normalizes raw coach input into a ``TeamProblem``.
public enum InputParser {
    /// Cleans up the raw text: trims surrounding whitespace and collapses runs
    /// of internal whitespace (including newlines) into single spaces.
    public static func parse(_ raw: String) -> TeamProblem {
        let normalized = raw
            .split(whereSeparator: { $0.isWhitespace || $0.isNewline })
            .joined(separator: " ")
        return TeamProblem(raw: raw, normalized: normalized)
    }
}
