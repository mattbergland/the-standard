import SwiftUI

/// Loading state shown while the engine builds a Culture Pack.
struct LoadingView: View {
    @State private var animate = false

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Theme.accent.opacity(0.15), lineWidth: 6)
                    .frame(width: 64, height: 64)
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(Theme.accent, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 64, height: 64)
                    .rotationEffect(.degrees(animate ? 360 : 0))
                    .animation(.linear(duration: 0.9).repeatForever(autoreverses: false), value: animate)
            }
            Text("Building your standard…")
                .font(.headline)
                .foregroundStyle(Theme.ink)
            Text("Turning the problem into a phrase, a speech, and a drill.")
                .font(.subheadline)
                .foregroundStyle(Theme.inkSoft)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.paper.ignoresSafeArea())
        .onAppear { animate = true }
        .accessibilityIdentifier("loadingScreen")
    }
}
