import XCTest
@testable import marsh

final class ApiServiceTests: XCTestCase {
    private var sut: ApiService!
    private var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = ApiService(networkService: mockNetworkService)
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }
}

// MARK: - FetchCryptos

extension ApiServiceTests {

    func testFetchCryptos_WithValidResponse_ReturnsCrytpos() async throws {
        let expectedCryptoItem = CryptoItem(name: "BTC", price: 6000)
        let mockCryptos = [expectedCryptoItem, CryptoItem(name: "AAD", price: 800.20)]
        mockNetworkService.mockResult = mockCryptos

        let result = try await sut.fetchCryptos()

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.name, expectedCryptoItem.name)
        XCTAssertEqual(result.first?.price, expectedCryptoItem.price)
    }

    func testFetchCryptos_WithNetworkError_ThrowsError() async {
        mockNetworkService.error = NetworkError.invalidResponse

        do {
            _ = try await sut.fetchCryptos()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse)
        }
    }
}
// MARK: - FetchExchangeRates

extension ApiServiceTests {

    func testFetchExchangeRates_WithValidResponse_ReturnsExchangeRates() async throws {
        let expectedUSDRate: Double = 10
        let expectedSEKRate: Double = 2.3
        let exchangeRates = ExchangeRates(rates: ["USD": expectedUSDRate, "SEK": expectedSEKRate])
        mockNetworkService.mockResult = exchangeRates
        let result = try await sut.fetchExchangeRates()
        XCTAssertEqual(result.rates["USD"], expectedUSDRate)
        XCTAssertEqual(result.rates["SEK"], expectedSEKRate)
    }

    func testFetchExchangeRates_WithNetworkError_ThrowsError() async {
        let expectedError = NetworkError.failedToDecodeResponse
        mockNetworkService.error = expectedError
        do {
            _ = try await sut.fetchExchangeRates()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError)
        }    }
}
