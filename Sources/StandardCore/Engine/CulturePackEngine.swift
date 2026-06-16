import Foundation

/// The core engine: normalizes input, validates it, and asks an ``AIProvider``
/// to produce a ``CulturePack``.
///
/// All business logic lives here so it is fully testable on Linux. The SwiftUI
/// layer is a thin shell on top of this type.
public struct CulturePackEngine: Sendable {
    private let provider: AIProvider

    public init(provider: AIProvider) {
        self.provider = provider
    }

    /// Build a Culture Pack from raw coach input.
    ///
    /// - Throws: ``CulturePackError/emptyInput`` if the input is empty after
    ///   normalization; otherwise any error thrown by the provider.
    public func makeCulturePack(from rawInput: String) async throws -> CulturePack {
        let problem = InputParser.parse(rawInput)
        guard !problem.isEmpty else {
            throw CulturePackError.emptyInput
        }
        return try await provider.generateCulturePack(for: problem)
    }
}
