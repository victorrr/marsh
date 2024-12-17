import SwiftUI

struct CurrencyDropdownView: View {
    @Binding var selectedOption: Currency

    var body: some View {
        Menu {
            ForEach(Currency.allCases, id: \.self) { option in
                Button(option.rawValue) { selectedOption = option }
            }
        } label: {
            HStack {
                Text(selectedOption.rawValue)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.gray)
            .cornerRadius(8)
        }
    }
}

// MARK: - Constant

private extension CurrencyDropdownView {

    struct Constant {
        static let cornerRadius: CGFloat = 8
    }
}

// MARK: - Preview

#Preview {
    CurrencyDropdownView(selectedOption: .constant(.USD))
}
