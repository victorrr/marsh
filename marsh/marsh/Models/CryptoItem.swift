import Foundation

// MARK: - CryptoItem

struct CryptoItem: Decodable, Hashable {
    let name: String
    var price: Double

    private enum CodingKeys: String, CodingKey {
        case name = "baseAsset"
        case price = "openPrice"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)

        let priceString = try container.decode(String.self, forKey: .price)
        guard let priceValue = Double(priceString) else {
            throw DecodingError.dataCorruptedError(forKey: .price,
                                                   in: container,
                                                   debugDescription: "Price value is not a valid Double.")
        }
        price = priceValue
    }

    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
}
