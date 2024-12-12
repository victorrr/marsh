import Foundation

// MARK: - CryptoItem

struct CryptoItem: Decodable, Hashable { //TODO: Använd CodingKey för att ändra namn och ha bara de värden som är intressanta
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let openPrice: String
    let lowPrice: String
    let highPrice: String
    var lastPrice: String
    let volume: String
    let bidPrice: String
    let askPrice: String
    let at: Int
}
