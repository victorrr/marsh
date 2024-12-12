import Foundation

enum NetworkError: Error {
    case invalidResponse
    case failedToDecodeResponse
    case invalidUrl
    case noItems

    var localizedDescription: String {
        switch self {
        case .invalidResponse:
            "invalid_response".localized
        case .failedToDecodeResponse:
            "failed_to_decode_response".localized
        case .invalidUrl:
            "invalid_url".localized
        case .noItems:
            "no_images".localized
        }
    }
}
