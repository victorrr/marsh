//
//  CurrencyDropdownView.swift
//  marsh
//
//  Created by Victor Rendon on 2024-12-12.
//

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
                Image(systemName: "chevron.down")
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

#Preview {
    CurrencyDropdownView(selectedOption: .constant(.USD))
}
