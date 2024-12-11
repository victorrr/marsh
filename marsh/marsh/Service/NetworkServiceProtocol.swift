import Foundation

// MARK: - NetworkServiceProtocol

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(with request: URLRequest) async throws -> T
}
