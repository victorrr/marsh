import Combine
import Foundation

final class MListViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var viewState = ViewState.empty
    private var apiService: ApiServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
        observeSearches()
    }

    func imageUrl(imageItem: ImageItem) -> URL? {
        do {
            return try apiService.imageUrl(imageItem: imageItem)
        } catch {
            print("\(error)")
            return nil
        }
    }
}

// MARK: - ViewState

extension MListViewModel {

    enum ViewState {
        case empty
        case images([ImageItem])
        case loading
        case error(Error)
    }
}

// MARK: - Private

private extension MListViewModel {

    func observeSearches() {
        $searchTerm
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: self.searchImages)
            .store(in: &cancellables)
    }

    func searchImages(_ text: String) {
        Task { @MainActor in
            do {
                if case .empty = self.viewState {
                    self.viewState = .loading
                }
                let images = try await self.apiService.fetchImageItems(text: text)
                guard let images = images else {
                    self.viewState = .empty
                    return
                }
                guard !images.isEmpty else {
                    self.viewState = .error(NetworkError.noImages)
                    return
                }
                self.viewState = .images(images)
            } catch {
                self.viewState = .error(error)
            }
        }
    }
}
