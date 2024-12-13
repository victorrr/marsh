import Combine
import Foundation

final class MListViewModel: ObservableObject {
    @Published var selectedCurrency: Currency = .USD //TODO: Kanske döpa om till fiatCurrency
    @Published var viewState = ViewState.empty
    private var apiService: ApiServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var exchangeItems: [ExchangeItem] = []
    private var cryptos: [CryptoItem] = []

    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
        fetchCryptoCurrencies()
        observeCurrency()
    }
}

// MARK: - ExchangeItem

private extension MListViewModel {

    struct ExchangeItem {
        let currency: Currency
        let value: CGFloat
    }
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

    func observeCurrency() {
        $selectedCurrency
            .receive(on: RunLoop.main)
            .sink {
                let exchangeRatedCryptos = self.exchangeRatedCryptos(currency: $0)
                self.viewState = .cryptos(exchangeRatedCryptos)
            }
            .store(in: &cancellables)
    }

    func exchangeRatedCryptos(currency: Currency) -> [CryptoItem] {
        guard let exchangeRate = exchangeItems.first(where: { $0.currency == currency })?.value else {
            return []
        }
        return cryptos
            .compactMap {
                var crypto = $0
                crypto.price = crypto.price*exchangeRate
                return crypto
            }
    }

    func fetchCryptoCurrencies() {
        Task { @MainActor in
            do {
                if case .empty = self.viewState {
                    self.viewState = .loading
                }
                async let cryptosResponse = self.apiService.fetchCryptos()
                async let exchangeItemsResponse = self.apiService.fetchExchangeRates()
                let (cryptos, exchangeRates) = try await (cryptosResponse, exchangeItemsResponse)
                exchangeItems = Currency.allCases
                    .compactMap {
                        guard let rate = exchangeRates.rates[$0.rawValue],
                              let currency = Currency(rawValue: $0.rawValue) else { return nil }
                        return ExchangeItem(currency: currency, value: rate)
                    }
                guard !cryptos.isEmpty else {
                    self.viewState = .error(NetworkError.noItems)
                    return
                }
                self.cryptos = cryptos.prefix(Constant.maxNumberOfCryptos).map { $0 }
                let exchangeRatedCryptos = self.exchangeRatedCryptos(currency: selectedCurrency)
                self.viewState = .cryptos(exchangeRatedCryptos)
            } catch {
                self.viewState = .error(error)
            }
        }
    }
}

// MARK: - Constant

private extension MListViewModel {

    struct Constant {
        static let maxNumberOfCryptos: Int = 50
    }
}
