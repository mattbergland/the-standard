import Foundation

/// Abstraction over anything that can turn a ``TeamProblem`` into a
/// ``CulturePack``.
///
/// Two implementations ship with the package:
/// - ``MockProvider``: deterministic, offline, no API key required.
/// - ``ClaudeProvider``: real calls to the Anthropic Messages API.
public protocol AIProvider: Sendable {
    /// Generate a complete ``CulturePack`` for the given problem.
    func generateCulturePack(for problem: TeamProblem) async throws -> CulturePack
}

/// Errors surfaced by the engine and providers.
public enum CulturePackError: Error, Equatable, Sendable {
    /// The coach submitted empty/whitespace-only input.
    case emptyInput
    /// No Anthropic API key was available to ``ClaudeProvider``.
    case missingAPIKey
    /// The provider returned a non-success HTTP status.
    case http(status: Int, body: String)
    /// The response could not be parsed into a ``CulturePack``.
    case decoding(String)
    /// A network/transport error occurred.
    case transport(String)
}

extension CulturePackError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "Add a team problem first — for example, \"My team gives up after mistakes.\""
        case .missingAPIKey:
            return "No Anthropic API key found. Set ANTHROPIC_API_KEY to use live generation."
        case let .http(status, body):
            return "The AI service returned an error (HTTP \(status)). \(body)"
        case let .decoding(detail):
            return "Couldn't read the AI response. \(detail)"
        case let .transport(detail):
            return "Network problem reaching the AI service. \(detail)"
        }
    }
}
