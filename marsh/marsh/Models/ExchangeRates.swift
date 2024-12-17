import Foundation

struct ExchangeRates: Codable {
    let rates: [String: Double]

    private enum CodingKeys: String, CodingKey {
        case rates = "conversion_rates"
    }
}

// MARK: - Currency

enum Currency: String, Codable, CaseIterable {
    case USD
    case SEK

    var name: String {
        switch self {
        case .USD:
            return "$"
        case .SEK:
            return "kr"
        }
    }
}
