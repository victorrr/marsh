import SwiftUI

struct MItemView: View {
    var name: String
    var value: String
    var currency: String

    var body: some View {
        HStack(spacing: Constant.spacing) {
            VStack {
                valueView
                Spacer()
            }
            VStack {
                titleView
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

// MARK: - Subviews

private extension MItemView {

    var valueView: some View {
        Text("\(value) \(currency)")
    }

    var titleView: some View {
        Text(name)
            .font(.title2)
    }
}

// MARK: - Constant

private extension MItemView {

    struct Constant {
        static let spacing: CGFloat = 10,
                   imageWidth: CGFloat = 150,
                   imageRadius: CGFloat = 4
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
        MItemView(name: "Image title", value: "150", currency: "USD")
            .frame(height: 150)
        Spacer()
    }
}
