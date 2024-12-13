import SwiftUI

struct CryptoView: View {
    var name: String
    var value: Double
    var currency: Currency

    var body: some View {
        HStack(spacing: Constant.spacing) {
            nameView
            valueView
            Spacer()
        }
        .padding()
    }
}

// MARK: - Subviews

private extension CryptoView {

    var valueView: some View {
        Text("\(String(format: "%.3f", value)) \(currency.name)")
            .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
    }

    var nameView: some View {
        Text(name.uppercased())
            .font(.largeTitle)
            .foregroundStyle(.white)
            .frame(width: Constant.boxWidth, height: Constant.boxWidth)
            .background(.black)
            .cornerRadius(Constant.boxRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constant.boxRadius)
                    .stroke(Color.blue.opacity(0.6), lineWidth: Constant.boxLineWidth)
            )
            .shadow(radius: Constant.boxShadowRadius)
            .padding(Constant.boxPadding)
    }
}

// MARK: - Constant

private extension CryptoView {

    struct Constant {
        static let spacing: CGFloat = 10,
                   boxWidth: CGFloat = 150,
                   boxRadius: CGFloat = 10,
                   boxLineWidth: CGFloat = 2,
                   boxShadowRadius: CGFloat = 6,
                   boxPadding: CGFloat = 12
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
        CryptoView(name: "btc", value: 150, currency: .USD)
            .frame(height: 150)
        Spacer()
    }
}
