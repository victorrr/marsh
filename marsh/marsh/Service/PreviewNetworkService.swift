import Foundation

final class PreviewNetworkService: NetworkServiceProtocol {
    var cryptoItemsResult: Any?
    var exchangeRatesResult: Any?
    var error: Error?

    func fetch<T: Decodable>(with request: URLRequest) async throws -> T {
        if let error = error {
            throw error
        }

        if request.url?.host() == Constant.cryptosHost,
           let result = cryptoItemsResult as? T {
            return result
        } else if request.url?.host() == Constant.exchangeRatesHost,
                  let result = exchangeRatesResult as? T {
            return result
        }

        throw NetworkError.invalidResponse
    }
}

// MARK: - Constant

private extension PreviewNetworkService {

    struct Constant {
        static let cryptosHost = "api.wazirx.com",
                   exchangeRatesHost = "v6.exchangerate-api.com"
    }
}
