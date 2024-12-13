import Foundation

// MARK: - CryptoItem

struct CryptoItem: Decodable, Hashable { //TODO: Använd CodingKey för att ändra namn och ha bara de värden som är intressanta
    let name: String
    var price: String

    private enum CodingKeys: String, CodingKey {
        case name = "baseAsset"
        case price = "openPrice"
    }
}
