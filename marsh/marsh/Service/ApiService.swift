import Foundation
import SwiftUI

// MARK: - ApiServiceProtocol

protocol ApiServiceProtocol {
    func fetchCryptos() async throws -> [CryptoItem]
    func fetchExchangeRate(currency: String) async throws -> CGFloat
}

// MARK: - ApiService

final class ApiService: ApiServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let apiKey: String = "5a2cc90782760b3a6b3eca570dfaf5c3"

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchCryptos() async throws -> [CryptoItem] {
        guard let url = createUrl(host: Constant.cryptoHost, path: Constant.cryptoPath) else {
            throw NetworkError.invalidUrl
        }
        let request = createGETRequest(url: url)
        let cryptoItems: [CryptoItem] = try await networkService.fetch(with: request)
        return cryptoItems
    }

    func fetchExchangeRate(currency: String) async throws -> CGFloat {
        let queryItems = [
            URLQueryItem(name: "currency", value: currency)
        ]
        guard let url = createUrl(host: Constant.exchangeHost, path: Constant.exchangePath, queryItems: queryItems) else {
            throw NetworkError.invalidUrl
        }
        let request = createGETRequest(url: url)
        let cryptoItems: [CryptoItem] = try await networkService.fetch(with: request)
        return 1
    }
}

// MARK: - Private

private extension ApiService {

    func createUrl(host: String, path: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        guard !host.isEmpty, !path.isEmpty else { return nil }
        var components = URLComponents()
        components.scheme = Constant.scheme
        components.host = host
        components.queryItems = queryItems
        components.path = path
        return components.url
    }

    func createGETRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(Constant.applicationJson, forHTTPHeaderField: Constant.accept)
        request.setValue(Constant.applicationJson, forHTTPHeaderField: Constant.contentType)
        request.httpMethod = Constant.getMethod
        return request
    }
}

// MARK: - Constant

private extension ApiService {

    struct Constant {
        static let scheme = "https",
                   cryptoHost = "api.wazirx.com",
                   exchangeHost = "live.staticflickr.com",
                   applicationJson = "application/json",
                   contentType = "Content-Type",
                   accept = "accept",
                   getMethod = "GET",
                   cryptoPath = "/sapi/v1/tickers/24hr",
                   exchangePath = "/sapi/v1/tickers/24hr",
                   text = "text",
                   apiKey = "api_key",
                   format = "format",
                   json = "json",
                   method = "method",
                   fromDate = "fromDate",
                   toDate = "toDate",
                   nojsoncallback = "nojsoncallback",
                   one = "1"
    }
}
