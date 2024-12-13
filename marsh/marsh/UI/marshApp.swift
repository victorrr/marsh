import SwiftUI

@main
struct marshApp: App {
    var body: some Scene {
        WindowGroup {
            CryptosListView(viewModel: viewModel)
        }
    }

    private var viewModel: CryptosListViewModel {
        let networkService = NetworkService()
        let apiService = ApiService(networkService: networkService)
        return CryptosListViewModel(apiService: apiService)
    }
}
