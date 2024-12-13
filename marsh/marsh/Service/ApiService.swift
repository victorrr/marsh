import Foundation
import SwiftUI

// MARK: - ApiServiceProtocol

protocol ApiServiceProtocol {
    func fetchCryptos() async throws -> [CryptoItem]
    func fetchExchangeRates() async throws -> ExchangeRates
}

// MARK: - ApiService

final class ApiService: ApiServiceProtocol {
    private let networkService: NetworkServiceProtocol

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

    func fetchExchangeRates() async throws -> ExchangeRates {
        guard let url = createUrl(host: Constant.exchangeHost, path: Constant.exchangePath) else {
            throw NetworkError.invalidUrl
        }
        let request = createGETRequest(url: url)
        return try await networkService.fetch(with: request)
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
                   cryptoPath = "/sapi/v1/tickers/24hr",
                   exchangeHost = "v6.exchangerate-api.com",
                   exchangePath = "/v6/e300a23d950cab1fae09f2ae/latest/INR",
                   applicationJson = "application/json",
                   contentType = "Content-Type",
                   accept = "accept",
                   getMethod = "GET"
    }
}
