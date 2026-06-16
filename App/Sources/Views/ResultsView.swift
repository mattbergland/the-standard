import SwiftUI
import StandardCore

/// The results screen: renders every Culture Pack section as its own card.
struct ResultsView: View {
    let problem: String
    let pack: CulturePack
    let onStartOver: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.cardSpacing) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("YOUR CULTURE PACK")
                        .font(.caption.weight(.bold))
                        .tracking(1.4)
                        .foregroundStyle(Theme.accent)
                    Text(problem)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, 4)

                CultureCardView(icon: "megaphone.fill", title: "Phrase of the Week") {
                    CardBody(text: pack.phraseOfTheWeek, emphasized: true)
                }

                CultureCardView(icon: "text.quote", title: "60-Second Coach Speech") {
                    CardBody(text: pack.coachSpeech)
                }

                CultureCardView(icon: "figure.basketball", title: "Practice Drill & Ritual") {
                    VStack(alignment: .leading, spacing: 12) {
                        labeled("Ritual", pack.practiceDrill.ritual)
                        labeled("Drill", pack.practiceDrill.drill)
                    }
                }

                CultureCardView(icon: "bubble.left.and.bubble.right.fill", title: "Team Text") {
                    CardBody(text: pack.teamText)
                }

                CultureCardView(icon: "doc.text.fill",
                                title: "Locker Room Card") {
                    Text(pack.lockerRoomCard)
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(Theme.ink)
                        .lineSpacing(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Theme.paper, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                                .foregroundStyle(Theme.accent.opacity(0.5))
                        )
                }

                CultureCardView(icon: "questionmark.circle.fill", title: "Reflection Question") {
                    CardBody(text: pack.reflectionQuestion, emphasized: true)
                }

                Button(action: onStartOver) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Build Another")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .foregroundStyle(Theme.ink)
                    .background(Theme.card, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Theme.ink, lineWidth: 1.5)
                    )
                }
                .padding(.top, 4)
            }
            .padding(Theme.pagePadding)
        }
        .background(Theme.paper.ignoresSafeArea())
        .accessibilityIdentifier("resultsScreen")
    }

    private func labeled(_ label: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label.uppercased())
                .font(.caption2.weight(.bold))
                .tracking(1)
                .foregroundStyle(Theme.accent)
            CardBody(text: text)
        }
    }
}
