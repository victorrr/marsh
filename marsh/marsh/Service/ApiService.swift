import Foundation
import SwiftUI

// MARK: - ApiServiceProtocol

protocol ApiServiceProtocol {
    func fetchImageItems(text: String) async throws -> [ImageItem]?
    func imageUrl(imageItem: ImageItem) throws -> URL
}

// MARK: - ApiService

final class ApiService: ApiServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let apiKey: String = "5a2cc90782760b3a6b3eca570dfaf5c3"

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchImageItems(text: String) async throws -> [ImageItem]? {
        guard !text.isEmpty else { return nil }
        let queryItems = [
            URLQueryItem(name: Constant.method, value: Constant.methodValue),
            URLQueryItem(name: Constant.apiKey, value: apiKey),
            URLQueryItem(name: Constant.text, value: text),
            URLQueryItem(name: Constant.format, value: Constant.json),
            URLQueryItem(name: Constant.nojsoncallback, value: Constant.one)
        ]
        guard let url = createUrl(host: Constant.imagesHost, path: Constant.imagesPath, queryItems: queryItems) else {
            throw NetworkError.invalidUrl
        }
        let request = createGETRequest(url: url)
        let photos: PhotosResponse = try await networkService.fetch(with: request)
        return photos.photos.photo
    }

    func imageUrl(imageItem: ImageItem) throws -> URL {
        guard !imageItem.server.isEmpty, !imageItem.id.isEmpty, !imageItem.secret.isEmpty else {
            throw NetworkError.invalidUrl
        }
        let path = "/\(imageItem.server)/\(imageItem.id)_\(imageItem.secret)_q.jpg"
        guard let url = createUrl(host: Constant.imageHost, path: path) else {
            throw NetworkError.invalidUrl
        }
        return url
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
                   imagesHost = "www.flickr.com",
                   imageHost = "live.staticflickr.com",
                   applicationJson = "application/json",
                   contentType = "Content-Type",
                   accept = "accept",
                   getMethod = "GET",
                   imagesPath = "/services/rest/",
                   text = "text",
                   apiKey = "api_key",
                   format = "format",
                   json = "json",
                   method = "method",
                   methodValue = "flickr.photos.search",
                   fromDate = "fromDate",
                   toDate = "toDate",
                   nojsoncallback = "nojsoncallback",
                   one = "1"
    }
}
