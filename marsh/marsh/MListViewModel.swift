import Combine
import Foundation

final class MListViewModel: ObservableObject {
    @Published var currency: Currency = .USD //TODO: Kanske döpa om till fiatCurrency
    @Published var viewState = ViewState.empty
    private var apiService: ApiServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
        fetchCryptoCurrencies()
        observeSearches()
    }

    func exchangeRate(currency: Currency) async -> CGFloat {
        do {
            return try await apiService.fetchExchangeRate(currency: currency.rawValue)
        } catch {
            // TODO: returnera standard rate
            return 1
        }
    }
}

// MARK: - Currency

enum Currency: String, CaseIterable {
    case USD
    case SEK
}

// MARK: - ViewState

extension MListViewModel {

    enum ViewState {
        case empty
        case cryptos([CryptoItem])
        case loading
        case error(Error)
    }
}

// MARK: - Private

private extension MListViewModel {

    func observeSearches() {
        $currency
            .receive(on: RunLoop.main)
            .sink(receiveValue: self.switchCurrency)
            .store(in: &cancellables)
    }

    func switchCurrency(_ currency: Currency) {
        Task {
            do {
                let exchangeRate = try await self.apiService.fetchExchangeRate(currency: currency.rawValue)
                guard case .cryptos(let cryptos) = self.viewState else {
                    return
                }
                let exchangeRatedCryptos = cryptos
                    .map {
                        var crypto = $0
                        crypto.lastPrice = String((crypto.lastPrice.cgFloat ?? 1)*exchangeRate)
                        return crypto
                    }
                self.viewState = .cryptos(exchangeRatedCryptos)
            } catch {
                self.viewState = .error(error)
            }
        }
    }

    func fetchCryptoCurrencies() {
        Task { @MainActor in
            do {
                if case .empty = self.viewState {
                    self.viewState = .loading
                }
                async let cryptosResult = self.apiService.fetchCryptos()
                async let exchangeRateResult = self.apiService.fetchExchangeRate(currency: currency.rawValue)

                let (cryptos, exchangeRate) = try await (cryptosResult, exchangeRateResult)
                guard !cryptos.isEmpty else {
                    self.viewState = .error(NetworkError.noItems)
                    return
                }
                let exchangeRatedCryptos = cryptos
                    .map {
                        var crypto = $0
                        crypto.lastPrice = String((crypto.lastPrice.cgFloat ?? 1)*exchangeRate)
                        return crypto
                    }
                self.viewState = .cryptos(exchangeRatedCryptos)
            } catch {
                self.viewState = .error(error)
            }
        }
    }
}
