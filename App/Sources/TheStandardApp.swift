import SwiftUI

/// Entry point for The Standard iOS app.
@main
struct TheStandardApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .tint(Theme.accent)
        }
    }
}
