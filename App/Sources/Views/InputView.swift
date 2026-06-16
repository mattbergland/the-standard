import SwiftUI

/// The single-input screen: a text field, the primary button, and an empty
/// state with tappable examples.
struct InputView: View {
    @ObservedObject var viewModel: CulturePackViewModel
    @FocusState private var inputFocused: Bool

    private let examples = [
        "My team gives up after mistakes.",
        "My team is talented but plays selfish.",
        "We stop competing when we're down."
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                VStack(alignment: .leading, spacing: 12) {
                    Text("What's the problem with your team?")
                        .font(.headline)
                        .foregroundStyle(Theme.ink)

                    ZStack(alignment: .topLeading) {
                        if viewModel.problemText.isEmpty {
                            Text("e.g. My team gives up after mistakes.")
                                .font(.body)
                                .foregroundStyle(Theme.inkSoft.opacity(0.5))
                                .padding(.top, 14)
                                .padding(.horizontal, 16)
                        }
                        TextEditor(text: $viewModel.problemText)
                            .focused($inputFocused)
                            .font(.body)
                            .foregroundStyle(Theme.ink)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 130)
                            .padding(8)
                            .accessibilityIdentifier("problemInput")
                    }
                    .background(Theme.card, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(inputFocused ? Theme.accent : Theme.hairline, lineWidth: 1.5)
                    )
                }

                buildButton

                emptyState
            }
            .padding(Theme.pagePadding)
        }
        .background(Theme.paper.ignoresSafeArea())
        .accessibilityIdentifier("inputScreen")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("THE STANDARD")
                .font(.largeTitle.weight(.heavy))
                .tracking(0.5)
                .foregroundStyle(Theme.ink)
            Text("Turn team problems into championship habits.")
                .font(.subheadline)
                .foregroundStyle(Theme.inkSoft)
        }
        .padding(.top, 8)
    }

    private var buildButton: some View {
        Button {
            inputFocused = false
            Task { await viewModel.buildCulturePack() }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "bolt.fill")
                Text("Build Culture Pack")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(.white)
            .background(viewModel.canBuild ? Theme.accent : Theme.inkSoft.opacity(0.4),
                        in: RoundedRectangle(cornerRadius: 14))
        }
        .disabled(!viewModel.canBuild)
        .accessibilityIdentifier("buildCulturePackButton")
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Not sure where to start? Try one:")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.inkSoft)
            ForEach(examples, id: \.self) { example in
                Button {
                    viewModel.useExample(example)
                } label: {
                    HStack {
                        Image(systemName: "quote.opening")
                            .foregroundStyle(Theme.accent)
                        Text(example)
                            .foregroundStyle(Theme.ink)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(14)
                    .background(Theme.card, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.hairline, lineWidth: 1)
                    )
                }
            }
        }
    }
}
