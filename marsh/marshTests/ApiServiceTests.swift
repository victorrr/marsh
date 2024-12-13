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

// MARK: - FetchImageItems

extension ApiServiceTests {

    func testFetchImageItems_WithEmptyText_ReturnsNil() async throws {
        let result = try await sut.fetchCryptoCurrencies(text: "")
        XCTAssertNil(result)
    }

    func testFetchImageItems_WithValidResponse_ReturnsImageItems() async throws {
        let expectedImageItem = ImageItem(id: "1", server: "server1", secret: "secret1", title: "title1")
        let mockPhotos = PhotosResponse(
            photos: Photos(
                photo: [expectedImageItem]
            )
        )
        mockNetworkService.mockResult = mockPhotos

        let result = try await sut.fetchCryptoCurrencies(text: "test")

        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?.first?.id, expectedImageItem.id)
        XCTAssertEqual(result?.first?.title, expectedImageItem.title)
    }

    func testFetchImageItems_WithNetworkError_ThrowsError() async {
        mockNetworkService.error = NetworkError.invalidResponse

        do {
            _ = try await sut.fetchCryptoCurrencies(text: "test")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse)
        }
    }
}
// MARK: - ImageUrl

extension ApiServiceTests {

    func testImageUrl_WithValidImageItem_ReturnsCorrectURL() throws {
        let imageItem = ImageItem(id: "123",
                                  server: "server1",
                                  secret: "abc",
                                  title: "test")

        let url = try sut.imageUrl(imageItem: imageItem)

        let expectedUrlString = "https://live.static.com/server1/123_abc_q.jpg"
        XCTAssertEqual(url.absoluteString, expectedUrlString)
    }

    func testImageUrl_WithInvalidServer_ThrowsError() {
        let imageItem = ImageItem(id: "",
                                  server: "",
                                  secret: "",
                                  title: "")

        XCTAssertThrowsError(try sut.imageUrl(imageItem: imageItem)) { error in
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidUrl)
        }
    }
}
