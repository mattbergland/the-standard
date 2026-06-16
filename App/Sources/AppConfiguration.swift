import Foundation
import StandardCore

/// Runtime configuration that decides which ``AIProvider`` the app uses and
/// supports deterministic UI testing.
///
/// UI tests launch the app with `-UITEST_MOCK 1`. When that flag is present we
/// always use the offline ``MockProvider`` and prefill the input so the test
/// can reach a fully-populated results screen with no network and no API key.
enum AppConfiguration {
    /// `true` when launched by the XCUITest target with `-UITEST_MOCK 1`.
    static var isUITest: Bool {
        UserDefaults.standard.string(forKey: "UITEST_MOCK") == "1"
            || ProcessInfo.processInfo.arguments.contains("-UITEST_MOCK")
    }

    /// The provider for this launch.
    /// - UI test: deterministic ``MockProvider``.
    /// - With `ANTHROPIC_API_KEY` set: live ``ClaudeProvider``.
    /// - Otherwise: ``MockProvider`` (with a small delay so loading states show).
    static func makeProvider() -> AIProvider {
        if isUITest {
            return MockProvider()
        }
        if let key = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"], !key.isEmpty {
            return ClaudeProvider(apiKey: key)
        }
        return MockProvider(simulatedDelay: 0.7)
    }

    /// Text to prefill the input with on launch (UI tests only).
    static var prefilledProblem: String? {
        isUITest ? "My team is talented but plays selfish." : nil
    }
}
