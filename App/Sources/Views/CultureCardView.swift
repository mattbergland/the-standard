import SwiftUI

/// A single labeled card rendering one section of the Culture Pack.
struct CultureCardView<Content: View>: View {
    let icon: String
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 26, height: 26)
                    .background(Theme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
                Text(title.uppercased())
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(Theme.inkSoft)
                Spacer()
            }
            content
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardRadius)
                .stroke(Theme.hairline, lineWidth: 1)
        )
        .shadow(color: Theme.ink.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}

/// Body text styled consistently inside cards.
struct CardBody: View {
    let text: String
    var emphasized: Bool = false

    var body: some View {
        Text(text)
            .font(emphasized ? .title3.weight(.semibold) : .body)
            .foregroundStyle(emphasized ? Theme.ink : Theme.inkSoft)
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
    }
}
