import Foundation
import StandardCore

/// View state for the main screen.
enum CulturePackState: Equatable {
    case idle
    case loading
    case loaded(CulturePack)
    case failed(String)
}

/// Drives the single-screen flow: take the coach's problem, run the engine,
/// and publish the resulting ``CulturePack`` (or an error).
@MainActor
final class CulturePackViewModel: ObservableObject {
    @Published var problemText: String
    @Published private(set) var state: CulturePackState = .idle

    private let engine: CulturePackEngine

    init(provider: AIProvider = AppConfiguration.makeProvider()) {
        self.engine = CulturePackEngine(provider: provider)
        self.problemText = AppConfiguration.prefilledProblem ?? ""
    }

    /// `true` when there is enough input to build a pack.
    var canBuild: Bool {
        !problemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    /// Run the engine for the current `problemText`.
    func buildCulturePack() async {
        guard canBuild else { return }
        state = .loading
        do {
            let pack = try await engine.makeCulturePack(from: problemText)
            state = .loaded(pack)
        } catch {
            let message = (error as? CulturePackError)?.errorDescription
                ?? error.localizedDescription
            state = .failed(message)
        }
    }

    /// Return to the input screen, keeping the typed problem.
    func reset() {
        state = .idle
    }

    /// Prefill a sample problem (used by the empty-state example chips).
    func useExample(_ text: String) {
        problemText = text
    }
}
