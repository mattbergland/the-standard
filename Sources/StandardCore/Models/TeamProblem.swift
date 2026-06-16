import Foundation

/// A coach's team problem, expressed in their own words.
///
/// `TeamProblem` is the single input to the engine. It keeps the original text
/// the coach typed (`raw`) alongside a cleaned-up `normalized` form that the
/// prompt builder and providers consume.
public struct TeamProblem: Codable, Equatable, Sendable {
    /// The exact text the coach entered.
    public let raw: String

    /// Whitespace-trimmed, internally-collapsed version of `raw`.
    public let normalized: String

    public init(raw: String, normalized: String) {
        self.raw = raw
        self.normalized = normalized
    }

    /// `true` when there is no usable problem text after normalization.
    public var isEmpty: Bool {
        normalized.isEmpty
    }

    /// Number of words in the normalized problem.
    public var wordCount: Int {
        normalized.isEmpty ? 0 : normalized.split(separator: " ").count
    }
}
