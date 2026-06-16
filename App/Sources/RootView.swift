import SwiftUI

/// Top-level view that switches between the input, loading, results, and error
/// states of the single-screen flow.
struct RootView: View {
    @StateObject private var viewModel = CulturePackViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                InputView(viewModel: viewModel)
            case .loading:
                LoadingView()
            case let .loaded(pack):
                ResultsView(
                    problem: viewModel.problemText,
                    pack: pack,
                    onStartOver: { viewModel.reset() }
                )
            case let .failed(message):
                ErrorView(message: message) {
                    viewModel.reset()
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.state)
    }
}

/// Simple error state with a way back to the input screen.
struct ErrorView: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(Theme.accentDeep)
            Text("Couldn't build that pack")
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.ink)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Theme.inkSoft)
                .multilineTextAlignment(.center)
            Button("Back", action: onDismiss)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 12)
                .background(Theme.accent, in: Capsule())
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.paper.ignoresSafeArea())
        .accessibilityIdentifier("errorScreen")
    }
}
